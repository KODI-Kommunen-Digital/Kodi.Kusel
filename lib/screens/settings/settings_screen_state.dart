import 'package:kusel/locale/locale_constant.dart';

class SettingsScreenState {
  List<String> languageList;
  String selectedLanguage;
  bool isLoggedIn;
  bool isLoading;

  SettingsScreenState(this.languageList, this.selectedLanguage, this.isLoggedIn,
      this.isLoading);

  factory SettingsScreenState.empty() {
    return SettingsScreenState(
        [LocaleConstant.english.displayName, LocaleConstant.german.displayName],
        LocaleConstant.german.displayName,
        false,
        false);
  }

  SettingsScreenState copyWith(
      {List<String>? languageList,
      String? selectedLanguage,
      bool? isLoggedIn,
      bool? isLoading}) {
    return SettingsScreenState(
        languageList ?? this.languageList,
        selectedLanguage ?? this.selectedLanguage,
        isLoggedIn ?? this.isLoggedIn,
        isLoading ?? this.isLoading);
  }
}
