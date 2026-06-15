import 'dart:convert';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/model/request_model/edit_user_detail/edit_user_detail_request_model.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_Demographics_request_model.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_Interests_request_model.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_type_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/request_model/sigin/signin_request_model.dart';
import 'package:domain/model/response_model/edit_user_detail/edit_user_detail_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_complete_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_details_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_user_demographics_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_user_interests_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_user_type_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/model/response_model/sigin_model/sigin_response_model.dart';
import 'package:domain/usecase/edit_user_detail/edit_user_detail_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_complete_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_demographics_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_interests_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_type_usecase.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:domain/usecase/sigin/sigin_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/common_widgets/translate_message.dart';
import 'package:kusel/firebase_api.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/providers/extract_deviceId/extract_deviceId_provider.dart';
import 'package:kusel/screens/auth/signin/signin_state.dart';

final signInScreenProvider = StateNotifierProvider
    .autoDispose<SignInController, SignInState>((ref) => SignInController(
        ref: ref,
        signInUseCase: ref.read(signInUseCaseProvider),
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
        tokenStatus: ref.read(tokenStatusProvider),
        refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider),
        onboardingUserTypeUseCase: ref.read(onboardingUserTypeUseCaseProvider),
        onboardingUserDemographicsUseCase:
            ref.read(onboardingUserDemographicsUseCaseProvider),
        onboardingUserInterestsUseCase:
            ref.read(onboardingUserInterestsUseCaseProvider),
        onboardingCompleteUseCase: ref.read(onboardingCompleteUseCaseProvider),
        editUserDetailUseCase: ref.read(editUserDetailUseCaseProvider),
        translateErrorMessage: ref.watch(translateErrorMessageProvider),
        extractDeviceIdProvider: ref.read(extractDeviceIdProvider),
        firebaseApiHelper: ref.read(firebaseApiProvider)));

class SignInController extends StateNotifier<SignInState> {
  Ref ref;
  SignInUseCase signInUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;
  OnboardingUserTypeUseCase onboardingUserTypeUseCase;
  OnboardingUserDemographicsUseCase onboardingUserDemographicsUseCase;
  OnboardingUserInterestsUseCase onboardingUserInterestsUseCase;
  OnboardingCompleteUseCase onboardingCompleteUseCase;
  EditUserDetailUseCase editUserDetailUseCase;
  TranslateErrorMessage translateErrorMessage;
  ExtractDeviceIdProvider extractDeviceIdProvider;
  FirebaseApi firebaseApiHelper;

  SignInController(
      {required this.ref,
        required this.signInUseCase,
      required this.sharedPreferenceHelper,
      required this.tokenStatus,
      required this.refreshTokenUseCase,
      required this.onboardingUserTypeUseCase,
      required this.onboardingUserDemographicsUseCase,
      required this.onboardingUserInterestsUseCase,
      required this.onboardingCompleteUseCase,
      required this.editUserDetailUseCase,
      required this.translateErrorMessage,
      required this.extractDeviceIdProvider,
      required this.firebaseApiHelper
      })
      : super(SignInState.empty());

  updateShowPassword(bool value) {
    state = state.copyWith(showPassword: value);
  }

  Future<void> sigInUser(
      {required String userName,
      required String password,
      required void Function() success,
      required void Function(String message) error}) async {


    try {
      state = state.copyWith(showLoading: true);

      final deviceId = await extractDeviceIdProvider.extractDeviceId();

      SignInRequestModel sigInRequestModel = SignInRequestModel(
          username: userName, password: password, deviceId: deviceId);

      SignInResponseModel signInResponseModel = SignInResponseModel();

      final result =
          await signInUseCase.call(sigInRequestModel, signInResponseModel);

      result.fold((l) async {
        final text =
            await translateErrorMessage.translateErrorMessage(l.toString());
        state = state.copyWith(showLoading: false);
        error(text);
        debugPrint('sign in user fold Exception = $l');
      }, (r) async {
        state = state.copyWith(showLoading: false);
        final response = (r as SignInResponseModel);

        if (response.data != null) {
          final userId = response.data?.userId ?? 0;
          final token = response.data?.accessToken ?? "";
          final refreshToken = response.data?.refreshToken ?? "";
          bool isGuestOnboardingDone =
              sharedPreferenceHelper.getBool(onboardingKey) ?? false;
          final isOnboardingComplete = isGuestOnboardingDone
              ? true
              : response.data?.isOnBoarded ?? false;

          await sharedPreferenceHelper.setString(refreshTokenKey, refreshToken);
          await sharedPreferenceHelper.setString(tokenKey, token);
          await sharedPreferenceHelper.setInt(userIdKey, userId);
          await sharedPreferenceHelper.setBool(
              onboardingKey, isOnboardingComplete);
          await sharedPreferenceHelper.setBool(isUserSignedIn, true);
          // Logging out guest user
          MatomoService.clearUser();
          MatomoService.trackLoginSuccess(
              userId: userId.toString());
          MatomoService.trackLogin(userId: userId.toString());
          firebaseApiHelper.uploadFcmAfterLogin();
          success();
        }
      });
    } catch (error) {
      state = state.copyWith(showLoading: false);
      debugPrint(' Exception = $error');
    }
  }

