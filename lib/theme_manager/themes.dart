import 'package:flutter/material.dart';

import 'colors.dart';

enum Themes { light, dark }

final lightTheme = ThemeData(
  useMaterial3: false,
  primaryColor: lightThemePrimaryColor,
  scaffoldBackgroundColor: lightThemeScaffoldBackgroundColor,
  indicatorColor: lightThemeIndicatorColor,
  highlightColor: lightThemeShimmerColor,
  bottomAppBarTheme: BottomAppBarThemeData(
    color: lightThemeSecondaryColor
  ),
  colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: lightThemePrimaryColor,
      onPrimary: lightThemeOnPrimaryColor,
      secondary: lightThemeSecondaryColor,
      onSecondary: lightThemeScaffoldBackgroundColor,
      error: lightThemeErrorToastColor,
      onError: lightThemeErrorToastColor,
      surface: lightThemeSurfaceColor,
      onSurface: lightThemeSuccessToastColor,
      onTertiaryFixed: lightThemeMapMarkerColor),
  textTheme: TextTheme(
      bodySmall: TextStyle(color: lightThemeBodySmallColor),
      bodyMedium: TextStyle(color : lightThemeBodyMediumColor),
      bodyLarge: TextStyle(color: lightThemeBodyLargeColor),
      displaySmall: TextStyle(color: lightThemeDisplaySmallTextColor),
      displayMedium: TextStyle(color: lightThemeDisplayMediumTextColor),
      displayLarge: TextStyle(color: lightThemeDisplayLargeTextColor),
      labelSmall: TextStyle(color: lightThemeLabelSmallColor),
      labelMedium: TextStyle(color: lightThemeLabelMediumColor),
      labelLarge: TextStyle(color: lightThemeLabelLargeColor),
      titleSmall: TextStyle(color: lightThemeDisableTextColor)
  ),
  cardTheme: CardThemeData(
    color: lightThemeCardDarkColor,
  ),
  canvasColor: lightThemeCanvasColor,
  hintColor: lightThemeHintColor,
  dividerColor: lightThemeDividerColor,
  shadowColor: lightThemeShadowColor,
  cardColor: lightThemeCardColor,
);

final darkTheme =
    ThemeData(useMaterial3: false, scaffoldBackgroundColor: Colors.black);
