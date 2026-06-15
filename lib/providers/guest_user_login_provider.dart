import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/request_model/guest_user_login/guest_user_login_request_model.dart';
import 'package:domain/model/response_model/guest_user_login/guest_user_login_response_model.dart';
import 'package:domain/usecase/guest_user_login/guest_user_login_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/firebase_api.dart';
import 'package:kusel/matomo_api.dart';

import 'extract_deviceId/extract_deviceId_provider.dart';

final guestUserLoginProvider = Provider((ref) => GuestUserLogin(
    guestUserLoginUseCase: ref.read(guestUserLoginUseCaseProvider),
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
    extractDeviceIdProvider: ref.read(extractDeviceIdProvider),
    firebaseApiHelper: ref.read(firebaseApiProvider)
));

class GuestUserLogin {
  GuestUserLoginUseCase guestUserLoginUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  ExtractDeviceIdProvider extractDeviceIdProvider;
  FirebaseApi firebaseApiHelper;

  GuestUserLogin(
      {required this.guestUserLoginUseCase,
      required this.sharedPreferenceHelper,
      required this.extractDeviceIdProvider,
      required this.firebaseApiHelper
      });

  getGuestUserToken({Future<void> Function()? onSuccess}) async {
    try {
      String? deviceId = await extractDeviceIdProvider.extractDeviceId();
      if (deviceId != null) {
        GuestUserLoginRequestModel requestModel =
            GuestUserLoginRequestModel(deviceId: deviceId);
        GuestUserLoginResponseModel responseModel =
            GuestUserLoginResponseModel();
        final response =
            await guestUserLoginUseCase.call(requestModel, responseModel);

        response.fold((l) {
          debugPrint('guest user token fold exception = ${l.toString()}');
        }, (r) async{
          final res = r as GuestUserLoginResponseModel;

          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? '');

          sharedPreferenceHelper.setInt(
              userIdKey, res.data?.userId ?? 0);
          MatomoService.trackLoginSuccess(
              userId: res.data?.userId.toString() ?? "0");
          await firebaseApiHelper.uploadFcmAfterLogin();
          if(onSuccess!=null)
            {
              await onSuccess();
            }

        });
      }
    } catch (error) {
      debugPrint('guest user token exception = $error');
    }
  }
}