  Future<bool> isOnboardingDone() async {
    bool onBoardingStatus =
        sharedPreferenceHelper.getBool(onboardingKey) ?? false;
    bool isOnBoarded = onBoardingStatus;
    if (!isOnBoarded && isOnboardingCacheAvailable()) {
      isOnBoarded = true;
    }
    return isOnBoarded;
  }

  Future<void> syncOnboardingDataWithNetwork() async {
    state = state.copyWith(showLoading: true);
    final jsonOnboardingDataString = sharedPreferenceHelper
        .getString(onboardingCacheKey); // gets raw JSON string
    if (jsonOnboardingDataString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonOnboardingDataString);
      final onboardingData = OnboardingData.fromJson(jsonMap);

      try {
        final response = tokenStatus.isAccessTokenExpired();
        if (response) {
          RefreshTokenRequestModel requestModel =
              RefreshTokenRequestModel();
          RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();

          final refreshResponse =
              await refreshTokenUseCase.call(requestModel, responseModel);

          bool refreshSuccess = await refreshResponse.fold(
            (left) {
              debugPrint(
                  'refresh token municipality detail fold exception : $left');
              return false;
            },
            (right) async {
              final res = right as RefreshTokenResponseModel;
              await sharedPreferenceHelper.setString(
                  tokenKey, res.data?.accessToken ?? "");
              await sharedPreferenceHelper.setString(
                  refreshTokenKey, res.data?.refreshToken ?? "");
              return true;
            },
          );

          if (!refreshSuccess) {
            // state = state.copyWith(isLoading: false);
            return;
          }
        }
        await editUserName(onSuccess: () {}, onError: (msg) {});
        await updateOnboardingUserType(onboardingData);
        await updateOnboardingUserDemographics(onboardingData);
        await updateOnboardingUserInterests(onboardingData);
        await updateOnboardingSuccess();
        sharedPreferenceHelper.setString(onboardingCacheKey, "");
        state = state.copyWith(showLoading: false);
      } catch (error) {
        debugPrint('update onboarding user type exception : $error');
      }
    }
  }

  Future<void> updateOnboardingUserType(OnboardingData onboardingData) async {
    OnboardingUserTypeRequestModel onboardingUserTypeRequestModel =
        OnboardingUserTypeRequestModel(userType: onboardingData.userType);
    OnboardingUserTypeResponseModel onboardingUserTypeResponseModel =
        OnboardingUserTypeResponseModel();
    final r = await onboardingUserTypeUseCase.call(
        onboardingUserTypeRequestModel, onboardingUserTypeResponseModel);
    r.fold((l) {
      debugPrint('update onboarding user type fold exception : $l');
    }, (r) async {
      final result = r as OnboardingUserTypeResponseModel;
    });
  }

  Future<void> updateOnboardingUserDemographics(
      OnboardingData onboardingData) async {
    OnboardingUserDemographicsRequestModel
        onboardingUserDemographicsRequestModel =
        OnboardingUserDemographicsRequestModel(
            maritalStatus: onboardingData.maritalStatus,
            accommodationPreference: onboardingData.accommodationPreference,
            cityId: onboardingData.cityId);
    OnboardingUserDemographicsResponseModel
        onboardingUserDemographicsResponseModel =
        OnboardingUserDemographicsResponseModel();
    final r = await onboardingUserDemographicsUseCase.call(
        onboardingUserDemographicsRequestModel,
        onboardingUserDemographicsResponseModel);
    r.fold((l) {
      debugPrint('update onboarding user demographics fold exception : $l');
    }, (r) async {
      final result = r as OnboardingUserDemographicsResponseModel;
    });
  }

  Future<void> updateOnboardingUserInterests(
      OnboardingData onboardingData) async {
    OnboardingUserInterestsRequestModel onboardingUserInterestsRequestModel =
        OnboardingUserInterestsRequestModel(
            interestIds: onboardingData.interests);
    OnboardingUserInterestsResponseModel onboardingUserInterestsResponseModel =
        OnboardingUserInterestsResponseModel();
    final r = await onboardingUserInterestsUseCase.call(
        onboardingUserInterestsRequestModel,
        onboardingUserInterestsResponseModel);
    r.fold((l) {
      debugPrint('update onboarding user interests fold exception : $l');
    }, (r) async {
      final result = r as OnboardingUserInterestsResponseModel;
    });
  }

  Future<void> updateOnboardingSuccess() async {
    sharedPreferenceHelper.setBool(onboardingKey, true);
    try {
      final response = tokenStatus.isAccessTokenExpired();
      if (response) {
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();
        RefreshTokenRequestModel requestModel =
            RefreshTokenRequestModel();
        final result =
            await refreshTokenUseCase.call(requestModel, responseModel);
        result.fold((l) {
          // state = state.copyWith(loading: false);
        }, (right) async {
          final res = right as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");
          EmptyRequest requestModel = EmptyRequest();
          OnboardingCompleteResponseModel responseModel =
              OnboardingCompleteResponseModel();
          final r =
              await onboardingCompleteUseCase.call(requestModel, responseModel);
          r.fold((l) {
            debugPrint('onboarding complete fold exception : $l');
          }, (r) async {
            final result = r as OnboardingCompleteResponseModel;
          });
        });
      } else {
        EmptyRequest requestModel = EmptyRequest();
        OnboardingCompleteResponseModel responseModel =
            OnboardingCompleteResponseModel();
        final r =
            await onboardingCompleteUseCase.call(requestModel, responseModel);
        r.fold((l) {
          debugPrint('onboarding complete fold exception : $l');
        }, (r) async {
          final result = r as OnboardingCompleteResponseModel;
        });
      }
    } catch (error) {
      debugPrint('onboarding complete exception : $error');
    }
  }

  bool isOnboardingCacheAvailable() {
    bool value = sharedPreferenceHelper.getString(onboardingCacheKey) != null;
    return value;
  }

  Future<void> editUserName(
      {required void Function() onSuccess,
      required void Function(String msg) onError}) async {
    final response = tokenStatus.isAccessTokenExpired();
    if (response) {
      RefreshTokenRequestModel requestModel =
          RefreshTokenRequestModel();
      RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();

      final refreshResponse =
          await refreshTokenUseCase.call(requestModel, responseModel);

      bool refreshSuccess = await refreshResponse.fold(
        (left) {
          debugPrint(
              'refresh token edit profile details fold exception : $left');
          return false;
        },
        (right) async {
          final res = right as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");
          return true;
        },
      );

      if (!refreshSuccess) {
        state = state.copyWith(showLoading: false);
        return;
      }
    }

    EditUserDetailRequestModel editUserDetailRequestModel =
        EditUserDetailRequestModel();
    final userFirstName = sharedPreferenceHelper.getString(userFirstNameKey);
    editUserDetailRequestModel.firstname = userFirstName;

    try {
      EditUserDetailsResponseModel editUserDetailsResponseModel =
          EditUserDetailsResponseModel();
      final result = await editUserDetailUseCase.call(
          editUserDetailRequestModel, editUserDetailsResponseModel);
      result.fold((l) {
        debugPrint(l.toString());
        onError(l.toString());
      }, (r) async {
        var resData = (r as EditUserDetailsResponseModel).status;
        debugPrint("Edit Api Result : $resData");
        onSuccess();
        debugPrint("Edit API Success");
      });
    } catch (error) {
      debugPrint(error.toString());
      onError("API Error - ${error.toString()}");
    }
  }

