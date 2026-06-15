import 'dart:ui';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/locale/locale_constant.dart';

final localeManagerProvider =
    StateNotifierProvider<LocaleManagerController, LocaleManagerState>(
  (ref) => LocaleManagerController(
      sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)),
);

class LocaleManagerController extends StateNotifier<LocaleManagerState> {
  SharedPreferenceHelper sharedPreferenceHelper;

  LocaleManagerController({required this.sharedPreferenceHelper})
      : super(LocaleManagerState.empty());

  void fetchCurrentSelectedLocale(Locale currentLocale) {
    final savedLanguageCode = sharedPreferenceHelper.getString(languageKey);
    Locale newLocale;
    if (savedLanguageCode != null) {
      newLocale = AppLocalizations.supportedLocales.firstWhere(
        (locale) => locale.languageCode == savedLanguageCode,
        orElse: () => currentLocale,
      );
    } else {
      newLocale = AppLocalizations.supportedLocales.firstWhere(
        (locale) => locale.languageCode == currentLocale.languageCode,
        orElse: () => const Locale('en', 'GB'),
      );
      sharedPreferenceHelper.setString(languageKey, newLocale.languageCode);
    }
    state = state.copyWith(currentLocale: newLocale);
  }

  void updateSelectedLocale(Locale currentLocale) async {
    await sharedPreferenceHelper.setString(
        languageKey, currentLocale.languageCode);
    state = state.copyWith(currentLocale: currentLocale);
  }

  Locale getSelectedLocale() {
    final locale = state.currentLocale;
    return locale;
  }

  Future<void> initialLocaleSetUp() async {
    final value = sharedPreferenceHelper.getString(languageKey);
    if (value != null) {
      if (value == LocaleConstant.english.languageCode) {
        updateSelectedLocale(Locale(LocaleConstant.english.languageCode,
            LocaleConstant.english.region));
      } else if (value == LocaleConstant.german.languageCode) {
        updateSelectedLocale(Locale(
            LocaleConstant.german.languageCode, LocaleConstant.german.region));
      }
    }
  }
}

class LocaleManagerState {
  final Locale currentLocale;

  LocaleManagerState(this.currentLocale);

  factory LocaleManagerState.empty() {
    return LocaleManagerState(Locale(
        LocaleConstant.german.languageCode, LocaleConstant.german.region));
  }

  LocaleManagerState copyWith({Locale? currentLocale}) {
    return LocaleManagerState(currentLocale ?? this.currentLocale);
  }
}
