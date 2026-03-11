import 'package:core/base_model.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:data/dio_helper_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final refreshTokenServiceProvider = Provider((ref) => RefreshTokenService(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class RefreshTokenService {
  Ref ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  RefreshTokenService(
      {required this.ref, required this.sharedPreferenceHelper});

  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final path = "/users/refresh";
    final refreshToken = sharedPreferenceHelper.getString(refreshTokenKey)??'';

    final body = {
      "refreshToken":refreshToken
    };

    final apiHelper = ref.read(apiHelperProvider);


    final result =
        await apiHelper.postRequest(path: path, body: body,create: () => responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
