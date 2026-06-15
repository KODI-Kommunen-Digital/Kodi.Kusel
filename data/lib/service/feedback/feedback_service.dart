import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:data/end_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedBackServiceProvider = Provider((ref) => FeedBackService(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class FeedBackService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  FeedBackService({required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final apiHelper = ref.read(apiHelperProvider);

    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';

    final headers = {'Authorization': 'Bearer $token'};
    final result = await apiHelper.postRequest(
        path: feedbackEndpoint,
        create: () => responseModel,
        body: requestModel.toJson(),
        headers: headers);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
