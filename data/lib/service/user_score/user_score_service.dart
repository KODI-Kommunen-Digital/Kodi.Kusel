import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userScoreServiceProvider = Provider((ref) => UserScoreService(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class UserScoreService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  UserScoreService({required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final path =
        userScoreEndPoint;
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
