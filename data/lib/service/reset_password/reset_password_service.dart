import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../end_points.dart';

final resetPasswordServiceProvider = Provider((ref) => ResetPasswordService(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class ResetPasswordService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  ResetPasswordService(
      {required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final request = requestModel.toJson();

    String token = sharedPreferenceHelper.getString(tokenKey) ?? '';
    final headers = {'Authorization': 'Bearer $token'};

    final body = {
      "oldPassword": request['oldPassword'],
      "newPassword": request['newPassword']
    };

    final apiHelper = ref.read(apiHelperProvider);

    final result = await apiHelper.postRequest(
        path: resetPasswordEndPoint,
        body: body,
        create: () => responseModel,
        headers: headers);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
