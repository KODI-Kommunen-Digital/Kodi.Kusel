import 'package:domain/model/response_model/user_detail/user_detail_response_model.dart';

import '../../locale/locale_constant.dart';

class KuselSettingState {
  List<String> languageList;
  String selectedLanguage;
  bool isUserLoggedIn;
  bool isLoading;
  int totalPoints;
  int totalStamp;
  String appVersion;
  bool isLegalPolicyLoading;
  String legalPolicyData;
  bool isProfilePageLoading;
  List<UserDetailInterest> listOfUserInterest;
  String selectedOrt;

  String name;
  String email;
  String mobileNumber;
  String address;

  bool isLocationPermissionGranted;
  String initialName;
  String initialEmail;
  String initialMobileNumber;
  String initialAddress;
  String initialLanguage;
  bool initialLocationPermission;
  bool hasChanges;

  KuselSettingState(
      this.languageList,
      this.selectedLanguage,
      this.isUserLoggedIn,
      this.isLoading,
      this.totalPoints,
      this.totalStamp,
      this.appVersion,
      this.isLegalPolicyLoading,
      this.legalPolicyData,
      this.isProfilePageLoading,
      this.listOfUserInterest,
      this.selectedOrt,
      this.name,
      this.email,
      this.mobileNumber,
      this.address,
      this.isLocationPermissionGranted,
      this.initialName,
      this.initialEmail,
      this.initialMobileNumber,
      this.initialAddress,
      this.initialLanguage,
      this.initialLocationPermission,
      this.hasChanges);

  factory KuselSettingState.empty() {
    return KuselSettingState(
        [LocaleConstant.english.displayName, LocaleConstant.german.displayName],
        LocaleConstant.german.displayName,
        false,
        false,
        0,
        0,
        '',
        false,
        '',
        false,
        [],
        '',
        '',
        '',
        '',
        '',
        false,
        '',
        '',
        '',
        '',
        LocaleConstant.german.displayName,
        false,
        false);
  }

  KuselSettingState copyWith(
      {List<String>? languageList,
      String? selectedLanguage,
      bool? isUserLoggedIn,
      bool? isLoading,
      int? totalPoints,
      int? totalStamp,
      String? appVersion,
      bool? isLegalPolicyLoading,
      String? legalPolicyData,
      bool? isProfilePageLoading,
      List<UserDetailInterest>? listOfUserInterest,
      String? selectedOrt,
      String? name,
      String? email,
      String? mobileNumber,
      String? address,
      bool? isLocationPermissionGranted,
      String? initialName,
      String? initialEmail,
      String? initialMobileNumber,
      String? initialAddress,
      String? initialLanguage,
      bool? initialLocationPermission,
      bool? hasChanges}) {
    return KuselSettingState(
        languageList ?? this.languageList,
        selectedLanguage ?? this.selectedLanguage,
        isUserLoggedIn ?? this.isUserLoggedIn,
        isLoading ?? this.isLoading,
        totalPoints ?? this.totalPoints,
        totalStamp ?? this.totalStamp,
        appVersion ?? this.appVersion,
        isLegalPolicyLoading ?? this.isLegalPolicyLoading,
        legalPolicyData ?? this.legalPolicyData,
        isProfilePageLoading ?? this.isProfilePageLoading,
        listOfUserInterest ?? this.listOfUserInterest,
        selectedOrt ?? this.selectedOrt,
        name ?? this.name,
        email ?? this.email,
        mobileNumber ?? this.mobileNumber,
        address ?? this.address,
        isLocationPermissionGranted ?? this.isLocationPermissionGranted,
        initialName ?? this.initialName,
        initialEmail ?? this.initialEmail,
        initialMobileNumber ?? this.initialMobileNumber,
        initialAddress ?? this.initialAddress,
        initialLanguage ?? this.initialLanguage,
        initialLocationPermission ?? this.initialLocationPermission,
        hasChanges ?? this.hasChanges);
  }
}
