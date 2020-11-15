// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class GalleryThemeData {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  static Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData = themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);

  static ThemeData lightArabicThemeData = themeArabicData(lightColorScheme, _lightFocusColor);
  static ThemeData darkArabicThemeData = themeArabicData(darkColorScheme, _darkFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      //primaryColor: colorScheme.primary,
      colorScheme: colorScheme,
      textTheme: _textTheme,
      brightness: colorScheme.brightness,
      appBarTheme: AppBarTheme(
        textTheme: _textTheme.apply(bodyColor: colorScheme.onSurface),
        color: colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        brightness: colorScheme.brightness,
      ),
      accentIconTheme: IconThemeData(color: colorScheme.onSecondary),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      cardColor: colorScheme.surface,
      cardTheme: CardTheme(
          elevation: 1,
          margin: EdgeInsets.all(2.0)
      ),
      highlightColor: Colors.transparent,
      accentColor: colorScheme.secondary,
      focusColor: focusColor,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          _lightFillColor.withOpacity(0.80),
          _darkFillColor,
        ),
        contentTextStyle: _textTheme.subhead.apply(color: _darkFillColor),
      ),
    );
  }

  static ThemeData themeArabicData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      colorScheme: colorScheme,
      textTheme: _textArabicTheme,
      brightness: colorScheme.brightness,
      appBarTheme: AppBarTheme(
        textTheme: _textArabicTheme.apply(bodyColor: colorScheme.onSurface),
        color: colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        brightness: colorScheme.brightness,
      ),
      accentIconTheme: IconThemeData(color: colorScheme.onSecondary),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      cardColor: colorScheme.surface,
      highlightColor: Colors.transparent,
      accentColor: colorScheme.primary,
      focusColor: focusColor,
      cardTheme: CardTheme(
        elevation: 1,
          margin: EdgeInsets.all(2.0)
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          _lightFillColor.withOpacity(0.80),
          _darkFillColor,
        ),
        contentTextStyle: _textArabicTheme.subhead.apply(color: _darkFillColor),
      ),
    );
  }

  static ColorScheme lightColorScheme = ColorScheme(
    primary: const Color(0xFF344955),
    primaryVariant: const Color(0xFF232F34),
    secondary: const Color(0xFFF9AA33),
    secondaryVariant: const Color(0xFFC17B00),
    background: const Color(0xFF7793A1),
    surface: const Color(0xFFFFFFFF),
    onBackground: Colors.black,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _lightFillColor,
    brightness: Brightness.light,
  );

  static ColorScheme darkColorScheme = ColorScheme(
    primary: const Color(0xFF344955),
    primaryVariant: const Color(0xFF232F34),
    secondary: const Color(0xFFF9AA33),
    secondaryVariant: const Color(0xFFC17B00),
    background: const Color(0xFF4A6572),
    surface: const Color(0xFF4A6572),
    onBackground: Colors.black,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
    brightness: Brightness.dark,
  );

  static TextTheme _textTheme = TextTheme(
    display1: _GalleryTextStyles.display1,
    display2: _GalleryTextStyles.display2,
    display3: _GalleryTextStyles.display3,
    display4: _GalleryTextStyles.display4,
    caption: _GalleryTextStyles.studyTitle,
    headline: _GalleryTextStyles.categoryTitle,
    subhead: _GalleryTextStyles.listTitle,
    overline: _GalleryTextStyles.listDescription,
    body2: _GalleryTextStyles.sliderTitle,
    subtitle: _GalleryTextStyles.settingsFooter,
    body1: _GalleryTextStyles.options,
    title: _GalleryTextStyles.title,
    button: _GalleryTextStyles.button,
  );

  static TextTheme _textArabicTheme = TextTheme(
    display1: _GalleryArabicTextStyles.display1,
    display2: _GalleryArabicTextStyles.display2,
    display3: _GalleryArabicTextStyles.display3,
    display4: _GalleryArabicTextStyles.display4,
    caption: _GalleryArabicTextStyles.studyTitle,
    headline: _GalleryArabicTextStyles.categoryTitle,
    subhead: _GalleryArabicTextStyles.listTitle,
    overline: _GalleryArabicTextStyles.listDescription,
    body2: _GalleryArabicTextStyles.sliderTitle,
    subtitle: _GalleryArabicTextStyles.settingsFooter,
    body1: _GalleryArabicTextStyles.options,
    title: _GalleryArabicTextStyles.title,
    button: _GalleryArabicTextStyles.button,
  );
}

