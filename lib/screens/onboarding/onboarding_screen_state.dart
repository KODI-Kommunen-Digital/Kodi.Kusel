import 'package:domain/model/response_model/get_interests/get_interests_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_details_response_model.dart';

class OnboardingScreenState {
  int selectedPageIndex;
  String onBoardingButtonText;
  List<String> residenceList;
  String? resident;
  String? userFirstName;
  bool isLoading;
  bool isTourist;
  bool isResident;
  double loadingPercentage;
  bool isSingle;
  bool isForTwo;
  bool isWithFamily;
  bool isWithDog;
  bool isBarrierearm;
  bool isErrorMsgVisible;
  Map<int, String> cityDetailsMap;
  List<Interest> interests;
  bool loading;
  Map<int, bool> interestsMap;
  String? userCurrentCity;
  OnboardingData? onboardingData;
  bool isLoggedIn;
  bool isOptionPageButtonVisible;
  bool isNameScreenButtonVisible;
  bool isPreferencePageButtonVisible;
  bool isInterestPageButtonVisible;

  OnboardingScreenState(
      this.selectedPageIndex,
      this.onBoardingButtonText,
      this.residenceList,
      this.resident,
      this.userFirstName,
      this.isLoading,
      this.isTourist,
      this.isResident,
      this.loadingPercentage,
      this.isSingle,
      this.isForTwo,
      this.isWithFamily,
      this.isWithDog,
      this.isBarrierearm,
      this.isErrorMsgVisible,
      this.cityDetailsMap,
      this.interests,
      this.loading,
      this.interestsMap,
      this.userCurrentCity,
      this.onboardingData,
      this.isLoggedIn,
      this.isOptionPageButtonVisible,
      this.isNameScreenButtonVisible,
      this.isPreferencePageButtonVisible,
      this.isInterestPageButtonVisible);

  factory OnboardingScreenState.empty() {
    return OnboardingScreenState(
        0,
        '',
        [],
        null,
        null,
        false,
        false,
        false,
        0,
        false,
        false,
        false,
        false,
        false,
        false,
        {},
        [],
        false,
        {},
        null,
        null,
        false,
        false,
        false,
        false,
        false);
  }

  OnboardingScreenState copyWith(
      {int? selectedPageIndex,
      String? onBoardingButtonText,
      List<String>? residenceList,
      String? resident,
      String? userFirstName,
      bool? isLoading,
      bool? isTourist,
      bool? isResident,
      double? loadingPercentage,
      bool? isSingle,
      bool? isForTwo,
      bool? isWithFamily,
      bool? isWithDog,
      bool? isBarrierearm,
      bool? isErrorMsgVisible,
      Map<int, String>? cityDetailsMap,
      List<Interest>? interests,
      bool? loading,
      Map<int, bool>? interestsMap,
      String? userCurrentCity,
      OnboardingData? onboardingData,
      bool? isLoggedIn,
      bool? isOptionPageButtonVisible,
      bool? isNameScreenButtonVisible,
      bool? isPreferencePageButtonVisible,
      bool? isInterestPageButtonVisible}) {
    return OnboardingScreenState(
        selectedPageIndex ?? this.selectedPageIndex,
        onBoardingButtonText ?? this.onBoardingButtonText,
        residenceList ?? this.residenceList,
        resident ?? this.resident,
        userFirstName ?? this.userFirstName,
        isLoading ?? this.isLoading,
        isTourist ?? this.isTourist,
        isResident ?? this.isResident,
        loadingPercentage ?? this.loadingPercentage,
        isSingle ?? this.isSingle,
        isForTwo ?? this.isForTwo,
        isWithFamily ?? this.isWithFamily,
        isWithDog ?? this.isWithDog,
        isBarrierearm ?? this.isBarrierearm,
        isErrorMsgVisible ?? this.isErrorMsgVisible,
        cityDetailsMap ?? this.cityDetailsMap,
        interests ?? this.interests,
        loading ?? this.loading,
        interestsMap ?? this.interestsMap,
        userCurrentCity ?? this.userCurrentCity,
        onboardingData ?? this.onboardingData,
        isLoggedIn ?? this.isLoggedIn,
        isOptionPageButtonVisible ?? this.isOptionPageButtonVisible,
        isNameScreenButtonVisible ?? this.isNameScreenButtonVisible,
        isPreferencePageButtonVisible ?? this.isPreferencePageButtonVisible,
        isInterestPageButtonVisible ?? this.isInterestPageButtonVisible);
  }
}
