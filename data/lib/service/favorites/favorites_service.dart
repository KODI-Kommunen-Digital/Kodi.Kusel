import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesServiceProvider = Provider((ref) => FavoritesService(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class FavoritesService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  FavoritesService({required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);

    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};

    final queryParams = requestModel
        .toJson()
        .entries
        .where((e) => e.value != null)
        .map((e) => "${e.key}=${Uri.encodeComponent(e.value.toString())}")
        .join("&");

    final path =
        "$getFavoritesListingEndpoint?$queryParams";

    final result = await apiHelper.getRequest(
        path: path, create: () => responseModel, headers: headers);

    return result.fold((l) => Left(l), (r) => Right(r));
  }

  Future<Either<Exception, BaseModel>> addFavorite(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);

    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};

    final result = await apiHelper.postRequest(
        path: getFavoritesEndpoint,
        create: () => responseModel,
        headers: headers,
        body: requestModel.toJson());

    return result.fold((l) => Left(l), (r) => Right(r));
  }

  Future<Either<Exception, BaseModel>> deleteFavorite(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);
    final listingId = requestModel.toJson()["id"];
    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};

    final result = await apiHelper.delete(
        path: deleteFavoritesEndpoint(listingId.toString()),
        headers: headers,
        create: () => responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
