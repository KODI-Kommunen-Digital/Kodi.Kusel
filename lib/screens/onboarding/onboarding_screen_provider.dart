import 'dart:async';
import 'dart:convert';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/model/request_model/city_details/get_city_details_request_model.dart';
import 'package:domain/model/request_model/edit_user_detail/edit_user_detail_request_model.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_Demographics_request_model.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_Interests_request_model.dart';
import 'package:domain/model/request_model/onboarding_model/onboarding_user_type_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/request_model/user_detail/user_detail_request_model.dart';
import 'package:domain/model/response_model/city_details/get_city_details_response_model.dart';
import 'package:domain/model/response_model/edit_user_detail/edit_user_detail_response_model.dart';
import 'package:domain/model/response_model/get_interests/get_interests_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_complete_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_details_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_user_demographics_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_user_interests_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_user_type_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/model/response_model/user_detail/user_detail_response_model.dart';
import 'package:domain/usecase/city_details/get_city_details_usecase.dart';
import 'package:domain/usecase/edit_user_detail/edit_user_detail_usecase.dart';
import 'package:domain/usecase/get_interests/get_interests_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_complete_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_detail_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_demographics_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_interests_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_user_type_usecase.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:domain/usecase/user_detail/user_detail_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/providers/guest_user_login_provider.dart';
import 'package:kusel/providers/refresh_token_provider.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_state.dart';

import '../../common_widgets/city_type_constant.dart';
import '../../common_widgets/get_current_location.dart';

final onboardingScreenProvider = StateNotifierProvider.autoDispose<
    OnboardingScreenController, OnboardingScreenState>(
        (ref) => OnboardingScreenController(
        onboardingUserTypeUseCase: ref.read(onboardingUserTypeUseCaseProvider),
        onboardingUserDemographicsUseCase:
        ref.read(onboardingUserDemographicsUseCaseProvider),
        onboardingUserInterestsUseCase:
        ref.read(onboardingUserInterestsUseCaseProvider),
        getCityDetailsUseCase: ref.read(getCityDetailsUseCaseProvider),
        getInterestsUseCase: ref.read(getInterestsUseCaseProvider),
        onboardingCompleteUseCase: ref.read(onboardingCompleteUseCaseProvider),
        onboardingDetailsUseCase: ref.read(onboardingDetailsUseCaseProvider),
        tokenStatus: ref.read(tokenStatusProvider),
        refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider),
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
        signInStatusController: ref.read(signInStatusProvider.notifier),
        editUserDetailUseCase: ref.read(editUserDetailUseCaseProvider),
        userDetailUseCase: ref.read(userDetailUseCaseProvider),
        guestUserLogin: ref.read(guestUserLoginProvider),
        refreshTokenProvider: ref.read(refreshTokenProvider)));

class OnboardingScreenController extends StateNotifier<OnboardingScreenState> {
  OnboardingScreenController(
      {required this.onboardingUserTypeUseCase,
        required this.onboardingUserDemographicsUseCase,
        required this.onboardingUserInterestsUseCase,
        required this.getCityDetailsUseCase,
        required this.getInterestsUseCase,
        required this.onboardingCompleteUseCase,
        required this.onboardingDetailsUseCase,
        required this.tokenStatus,
        required this.refreshTokenUseCase,
        required this.sharedPreferenceHelper,
        required this.signInStatusController,
        required this.editUserDetailUseCase,
        required this.userDetailUseCase,
        required this.guestUserLogin,
        required this.refreshTokenProvider})
      : super(OnboardingScreenState.empty());
  OnboardingUserTypeUseCase onboardingUserTypeUseCase;
  OnboardingUserDemographicsUseCase onboardingUserDemographicsUseCase;
  OnboardingUserInterestsUseCase onboardingUserInterestsUseCase;
  GetCityDetailsUseCase getCityDetailsUseCase;
  GetInterestsUseCase getInterestsUseCase;
  OnboardingCompleteUseCase onboardingCompleteUseCase;
  OnboardingDetailsUseCase onboardingDetailsUseCase;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  PageController pageController = PageController();
  TextEditingController yourLocationEditingController = TextEditingController();
  GlobalKey<FormState> onboardingNameFormKey = GlobalKey<FormState>();
  SignInStatusController signInStatusController;
  EditUserDetailUseCase editUserDetailUseCase;
  UserDetailUseCase userDetailUseCase;
  GuestUserLogin guestUserLogin;
  RefreshTokenProvider refreshTokenProvider;


