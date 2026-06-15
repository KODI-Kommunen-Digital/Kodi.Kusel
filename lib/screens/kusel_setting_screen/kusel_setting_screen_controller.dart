import 'dart:io';
import 'dart:ui';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/delete_account/delete_account_request_model.dart';
import 'package:domain/model/request_model/edit_user_detail/edit_user_detail_request_model.dart';
import 'package:domain/model/request_model/get_legal_policy/get_legal_policy_request_model.dart';
import 'package:domain/model/request_model/user_detail/user_detail_request_model.dart';
import 'package:domain/model/request_model/user_score/user_score_request_model.dart';
import 'package:domain/model/response_model/delete_account/delete_account_response_model.dart';
import 'package:domain/model/response_model/edit_user_detail/edit_user_detail_response_model.dart';
import 'package:domain/model/response_model/user_detail/user_detail_response_model.dart';
import 'package:domain/usecase/delete_account/delete_account_usecase.dart';
import 'package:domain/usecase/edit_user_detail/edit_user_detail_usecase.dart';
import 'package:domain/usecase/user_detail/user_detail_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/providers/guest_user_login_provider.dart';
import 'package:kusel/providers/refresh_token_provider.dart';
import 'package:kusel/screens/home/home_screen_provider.dart';
import 'package:kusel/screens/kusel_setting_screen/kusel_setting_state.dart';
import 'package:domain/usecase/user_score/user_score_usecase.dart';
import 'package:kusel/screens/kusel_setting_screen/poilcy_type.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../common_widgets/translate_message.dart';
import '../../locale/locale_constant.dart';
import 'package:domain/model/response_model/user_score/user_score_response_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:domain/usecase/get_legal_policy/get_legal_policy_use_case.dart';
import 'package:domain/model/response_model/get_legal_policy/get_legal_policy_response_model.dart';

final kuselSettingScreenProvider =
    StateNotifierProvider<KuselSettingScreenController, KuselSettingState>(
        (ref) => KuselSettingScreenController(
            localeManagerController: ref.read(localeManagerProvider.notifier),
            signInStatusController: ref.read(signInStatusProvider.notifier),
            sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
            guestUserLogin: ref.read(guestUserLoginProvider),
            userScoreUseCase: ref.read(userScoreUseCaseProvider),
            tokenStatus: ref.read(tokenStatusProvider),
            refreshTokenProvider: ref.read(refreshTokenProvider),
            deleteAccountUseCase: ref.read(deleteAccountUseCaseProvider),
            getLegalPolicyUseCase: ref.read(getLegalPolicyUseCaseProvider),
            homeScreenProvider: ref.read(homeScreenProvider.notifier),
            userDetailUseCase: ref.read(userDetailUseCaseProvider),
            translateErrorMessage: ref.read(translateErrorMessageProvider),
            editUserDetailUseCase: ref.read(editUserDetailUseCaseProvider)));

class KuselSettingScreenController extends StateNotifier<KuselSettingState> {
  LocaleManagerController localeManagerController;
  SignInStatusController signInStatusController;
  SharedPreferenceHelper sharedPreferenceHelper;
  GuestUserLogin guestUserLogin;
  UserScoreUseCase userScoreUseCase;
  TokenStatus tokenStatus;
  RefreshTokenProvider refreshTokenProvider;
  DeleteAccountUseCase deleteAccountUseCase;
  GetLegalPolicyUseCase getLegalPolicyUseCase;
  HomeScreenProvider homeScreenProvider;
  UserDetailUseCase userDetailUseCase;
  EditUserDetailUseCase editUserDetailUseCase;
  TranslateErrorMessage translateErrorMessage;

  KuselSettingScreenController(
      {required this.localeManagerController,
      required this.signInStatusController,
      required this.sharedPreferenceHelper,
      required this.guestUserLogin,
      required this.userScoreUseCase,
      required this.tokenStatus,
      required this.refreshTokenProvider,
      required this.deleteAccountUseCase,
      required this.getLegalPolicyUseCase,
      required this.homeScreenProvider,
      required this.userDetailUseCase,
      required this.editUserDetailUseCase,
      required this.translateErrorMessage})
      : super(KuselSettingState.empty());

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

  changeLanguage({required String selectedLanguage}) async {
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

    state = state.copyWith(selectedLanguage: selectedLanguage);
    checkForChanges();
  }

  isUserLoggedIn() async {
    final ans = await signInStatusController.isUserLoggedIn();
    homeScreenProvider.getLoginStatus();
    state = state.copyWith(isUserLoggedIn: ans);
  }

