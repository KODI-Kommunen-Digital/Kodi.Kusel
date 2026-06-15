import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/delete_account/delete_account_request_model.dart';
import 'package:domain/model/response_model/delete_account/delete_account_response_model.dart';
import 'package:domain/usecase/delete_account/delete_account_usecase.dart';
import 'package:domain/usecase/edit_user_detail/edit_user_detail_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/locale_constant.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/providers/guest_user_login_provider.dart';
import 'package:kusel/providers/refresh_token_provider.dart';
import 'package:kusel/screens/home/home_screen_provider.dart';
import 'package:kusel/screens/settings/settings_screen_state.dart';

import '../../matomo_api.dart';

final settingsScreenProvider =
    StateNotifierProvider<SettingsScreenProvider, SettingsScreenState>((ref) =>
        SettingsScreenProvider(
            localeManagerController: ref.read(localeManagerProvider.notifier),
            sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
            editUserDetailUseCase: ref.read(editUserDetailUseCaseProvider),
            homeScreenProvider: ref.read(homeScreenProvider.notifier),
            signInStatusController: ref.read(signInStatusProvider.notifier),
            deleteAccountUseCase: ref.read(deleteAccountUseCaseProvider),
            refreshTokenProvider: ref.read(refreshTokenProvider),
            tokenStatus: ref.read(tokenStatusProvider),
            guestUserLogin: ref.read(guestUserLoginProvider)));

class SettingsScreenProvider extends StateNotifier<SettingsScreenState> {
  LocaleManagerController localeManagerController;
  SharedPreferenceHelper sharedPreferenceHelper;
  EditUserDetailUseCase editUserDetailUseCase;
  HomeScreenProvider homeScreenProvider;
  SignInStatusController signInStatusController;
  DeleteAccountUseCase deleteAccountUseCase;
  RefreshTokenProvider refreshTokenProvider;
  TokenStatus tokenStatus;
  GuestUserLogin guestUserLogin;

  SettingsScreenProvider(
      {required this.localeManagerController,
      required this.sharedPreferenceHelper,
      required this.editUserDetailUseCase,
      required this.homeScreenProvider,
      required this.signInStatusController,
      required this.deleteAccountUseCase,
      required this.refreshTokenProvider,
      required this.tokenStatus,
      required this.guestUserLogin})
      : super(SettingsScreenState.empty());

  logoutUser(Future<void> Function() callBack,
      {VoidCallback? onSuccess}) async {
    state = state.copyWith(isLoading: true);
    MatomoService.trackLogout(
        userId: sharedPreferenceHelper.getInt(userIdKey).toString());
    await sharedPreferenceHelper.clear();
    await callBack();

    await guestUserLogin.getGuestUserToken();
    state = state.copyWith(isLoading: false);

    if (onSuccess != null) {
      onSuccess();
    }
  }

  void fetchCurrentLanguage() {
    final savedLanguageCode = sharedPreferenceHelper.getString(languageKey);

    if (savedLanguageCode != null) {
      if (savedLanguageCode == LocaleConstant.english.languageCode) {
        state = state.copyWith(
            selectedLanguage: LocaleConstant.english.displayName);
      } else if (savedLanguageCode == LocaleConstant.german.languageCode) {
        state =
            state.copyWith(selectedLanguage: LocaleConstant.german.displayName);
      }
    } else {
      final languageCode =
          localeManagerController.getSelectedLocale().languageCode;

      if (languageCode == LocaleConstant.english.languageCode) {
        state = state.copyWith(
            selectedLanguage: LocaleConstant.english.displayName);
      } else if (languageCode == LocaleConstant.german.languageCode) {
        state =
            state.copyWith(selectedLanguage: LocaleConstant.german.displayName);
      }
    }
  }

  changeLanguage({required String selectedLanguage}) {
    state = state.copyWith(selectedLanguage: selectedLanguage);

    String languageCode = "";
    String region = "";

    if (LocaleConstant.english.displayName == selectedLanguage) {
      languageCode = LocaleConstant.english.languageCode;
      region = LocaleConstant.english.region;
    } else if (LocaleConstant.german.displayName == selectedLanguage) {
      languageCode = LocaleConstant.german.languageCode;
      region = LocaleConstant.german.region;
    }
    localeManagerController.updateSelectedLocale(Locale(languageCode, region));
  }

  Future<void> isLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();
    state = state.copyWith(isLoggedIn: status);
  }

  Future<void> deleteAccount(
      void Function() onSuccess, void Function(String) onError) async {
    try {
      final status = tokenStatus.isAccessTokenExpired();

      if (status) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () {
              _deleteUser(onSuccess, onError);
            });
      } else {
        _deleteUser(onSuccess, onError);
      }
    } catch (e) {
      debugPrint('delete account exception');
    }
  }

  _deleteUser(void Function() onSuccess, void Function(String) onError) async {
    final token = sharedPreferenceHelper.getString(tokenKey);

    DeleteAccountRequestModel requestModel = DeleteAccountRequestModel(token: token ?? '');

    DeleteAccountResponseModel responseModel = DeleteAccountResponseModel();

    final result = await deleteAccountUseCase.call(requestModel, responseModel);

    result.fold((left) {
      debugPrint('delete account fold exception = $left');
      onError(left.toString());
    }, (right) async {
      final res = right as DeleteAccountResponseModel;

      debugPrint("delete account response  = ${res.status}");
      await logoutUser(() async {
        await isLoggedIn();
        await homeScreenProvider.getLoginStatus();
      });
      onSuccess();
    });
  }
}
