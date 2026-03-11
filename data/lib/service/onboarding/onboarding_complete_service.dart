import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

final onboardingCompleteServiceProvider = Provider((ref) =>
    OnboardingCompleteService(
        ref: ref,
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class OnboardingCompleteService {
  SharedPreferenceHelper sharedPreferenceHelper;
  Ref ref;

  OnboardingCompleteService(
      {required this.sharedPreferenceHelper, required this.ref});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {

    final path =
        "$userDetailsEndPoint$onboardingCompleteEndpoint";
    final apiHelper = ref.read(apiHelperProvider);
    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';

    final headers = {'Authorization': 'Bearer $token'};

    final result = await apiHelper.postRequest(
        path: path,
        create: () => responseModel,
        body: requestModel.toJson(),
        headers: headers);

    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }
}