  logoutUser(Future<void> Function() callBack,
      {VoidCallback? onSuccess, bool showIsLoading = true}) async {
    if (showIsLoading) {
      state = state.copyWith(isLoading: true);
    }
    await sharedPreferenceHelper.clear();
    await callBack();

    await guestUserLogin.getGuestUserToken(onSuccess: () async {
      await _getUserDetail();
    });
    if (showIsLoading) {
      state = state.copyWith(isLoading: false);
    }

    MatomoService.trackLogout(
        userId: sharedPreferenceHelper.getInt(userIdKey).toString());

    if (onSuccess != null) {
      onSuccess();
    }
  }

  getUserScore() async {
    try {
      state = state.copyWith(isLoading: true);
      UserScoreRequestModel requestModel = UserScoreRequestModel();
      UserScoreResponseModel responseModel = UserScoreResponseModel();

      final res = await userScoreUseCase.call(requestModel, responseModel);

      res.fold((l) {
        debugPrint('user score exception : $l');
        state = state.copyWith(isLoading: false);
      }, (r) {
        final result = r as UserScoreResponseModel;

        if (result.data != null) {
          state = state.copyWith(
              totalPoints: result.data?.totalPoints ?? 0,
              totalStamp: result.data?.stamp ?? 0);
        }
        state = state.copyWith(isLoading: false);
      });
    } catch (error) {
      debugPrint('user score exception : $error');
      state = state.copyWith(isLoading: false);
    }
  }

  getAppVersion() async {
    final obj = await PackageInfo.fromPlatform();

    final appVersion = obj.version;

    state = state.copyWith(appVersion: appVersion);
  }

