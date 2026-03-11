import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final refreshTokenProvider = Provider((ref) => RefreshTokenProvider(
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
    refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider)));

class RefreshTokenProvider {
  SharedPreferenceHelper sharedPreferenceHelper;

  RefreshTokenProvider({
    required this.sharedPreferenceHelper,
    required this.refreshTokenUseCase,
  });

  RefreshTokenUseCase refreshTokenUseCase;

  Future<void> getNewToken(
      {required void Function() onError,
      required void Function() onSuccess}) async {
    try {

      RefreshTokenRequestModel requestModel =
          RefreshTokenRequestModel();
      RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();

      final response =
          await refreshTokenUseCase.call(requestModel, responseModel);
      response.fold((l) {
        debugPrint('refresh token fold exception = $l');
        onError();
      }, (r) async{
        final res = r as RefreshTokenResponseModel;
        await sharedPreferenceHelper.setString(tokenKey, res.data?.accessToken ?? "");
        await sharedPreferenceHelper.setString(
            refreshTokenKey, res.data?.refreshToken ?? "");

        onSuccess();
      });
    } catch (error) {
      debugPrint('refresh token exception : $error');
      rethrow;
    }
  }

}
