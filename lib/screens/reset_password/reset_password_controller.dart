import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/reset_password/reset_password_request_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:kusel/providers/refresh_token_provider.dart';
import 'package:kusel/screens/reset_password/reset_password_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/usecase/reset_password/reset_password_usecase.dart';
import 'package:domain/model/response_model/reset_password/reset_password_response_model.dart';

import '../../common_widgets/translate_message.dart';

final resetPasswordControllerProvider = StateNotifierProvider.autoDispose<
    ResetPasswordController,
    ResetPasswordState>(
      (ref) =>
      ResetPasswordController(
          sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
          resetPasswordUseCase: ref.read(resetPasswordUseCaseProvider),
          tokenStatus: ref.read(tokenStatusProvider),
          refreshTokenProvider: ref.read(refreshTokenProvider),
          translateErrorMessage: ref.watch(translateErrorMessageProvider),
          signInStatusController: ref.read(signInStatusProvider.notifier)),
);

class ResetPasswordController extends StateNotifier<ResetPasswordState> {
  ResetPasswordUseCase resetPasswordUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  SignInStatusController signInStatusController;
  TokenStatus tokenStatus;
  RefreshTokenProvider refreshTokenProvider;
  TranslateErrorMessage translateErrorMessage;


  ResetPasswordController({required this.sharedPreferenceHelper,
    required this.resetPasswordUseCase,
    required this.refreshTokenProvider,
    required this.tokenStatus,
    required this.signInStatusController,
    required this.translateErrorMessage
  })
      : super(ResetPasswordState.empty());

  Future<void> newPasswordValidation(String value) async {
    final hasUppercase = RegExp(r'[A-Z]');
    final hasLowercase = RegExp(r'[a-z]');
    final hasDigit = RegExp(r'\d');
    final hasSpecialChar = RegExp(r'[!@#\$&*~_.,;:?<>%^+=\-]');
    final hasMinLength = value.length >= 8;

    state = state.copyWith(
        isAtLeast8CharacterComplete: hasMinLength,
        isHaveNumberComplete: hasDigit.hasMatch(value),
        isLowerCaseUpperCaseComplete:
        hasUppercase.hasMatch(value) && hasLowercase.hasMatch(value),
        isSpecialCharacterComplete: hasSpecialChar.hasMatch(value));
  }

  showCurrentPassword(bool value) {
    state = state.copyWith(showCurrentPassword: value);
  }

  showNewsPassword(bool value) {
    state = state.copyWith(showNewPassword: value);
  }

  showConfirmNewsPassword(bool value) {
    state = state.copyWith(showConfirmNewPassword: value);
  }

  void isFormValid(String currentPassword, String newPassword,
      String confirmNewPassword) {
    final result = currentPassword.isNotEmpty &&
        newPassword.isNotEmpty &&
        confirmNewPassword.isNotEmpty &&
        newPassword == confirmNewPassword;

    state = state.copyWith(showButton: result);
  }

  resetPassword(String newPassword, String oldPassword,
      void Function() onSuccess, void Function(String) onError) async {
    try {
      final status = tokenStatus.isAccessTokenExpired();
      final isUserSignedIn = await signInStatusController.isUserLoggedIn();

      if (status && isUserSignedIn) {
        refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () {
              _resetPassword(newPassword, oldPassword, onSuccess, onError);
            });
      } else {
        _resetPassword(newPassword, oldPassword, onSuccess, onError);
      }
    } catch (error) {
      debugPrint('refresh token reset password exception:$error');
    }
  }

  _resetPassword(String newPassword, String oldPassword,
      void Function() onSuccess, void Function(String) onError) async {
    try {
      state = state.copyWith(isLoading: true);
      ResetPasswordRequestModel requestModel = ResetPasswordRequestModel(
          newPassword: newPassword, oldPassword: oldPassword);
      ResetPasswordResponseModel responseModel = ResetPasswordResponseModel();

      final response =
      await resetPasswordUseCase.call(requestModel, responseModel);

      response.fold((l) async {
        final errorText =
        await translateErrorMessage.translateErrorMessage(l.toString());
        onError(errorText);
        debugPrint('reset password fold exception : $l');
        state = state.copyWith(isLoading: false);
      }, (r) {
        state = state.copyWith(isLoading: false);
        onSuccess();
      });
    } catch (error) {
      debugPrint('reset password exception : $error');
      state = state.copyWith(isLoading: false);
    }
  }
}