  Future<void> deleteAccount(
      void Function() onSuccess, void Function(String) onError) async {
    try {
      state = state.copyWith(isProfilePageLoading: true);
      final status = tokenStatus.isAccessTokenExpired();
      MatomoService.trackDeleteAccount(
          userId: sharedPreferenceHelper.getInt(userIdKey).toString());

      if (status) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () async {
              await _deleteUser(onSuccess, onError);
            });
      } else {
        await _deleteUser(onSuccess, onError);
      }
    } catch (e) {
      debugPrint('delete account exception');
    }
  }

  _deleteUser(void Function() onSuccess, void Function(String) onError) async {
    final token = sharedPreferenceHelper.getString(tokenKey);

    DeleteAccountRequestModel requestModel =
        DeleteAccountRequestModel(token: token ?? '');

    DeleteAccountResponseModel responseModel = DeleteAccountResponseModel();

    final result = await deleteAccountUseCase.call(requestModel, responseModel);

    result.fold((left) async {
      debugPrint('delete account fold exception = $left');
      final text =
          await translateErrorMessage.translateErrorMessage(left.toString());

      state = state.copyWith(isProfilePageLoading: false);

      onError(text);
    }, (right) async {
      final res = right as DeleteAccountResponseModel;

      debugPrint("delete account response  = ${res.status}");
      await logoutUser(showIsLoading: false, () async {
        await isUserLoggedIn();
        await homeScreenProvider.getLoginStatus();
      });
      onSuccess();
      state = state.copyWith(isProfilePageLoading: false);
    });
  }

  getLegalPolicyData(PolicyType policyType) async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      state = state.copyWith(isLegalPolicyLoading: true, legalPolicyData: '');

      GetLegalPolicyRequestModel requestModel = GetLegalPolicyRequestModel(
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}",
          policyType: policyType.name);

      GetLegalPolicyResponseModel responseModel = GetLegalPolicyResponseModel();

      final res = await getLegalPolicyUseCase.call(requestModel, responseModel);

      res.fold((l) {
        debugPrint('get legal policy data fold exception:$l');
      }, (r) {
        final result = r as GetLegalPolicyResponseModel;

        if (result.data?.content != null) {
          state = state.copyWith(legalPolicyData: r.data?.content ?? '');
        }
      });
    } catch (error) {
      debugPrint('get legal policy data exception:$error');
    } finally {
      state = state.copyWith(isLegalPolicyLoading: false);
    }
  }

  void checkForChanges() {
    final hasChanges = state.name != state.initialName ||
        state.email != state.initialEmail ||
        state.mobileNumber != state.initialMobileNumber ||
        state.address != state.initialAddress ||
        state.selectedLanguage != state.initialLanguage ||
        state.isLocationPermissionGranted != state.initialLocationPermission;

    state = state.copyWith(hasChanges: hasChanges);
  }

  getUserDetail() async {
    try {
      state = state.copyWith(isProfilePageLoading: true);
      final status = tokenStatus.isAccessTokenExpired();

      if (status) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () async {
              await _getUserDetail();
            });
      } else {
        await _getUserDetail();
      }
    } catch (e) {
      debugPrint('delete account exception');
    } finally {
      if (state.isProfilePageLoading) {
        state = state.copyWith(isProfilePageLoading: false);
      }
    }
  }

  _getUserDetail() async {
    try {
      UserDetailRequestModel userDetailRequestModel = UserDetailRequestModel();
      UserDetailResponseModel userDetailResponseModel =
          UserDetailResponseModel();

      final res = await userDetailUseCase.call(
          userDetailRequestModel, userDetailResponseModel);

      res.fold((l) {
        debugPrint('get user detail fold exception:$l');
      }, (r) {
        final result = r as UserDetailResponseModel;

        if (result.data != null) {
          state = state.copyWith(
              listOfUserInterest: result.data?.interests ?? [],
              selectedOrt: result.data?.place?.name ?? '',
              name: result.data?.username ?? '',
              email: result.data?.email ?? '',
              address: result.data?.address ?? '',
              mobileNumber: result.data?.phoneNumber ?? '',
              initialEmail: result.data?.email,
              initialAddress: result.data?.address,
              initialMobileNumber: result.data?.phoneNumber,
              initialLanguage: state.selectedLanguage,
              initialLocationPermission: state.isLocationPermissionGranted,
              hasChanges: false);
        }
      });
    } catch (error) {
      rethrow;
    }
  }

  updateName(String value) {
    state = state.copyWith(name: value);
    checkForChanges();
  }

  updateEmail(String value) {
    state = state.copyWith(email: value);
    checkForChanges();
  }

  updatePhoneNumber(String value) {
    state = state.copyWith(mobileNumber: value);
    checkForChanges();
  }

  updateAddress(String value) {
    state = state.copyWith(address: value);
    checkForChanges();
  }

  updateUserDetails(
      {required Function() onSuccess,
      required Function(String) onError}) async {
    try {
      state = state.copyWith(isProfilePageLoading: true);
      final status = tokenStatus.isAccessTokenExpired();

      if (status) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () async {
              MatomoService.trackProfileUpdated(
                  userId: sharedPreferenceHelper.getInt(userIdKey).toString());
              await _updateUserDetails(onSuccess: onSuccess, onError: onError);
            });
      } else {
        MatomoService.trackProfileUpdated(
            userId: sharedPreferenceHelper.getInt(userIdKey).toString());
        await _updateUserDetails(onSuccess: onSuccess, onError: onError);
      }
    } catch (e) {
      debugPrint('update user detail exception: $e');
    } finally {
      state = state.copyWith(isProfilePageLoading: false);
    }
  }

  _updateUserDetails(
      {required Function() onSuccess,
      required Function(String) onError}) async {
    try {
      EditUserDetailRequestModel requestModel = EditUserDetailRequestModel(
          username: state.name.isEmpty ? null : state.name,
          email: state.email.isEmpty ? null : state.email,
          phoneNumber: state.mobileNumber.isEmpty ? null : state.mobileNumber,
          address: state.address.isEmpty ? null : state.address);
      EditUserDetailsResponseModel responseModel =
          EditUserDetailsResponseModel();

      final result =
          await editUserDetailUseCase.call(requestModel, responseModel);

      result.fold((l) async {
        debugPrint('edit user detail fold exception : $l');
        final text =
            await translateErrorMessage.translateErrorMessage(l.toString());
        onError(text);
      }, (r) {
        state = state.copyWith(
            initialName: state.name,
            initialEmail: state.email,
            initialMobileNumber: state.mobileNumber,
            initialAddress: state.address,
            initialLanguage: state.selectedLanguage,
            initialLocationPermission: state.isLocationPermissionGranted,
            hasChanges: false);
        onSuccess();
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getLocationPermissionStatus() async {
    try {
      PermissionStatus status;

      if (Platform.isIOS) {
        status = await Permission.locationWhenInUse.status;
      } else {
        status = await Permission.location.status;
      }

      final isGranted = status.isGranted || status.isLimited;

      state = state.copyWith(isLocationPermissionGranted: isGranted);
      if (state.initialName.isNotEmpty || state.initialEmail.isNotEmpty) {
        checkForChanges();
      }
    } catch (error) {
      debugPrint('exception getLocationPermissionStatus: $error');
    }
  }

  Future<bool> requestOrHandleLocationPermission(bool value) async {
    try {
      if (!value) {
        state = state.copyWith(isLocationPermissionGranted: false);
        return false;
      }

      PermissionStatus status = Platform.isIOS
          ? await Permission.locationWhenInUse.request()
          : await Permission.location.request();

      if (status.isGranted || status.isLimited) {
        state = state.copyWith(isLocationPermissionGranted: true);
        return true;
      }

      // Permission denied permanently or temporarily
      state = state.copyWith(isLocationPermissionGranted: false);
      return false;
    } catch (error) {
      debugPrint('Exception requestOrHandleLocationPermission : $error');
      return false;
    }
  }
}
