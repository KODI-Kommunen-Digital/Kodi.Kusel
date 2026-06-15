import 'package:flutter/material.dart';
import 'package:kusel/theme_manager/themes.dart';

class ThemeManagerState {
  Themes? themes;
  ThemeData? currentSelectedTheme;

  ThemeManagerState({this.themes, this.currentSelectedTheme});

  factory ThemeManagerState.empty() {
    return ThemeManagerState(
        themes: Themes.light, currentSelectedTheme: lightTheme);
  }

  ThemeManagerState copyWith(
      {Themes? themes, ThemeData? currentSelectedTheme}) {
    return ThemeManagerState(
        themes: themes ?? this.themes,
        currentSelectedTheme:
            currentSelectedTheme ?? this.currentSelectedTheme);
  }
}