  Future<void> initialCall() async {
    state = state.copyWith(isLoading: true);

    try {
      isLoggedIn();

      await Future.wait([
        updateCurrentCity(),
        fetchCities(),
        getInterests(),
      ]).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Initial calls timed out');
          return [];
        },
      );

    } catch (error) {
      debugPrint('Error in initialCall: $error');
    } finally {
      if (mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  // void initializerPageController() {
  //   pageController = PageController(
  //     initialPage: state.selectedPageIndex,
  //   );
  // }

  void updateErrorMsgStatus(bool value) {
    state = state.copyWith(isErrorMsgVisible: value);
  }

  void updateOnboardingType(OnBoardingType? onBoardingType) {
    if (onBoardingType == null) {
      state = state.copyWith(
        isResident: false,
        isTourist: false,
      );

      updateIsInterestScreenButtonVisibility(false);
      return;
    }

    state = state.copyWith(
      isResident: onBoardingType == OnBoardingType.resident,
      isTourist: onBoardingType == OnBoardingType.tourist,
    );

    updateIsInterestScreenButtonVisibility(true);
  }

  Future<void> updateCurrentCity() async {
    try {
      String? userCurrentCity = await fetchCity();
      state = state.copyWith(userCurrentCity: userCurrentCity);
    } catch (error) {
      debugPrint('fetch city exception : $error');
    }
  }

  Future<void> updateSelectedCity() async {
    String cityName = state.resident ?? '';
    int cityId = getCityIdByName(state.cityDetailsMap, cityName) ?? 0;
    if (cityId != 0) {
      await sharedPreferenceHelper.setInt(selectedCityIdKey, cityId);
    }
  }

  Future<void> updateOnboardingFamilyType(
      OnBoardingFamilyType onBoardingFamilyType) async {
    bool alreadySelected;
    switch (onBoardingFamilyType) {
      case OnBoardingFamilyType.single:
        alreadySelected = state.isSingle;
        break;
      case OnBoardingFamilyType.withTwo:
        alreadySelected = state.isForTwo;
        break;
      case OnBoardingFamilyType.withMyFamily:
        alreadySelected = state.isWithFamily;
        break;
    }

    state = state.copyWith(
      isSingle: onBoardingFamilyType == OnBoardingFamilyType.single
          ? !alreadySelected
          : false,
      isForTwo: onBoardingFamilyType == OnBoardingFamilyType.withTwo
          ? !alreadySelected
          : false,
      isWithFamily: onBoardingFamilyType == OnBoardingFamilyType.withMyFamily
          ? !alreadySelected
          : false,
    );

    updateIsOptionScreenButtonVisibility(
        state.isSingle || state.isForTwo || state.isWithFamily);
  }

  void updateUserType(String value) {
    state = state.copyWith(resident: value);
  }

  Future<void> fetchCities() async {
    try {
      GetCityDetailsRequestModel requestModel = GetCityDetailsRequestModel(
          hasForum: false, type: CityTypeConstant.city.name);
      GetCityDetailsResponseModel responseModel = GetCityDetailsResponseModel();
      final result =
      await getCityDetailsUseCase.call(requestModel, responseModel);

      result.fold((l) {
        debugPrint('get city details fold exception : $l');
      }, (r) async {
        final response = r as GetCityDetailsResponseModel;
        if (response.data != null) {
          final cityDetailsMap = <int, String>{};
          for (var city in response.data!) {
            if (city.id != null && city.name != null) {
              cityDetailsMap[city.id!] = city.name!;
            }
          }
          state = state.copyWith(
              residenceList: cityDetailsMap.values.toList(),
              cityDetailsMap: cityDetailsMap);
        }
      });
    } catch (error) {
      debugPrint('get city details exception : $error');
    }
  }

  Future<void> submitUserType() async {
    if (state.isTourist || state.isResident) {
      String userType = state.isResident ? "citizen" : "tourist";
      try {
        state = state.copyWith(loading: true);
        final response = tokenStatus.isAccessTokenExpired();
        if (response) {
          RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();
          RefreshTokenRequestModel requestModel = RefreshTokenRequestModel();
          final result =
          await refreshTokenUseCase.call(requestModel, responseModel);
          result.fold((l) {
            state = state.copyWith(loading: false);
          }, (right) async {
            final res = right as RefreshTokenResponseModel;
            sharedPreferenceHelper.setString(
                tokenKey, res.data?.accessToken ?? "");
            sharedPreferenceHelper.setString(
                refreshTokenKey, res.data?.refreshToken ?? "");

            OnboardingUserTypeRequestModel onboardingUserTypeRequestModel =
            OnboardingUserTypeRequestModel(userType: userType);
            OnboardingUserTypeResponseModel onboardingUserTypeResponseModel =
            OnboardingUserTypeResponseModel();
            final r = await onboardingUserTypeUseCase.call(
                onboardingUserTypeRequestModel,
                onboardingUserTypeResponseModel);
            r.fold((l) {
              debugPrint('update onboarding user type fold exception : $l');
            }, (r) async {
              final result = r as OnboardingUserTypeResponseModel;
            });
          });
        } else {
          OnboardingUserTypeRequestModel onboardingUserTypeRequestModel =
          OnboardingUserTypeRequestModel(userType: userType);
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
      } catch (error) {
        debugPrint('update onboarding user type exception : $error');
      }
    }
  }

  Future<void> submitUserDemographics() async {
    String maritalStatus = state.isSingle
        ? "alone"
        : state.isForTwo
        ? "married"
        : "with_family";
    final accommodationPreference = <String>[
      if (state.isWithDog) "dog",
      if (state.isBarrierearm) "low_barrier",
    ];
    String cityName = state.resident ?? '';
    int cityId = getCityIdByName(state.cityDetailsMap, cityName) ?? 0;

    if (cityId != 0) {
      sharedPreferenceHelper.setInt(selectedCityIdKey, cityId);
    }
    try {
      final response = tokenStatus.isAccessTokenExpired();
      if (response) {
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();
        RefreshTokenRequestModel requestModel = RefreshTokenRequestModel();
        final result =
        await refreshTokenUseCase.call(requestModel, responseModel);
        result.fold((l) {
          state = state.copyWith(loading: false);
        }, (right) async {
          final res = right as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");
          OnboardingUserDemographicsRequestModel
          onboardingUserDemographicsRequestModel =
          OnboardingUserDemographicsRequestModel(
              maritalStatus: maritalStatus,
              accommodationPreference: accommodationPreference,
              cityId: cityId);
          OnboardingUserDemographicsResponseModel
          onboardingUserDemographicsResponseModel =
          OnboardingUserDemographicsResponseModel();
          final r = await onboardingUserDemographicsUseCase.call(
              onboardingUserDemographicsRequestModel,
              onboardingUserDemographicsResponseModel);
          r.fold((l) {
            debugPrint(
                'update onboarding user demographics fold exception : $l');
          }, (r) async {
            final result = r as OnboardingUserDemographicsResponseModel;
          });
        });
      } else {
        OnboardingUserDemographicsRequestModel
        onboardingUserDemographicsRequestModel =
        OnboardingUserDemographicsRequestModel(
            maritalStatus: maritalStatus,
            accommodationPreference: accommodationPreference,
            cityId: cityId);
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
    } catch (error) {
      debugPrint('update onboarding user demographics exception : $error');
    }
  }

  Future<void> submitUserInterests(void Function() onSuccess) async {
    try {
      final response = tokenStatus.isAccessTokenExpired();
      if (response) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () {
              _submitUserInterests(onSuccess);
            });
      } else {
        _submitUserInterests(onSuccess);
      }
    } catch (error) {
      debugPrint('update onboarding user interests exception : $error');
    }
  }

  _submitUserInterests(void Function() onSuccess) async {
    try {
      Map<int, bool> interestSMap = state.interestsMap;
      List<int> interestIds = interestSMap.entries
          .where((interest) => interest.value)
          .map((interest) => interest.key)
          .toList();

      OnboardingUserInterestsRequestModel onboardingUserInterestsRequestModel =
      OnboardingUserInterestsRequestModel(interestIds: interestIds);
      OnboardingUserInterestsResponseModel
      onboardingUserInterestsResponseModel =
      OnboardingUserInterestsResponseModel();
      final r = await onboardingUserInterestsUseCase.call(
          onboardingUserInterestsRequestModel,
          onboardingUserInterestsResponseModel);
      r.fold((l) {
        debugPrint('update onboarding user interests fold exception : $l');
      }, (r) async {
        final result = r as OnboardingUserInterestsResponseModel;
        onSuccess();
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateOnboardingSuccess() async {
    sharedPreferenceHelper.setBool(onboardingKey, true);
    try {
      final response = tokenStatus.isAccessTokenExpired();
      if (response) {
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();
        RefreshTokenRequestModel requestModel = RefreshTokenRequestModel();
        final result =
        await refreshTokenUseCase.call(requestModel, responseModel);
        result.fold((l) {
          state = state.copyWith(loading: false);
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
            MatomoService.trackOnboardingCompletedAuth(
                userId: sharedPreferenceHelper.getInt(userIdKey).toString());
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
          MatomoService.trackOnboardingCompletedAuth(
              userId: sharedPreferenceHelper.getInt(userIdKey).toString());
        });
      }
    } catch (error) {
      debugPrint('onboarding complete exception : $error');
    }
  }

  bool isAllOptionFieldsCompleted() {
    bool martialStatusFilled =
    (!state.isSingle && !state.isForTwo && !state.isWithFamily);
    return martialStatusFilled;
  }

  void updateCompanionType(OnBoardingCompanionType onBoardingCompanionType) {
    switch (onBoardingCompanionType) {
      case OnBoardingCompanionType.withDog:
        state = state.copyWith(isWithDog: !state.isWithDog);
        break;
      case OnBoardingCompanionType.barrierearm:
        state = state.copyWith(isBarrierearm: !state.isBarrierearm);
        break;
    }
  }

  int? getCityIdByName(Map<int, String> cityMap, String cityName) {
    for (var entry in cityMap.entries) {
      if (entry.value == cityName) {
        return entry.key;
      }
    }
    return null;
  }

  // Future<void> nextPage() async {
  //   if (pageController.hasClients) {
  //     final nextPage = state.selectedPageIndex + 1;
  //     debugPrint("current page == ${state.selectedPageIndex}");
  //     if (nextPage < 5) {
  //       if (nextPage == 3) {
  //         String cityName = state.resident ?? '';
  //         int cityId = getCityIdByName(state.cityDetailsMap, cityName) ?? 0;
  //         if (cityId != 0) {
  //           await sharedPreferenceHelper.setInt(selectedCityIdKey, cityId);
  //         }
  //       }
  //
  //       pageController.animateToPage(
  //         nextPage,
  //         duration: const Duration(milliseconds: 400),
  //         curve: Curves.easeInOut,
  //       );
  //     }
  //   }
  // }

  // void onBackPress() {
  //   if (pageController.hasClients) {
  //     final previousPage = state.selectedPageIndex - 1;
  //     if (previousPage >= 0) {
  //       pageController.animateToPage(
  //         previousPage,
  //         duration: const Duration(milliseconds: 400),
  //         curve: Curves.easeInOut,
  //       );
  //     }
  //   }
  // }

  // void onSkipPress(VoidCallback onLastSkipPress) {
  //   if (!pageController.hasClients) return;
  //   final currentPage = state.selectedPageIndex;
  //   final nextPage = currentPage + 1;
  //   if (currentPage == 4) {
  //     onLastSkipPress();
  //   } else if (currentPage == 2) {
  //     pageController.animateToPage(
  //       nextPage,
  //       duration: const Duration(milliseconds: 400),
  //       curve: Curves.easeInOut,
  //     );
  //   } else if (nextPage < 5) {
  //     pageController.animateToPage(
  //       nextPage,
  //       duration: const Duration(milliseconds: 400),
  //       curve: Curves.easeInOut,
  //     );
  //   }
  // }

  // void updateSelectedPageIndex(int index) {
  //   state = state.copyWith(selectedPageIndex: index);
  // }

  Future<void> startLoadingTimer(Function() callBack) async {
    await updateOnboardingSuccess();
    Future.delayed(const Duration(seconds: 2), () {
      callBack();
    });
  }

  Future<void> getInterests() async {
    try {
      EmptyRequest requestModel = EmptyRequest();
      GetInterestsResponseModel responseModel = GetInterestsResponseModel();
      final result =
      await getInterestsUseCase.call(requestModel, responseModel);

      result.fold((l) {
        debugPrint('get interests fold exception : $l');
      }, (r) async {
        final response = r as GetInterestsResponseModel;
        List<Interest>? interests = response.data;
        Map<int, bool> interestMap;
        if (interests != null) {
          interestMap = {
            for (var interest in interests)
              if (interest.id != null) interest.id!: false
          };
          state = state.copyWith(interestsMap: interestMap);
        }
        state = state.copyWith(interests: interests);
      });
    } catch (error) {
      debugPrint('get interests exception : $error');
    }
  }

  Future<void> getOnboardingDetails() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = tokenStatus.isAccessTokenExpired();

      if (response) {
        RefreshTokenRequestModel requestModel = RefreshTokenRequestModel();
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();

        final refreshResponse =
        await refreshTokenUseCase.call(requestModel, responseModel);

        bool refreshSuccess = await refreshResponse.fold(
              (left) {
            debugPrint(
                'refresh token onboarding details fold exception : $left');
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
          state = state.copyWith(isLoading: false);
          return;
        }
      }

      EmptyRequest requestModel = EmptyRequest();
      OnboardingDetailsResponseModel responseModel =
      OnboardingDetailsResponseModel();
      final result =
      await onboardingDetailsUseCase.call(requestModel, responseModel);

      result.fold((l) {
        debugPrint('get onboarding details fold exception : $l');
      }, (r) async {
        final response = r as OnboardingDetailsResponseModel;
        if (response.data != null) {
          state =
              state.copyWith(onboardingData: response.data, isLoading: false);
          initializeOnboardingData();
        }
      });
    } catch (error) {
      debugPrint('get onboarding details exception : $error');
    }
  }

  void initializeOnboardingData() {
    // Update Name
    final userFistName = sharedPreferenceHelper.getString(userFirstNameKey);
    debugPrint('Initializing onboarding data for: $userFistName');
    state = state.copyWith(userFirstName: userFistName);

    final onboardingData = state.onboardingData;
    if (onboardingData == null) {
      debugPrint('No onboarding data to initialize');
      return;
    }

    debugPrint('Loading onboarding data');

    if (onboardingData.userType != null) {
      if (onboardingData.userType == "tourist") {
        state = state.copyWith(isTourist: true, isResident: false);
      } else if (onboardingData.userType == "citizen") {
        state = state.copyWith(isResident: true, isTourist: false);
      }
      debugPrint('Loaded user type: ${onboardingData.userType}');
    }

    if (onboardingData.maritalStatus != null &&
        onboardingData.maritalStatus!.isNotEmpty) {
      state = switch (onboardingData.maritalStatus) {
        "alone" =>
            state.copyWith(isSingle: true, isForTwo: false, isWithFamily: false),
        "married" =>
            state.copyWith(isForTwo: true, isSingle: false, isWithFamily: false),
        "with_family" =>
            state.copyWith(isWithFamily: true, isSingle: false, isForTwo: false),
        _ => state,
      };
      debugPrint('Loaded marital status: ${onboardingData.maritalStatus}');
    }

    final accommodationPrefs = onboardingData.accommodationPreference ?? [];
    if (accommodationPrefs.isNotEmpty) {
      state = state.copyWith(
        isWithDog: accommodationPrefs.contains("dog"),
        isBarrierearm: accommodationPrefs.contains("low_barrier"),
      );
      debugPrint('Loaded accommodation prefs: $accommodationPrefs');
    }

    // Updating city - if available
    if (onboardingData.cityId != null && onboardingData.cityId! > 0) {
      final cityDetailsMap = state.cityDetailsMap;
      String? city = cityDetailsMap[onboardingData.cityId];
      if (city != null) {
        state = state.copyWith(resident: city);
        debugPrint('   Loaded city: $city');
      }
    }

    // Handle interests - if available
    final interestIdList = onboardingData.interests;
    if (interestIdList != null && interestIdList.isNotEmpty) {
      for (final id in interestIdList) {
        updateInterestMap(id);
      }
      debugPrint('   Loaded ${interestIdList.length} interests');
    }
  }

  void updateInterestMap(int? id) {
    if (id != null) {
      Map<int, bool> interestsMap = state.interestsMap;
      bool isSelected = interestsMap[id] ?? false;
      bool updatedIsSelectedValue = false;
      if (!isSelected) {
        updatedIsSelectedValue = true;
      }
      interestsMap[id] = updatedIsSelectedValue;
      state = state.copyWith(interestsMap: interestsMap);
    }
  }

  bool isOnboardingDone() {
    bool onBoardingStatus =
        sharedPreferenceHelper.getBool(onboardingKey) ?? false;
    bool isOnBoarded = onBoardingStatus == true;
    return isOnBoarded;
  }

  bool isOfflineOnboardingDone() {
    bool onBoardingStatus =
        sharedPreferenceHelper.getString(onboardingCacheKey) != null;
    return onBoardingStatus;
  }

  Future<void> isLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();
    if (!status) {
      bool isTokenAvailable = sharedPreferenceHelper.getString(tokenKey)!=null;
      if(!isTokenAvailable){
        await guestUserLogin.getGuestUserToken();
      }
    }
  }

  void updateFirstName(String value) {
    sharedPreferenceHelper.setString(userFirstNameKey, value);
    state = state.copyWith(userFirstName: value);
  }

  Future<void> editUserName(
      {required void Function() onSuccess,
        required void Function(String msg) onError}) async {
    final response = tokenStatus.isAccessTokenExpired();
    if (response) {
      RefreshTokenRequestModel requestModel = RefreshTokenRequestModel();
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
        state = state.copyWith(loading: false);
        return;
      }
    }

    EditUserDetailRequestModel editUserDetailRequestModel =
    EditUserDetailRequestModel();
    editUserDetailRequestModel.firstname = state.userFirstName;

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

  Future<void> getUserDetails() async {
    try {
      state = state.copyWith(loading: true);
      final response = tokenStatus.isAccessTokenExpired();

      if (response) {
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();
        RefreshTokenRequestModel requestModel = RefreshTokenRequestModel();
        final result =
        await refreshTokenUseCase.call(requestModel, responseModel);

        result.fold((l) {
          state = state.copyWith(loading: false);
        }, (r) async {
          final res = r as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");

          UserDetailRequestModel requestModel = UserDetailRequestModel();
          UserDetailResponseModel responseModel = UserDetailResponseModel();
          final result =
          await userDetailUseCase.call(requestModel, responseModel);
          result.fold((l) {
            debugPrint('get user details fold exception : $l');
          }, (r) async {
            final response = r as UserDetailResponseModel;
            await sharedPreferenceHelper.setString(
                userFirstNameKey, response.data?.firstname ?? "");
            debugPrint('first time get this id 2 is ${state.userFirstName}');
            state = state.copyWith(loading: false);
          });
        });
      } else {
        UserDetailRequestModel requestModel = UserDetailRequestModel();
        UserDetailResponseModel responseModel = UserDetailResponseModel();
        final result =
        await userDetailUseCase.call(requestModel, responseModel);

        result.fold((l) {
          debugPrint('get user details fold exception : $l');
        }, (r) async {
          final response = r as UserDetailResponseModel;
          await sharedPreferenceHelper.setString(
              userFirstNameKey, response.data?.firstname ?? "");
          debugPrint('first time get this id 23 is ${state.userFirstName}');
          state = state.copyWith(loading: false);
        });
      }
    } catch (error) {
      debugPrint('get user details exception : $error');
      state = state.copyWith(loading: false);
    }
  }

  void updateIsNameScreenButtonVisibility(bool value) {
    state = state.copyWith(isNameScreenButtonVisible: value);
  }

  void updateIsPreferenceScreenButtonVisibility(bool value) {
    state = state.copyWith(isPreferencePageButtonVisible: value);
  }

  void updateIsOptionScreenButtonVisibility(bool value) {
    state = state.copyWith(isOptionPageButtonVisible: value);
  }

  void updateIsInterestScreenButtonVisibility(bool value) {
    state = state.copyWith(isInterestPageButtonVisible: value);
  }
}

enum OnBoardingType { resident, tourist }

enum OnBoardingFamilyType { single, withTwo, withMyFamily }

enum OnBoardingCompanionType { withDog, barrierearm }
