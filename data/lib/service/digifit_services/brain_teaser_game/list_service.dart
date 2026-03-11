import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../end_points.dart';

final brainTeaserGameListServiceProvider = Provider((ref) =>
    BrainTeaserGameListService(
        ref: ref,
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class BrainTeaserGameListService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  BrainTeaserGameListService(
      {required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final params = requestModel.toJson();
    final path =
        "$brainTeaserGameListEndPoint?translate=${params["translate"]}";

    final apiHelper = ref.read(apiHelperProvider);
    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};

    final result = await apiHelper.getRequest(
        path: path, create: () => responseModel, headers: headers);

    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }
}
