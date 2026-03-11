import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final modifyFavouriteCityServiceProvider = Provider((ref) => ModifyFavouriteCityService(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class ModifyFavouriteCityService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  ModifyFavouriteCityService({required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> addFavourite(
      BaseModel requestModel, BaseModel responseModel) async {

    final path =
        "$userDetailsEndPoint$favouriteCitiesPath$ortDetailEndPoint";
    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};

    final apiHelper = ref.read(apiHelperProvider);

    final result = await apiHelper.postRequest(
        path: path,
        create: () => responseModel,
        headers: headers,
        body: requestModel.toJson()
    );

    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }

  Future<Either<Exception, BaseModel>> deleteFavourite(
      BaseModel requestModel, BaseModel responseModel) async {
    final path =
        "$userDetailsEndPoint$favouriteCitiesPath$ortDetailEndPoint/${requestModel.toJson()['cityId']}";
    final apiHelper = ref.read(apiHelperProvider);
    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};

    final result =
    await apiHelper.delete(
        path: path,
        headers: headers,
        create: () => responseModel,
    );

    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }
}
