
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/theme_manager/theme_manager_state.dart';
import 'package:kusel/theme_manager/themes.dart';

final themeManagerProvider =
    StateNotifierProvider<ThemeManagerController, ThemeManagerState>(
        (ref) => ThemeManagerController());

class ThemeManagerController extends StateNotifier<ThemeManagerState> {
  ThemeManagerController() : super(ThemeManagerState.empty());

   updateThemeData(Themes theme) {
    late ThemeData themeData;

    switch (theme) {
      case Themes.dark:
        themeData = darkTheme;
        break;
      default:
        themeData = lightTheme;
    }
    state = state.copyWith(themes: theme,currentSelectedTheme: themeData);
    return themeData;
  }
}