// Future<void> getUserDetails() async {
//   try {
//     state = state.copyWith(show: true);
//     final response = tokenStatus.isAccessTokenExpired();
//
//     if (response) {
//       final userId = sharedPreferenceHelper.getInt(userIdKey);
//       RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();
//       RefreshTokenRequestModel requestModel =
//       RefreshTokenRequestModel(userId: userId?.toString() ?? "");
//       final result =
//       await refreshTokenUseCase.call(requestModel, responseModel);
//
//       result.fold((l) {
//         state = state.copyWith(loading: false);
//       }, (r) async {
//         final res = r as RefreshTokenResponseModel;
//         sharedPreferenceHelper.setString(
//             tokenKey, res.data?.accessToken ?? "");
//         sharedPreferenceHelper.setString(
//             refreshTokenKey, res.data?.refreshToken ?? "");
//
//         UserDetailRequestModel requestModel = UserDetailRequestModel(
//             id: sharedPreferenceHelper.getInt(userIdKey));
//         UserDetailResponseModel responseModel = UserDetailResponseModel();
//         final result =
//         await userDetailUseCase.call(requestModel, responseModel);
//         result.fold((l) {
//           debugPrint('get user details fold exception : $l');
//         }, (r) async {
//           final response = r as UserDetailResponseModel;
//           await sharedPreferenceHelper.setString(
//               userFirstNameKey, response.data?.firstname ?? "");
//           state = state.copyWith(
//               loading: false);
//         });
//       });
//     } else {
//       UserDetailRequestModel requestModel = UserDetailRequestModel(
//           id: sharedPreferenceHelper.getInt(userIdKey));
//       UserDetailResponseModel responseModel = UserDetailResponseModel();
//       final result =
//       await userDetailUseCase.call(requestModel, responseModel);
//
//       result.fold((l) {
//         debugPrint('get user details fold exception : $l');
//       }, (r) async {
//         final response = r as UserDetailResponseModel;
//         await sharedPreferenceHelper.setString(
//             userFirstNameKey, response.data?.firstname ?? "");
//         state = state.copyWith(
//             loading: false);
//       });
//     }
//   } catch (error) {
//     debugPrint('get user details exception : $error');
//     state = state.copyWith(loading: false);
//   }
// }
}