class _GalleryTextStyles {
  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  static const _montserrat = 'Montserrat';
  static const _oswald = 'Oswald';

  static const display1 = TextStyle(
    fontFamily: _montserrat,
    fontWeight: _bold,
    fontSize: 16.0,
  );

  static const display2 = TextStyle(
    fontFamily: _montserrat,
    fontWeight: _bold,
    fontSize: 14.0,
  );

  static const display3 = TextStyle(
    fontFamily: _montserrat,
    //fontWeight: _bold,
    fontSize: 12.0,
  );

  static const display4 = TextStyle(
    fontFamily: _montserrat,
    //fontWeight: _bold,
    fontSize: 10.0,
  );

  static const studyTitle = TextStyle(
    fontFamily: _oswald,
    fontWeight: _semiBold,
    fontSize: 16.0,
  );

  static const categoryTitle = TextStyle(
    fontFamily: _oswald,
    fontWeight: _medium,
    fontSize: 16.0,
  );

  static const listTitle = TextStyle(
    fontFamily: _montserrat,
    fontWeight: _medium,
    fontSize: 16.0,
  );

  static const listDescription = TextStyle(
    fontFamily: _montserrat,
    fontWeight: _medium,
    fontSize: 12.0,
  );

  static const sliderTitle = TextStyle(
    fontFamily: _montserrat,
    fontWeight: _regular,
    fontSize: 14.0,
  );

  static const settingsFooter = TextStyle(
    fontFamily: _montserrat,
    fontWeight: _medium,
    fontSize: 14.0,
  );

  static const options = TextStyle(
    fontFamily: _montserrat,
    fontWeight: _regular,
    fontSize: 16.0,
  );

  static const title = TextStyle(
    fontFamily: _montserrat,
    fontWeight: _bold,
    fontSize: 16.0,
  );

  static const button = TextStyle(
    fontFamily: _montserrat,
    fontWeight: _semiBold,
    fontSize: 14.0,
  );
}

class _GalleryArabicTextStyles {
  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  static const _cairo = 'Cairo';

  static const display1 = TextStyle(
    fontFamily: _cairo,
    fontWeight: _bold,
    fontSize: 16.0,
  );

  static const display2 = TextStyle(
    fontFamily: _cairo,
    fontWeight: _bold,
    fontSize: 14.0,
  );

  static const display3 = TextStyle(
    fontFamily: _cairo,
    //fontWeight: _bold,
    fontSize: 12.0,
  );

  static const display4 = TextStyle(
    fontFamily: _cairo,
    //fontWeight: _bold,
    fontSize: 10.0,
  );

  static const studyTitle = TextStyle(
    fontFamily: _cairo,
    fontWeight: _semiBold,
    fontSize: 16.0,
  );

  static const categoryTitle = TextStyle(
    fontFamily: _cairo,
    fontWeight: _medium,
    fontSize: 16.0,
  );

  static const listTitle = TextStyle(
    fontFamily: _cairo,
    fontWeight: _medium,
    fontSize: 16.0,
  );

  static const listDescription = TextStyle(
    fontFamily: _cairo,
    fontWeight: _medium,
    fontSize: 12.0,
  );

  static const sliderTitle = TextStyle(
    fontFamily: _cairo,
    fontWeight: _regular,
    fontSize: 14.0,
  );

  static const settingsFooter = TextStyle(
    fontFamily: _cairo,
    fontWeight: _medium,
    fontSize: 14.0,
  );

  static const options = TextStyle(
    fontFamily: _cairo,
    fontWeight: _regular,
    fontSize: 16.0,
  );

  static const title = TextStyle(
    fontFamily: _cairo,
    fontWeight: _bold,
    fontSize: 16.0,
  );

  static const button = TextStyle(
    fontFamily: _cairo,
    fontWeight: _semiBold,
    fontSize: 14.0,
  );
}