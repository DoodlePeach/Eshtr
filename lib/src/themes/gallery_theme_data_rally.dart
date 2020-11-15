// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class GalleryThemeData {

  static Map<String, Color> darkColors = {
    'inputLabel': Color(0xFFD8D8D8),
    'primaryBackground': Color(0xFF33333D),
    'inputBackground': Color(0xFF26282F),
    'cardBackground': Color(0x03FEFEFE),
    'buttonColor': Color(0xFF09AF79),
    'focusColor': Colors.white.withOpacity(0.5),
    'fillColor': Colors.white,
  };

  static Map<String, Color> lightColors = {
    'inputLabel': Color(0xFFD8D8D8),
    'primaryBackground': Color(0xFFFFFFFF),
    'inputBackground': Color(0xFFffffff),
    'cardBackground': Color(0xFFFFFFFF),
    'buttonColor': Color(0xFF09AF79),
    'focusColor': Colors.black.withOpacity(0.5),
    'fillColor': Colors.black,
  };

  static ThemeData lightThemeData = themeData(lightColorScheme, lightColors);
  static ThemeData darkThemeData = themeData(darkColorScheme, darkColors);

  static ThemeData lightArabicThemeData = themeArabicData(lightColorScheme, lightColors);
  static ThemeData darkArabicThemeData = themeArabicData(darkColorScheme, darkColors);

  static ThemeData themeData(ColorScheme colorScheme, Map<String, Color> colors) {
    return ThemeData(
      colorScheme: colorScheme,
      brightness: colorScheme.brightness,
      appBarTheme: AppBarTheme(
        textTheme: _textTheme.apply(bodyColor: colorScheme.onPrimary),
        color: colorScheme.background,
        elevation: 0.5,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        brightness: colorScheme.brightness,
      ),
      //floatingActionButtonTheme: IconThemeData(color: colorScheme.onSecondary),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.surface,
      highlightColor: Colors.transparent,
      accentColor: colorScheme.secondary,
      buttonColor: colors['buttonColor'],
      hintColor: Colors.grey[600],
      cardColor: colors['cardBackground'],
      cardTheme: CardTheme(
          margin: EdgeInsets.all(2.0)
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          colors['fillColor'].withOpacity(0.80),
          colors['fillColor'],
        ),
        contentTextStyle: _textTheme.subhead.apply(color: colors['fillColor']),
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      primaryColor: colors['primaryBackground'],
      focusColor: colors['focusColor'],
      textTheme: _textTheme,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: colors['inputLabel'],
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: colors['inputBackground'],
        focusedBorder: InputBorder.none,
        border: InputBorder.none,
      ),
    );
  }

  static ThemeData themeArabicData(ColorScheme colorScheme, Map<String, Color> colors) {
    final base = ThemeData.dark();
    return ThemeData(
      //colorScheme: colorScheme,
      brightness: colorScheme.brightness,
      appBarTheme: AppBarTheme(
        textTheme: _textTheme,
        color: colorScheme.background,
        elevation: 0.5,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        brightness: colorScheme.brightness,
      ),
      accentIconTheme: IconThemeData(color: colorScheme.onSecondary),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.surface,
      highlightColor: Colors.transparent,
      accentColor: colors['buttonColor'],
      buttonColor: colors['buttonColor'],
      buttonTheme: ButtonThemeData(

      ),
      hintColor: Colors.grey[600],
      cardColor: colors['cardBackground'],
      cardTheme: CardTheme(
          elevation: 0.5,
          margin: EdgeInsets.all(2.0)
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          colors['fillColor'].withOpacity(0.80),
          colors['fillColor'],
        ),
        contentTextStyle: _textTheme.subhead.apply(color: colors['fillColor']),
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      primaryColor: colors['primaryBackground'],
      focusColor: colors['focusColor'],
      textTheme: _textTheme,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: colors['inputLabel'],
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: colors['inputBackground'],
        focusedBorder: InputBorder.none,
        border: InputBorder.none,
      ),
    );
  }

  static ColorScheme lightColorScheme = ColorScheme(
    primary: const Color(0xFFB93C5D),
    primaryVariant: const Color(0xFF117378),
    secondary: const Color(0xFF000000),
    secondaryVariant: const Color(0xFFFAFBFB),
    background: const Color(0xFFFFFFFF),
    surface: const Color(0xFFf7f7f7),
    onBackground: Colors.black,
    error: lightColors['fillColor'],
    onError: lightColors['fillColor'],
    onPrimary: lightColors['fillColor'],
    onSecondary: Colors.white,
    onSurface: lightColors['fillColor'],
    brightness: Brightness.light,
  );


  static ColorScheme darkColorScheme = ColorScheme(
    primary: const Color(0xffbb86fc),
    primaryVariant: const Color(0xff3700B3),
    secondary: const Color(0xff03dac6),
    secondaryVariant: const Color(0xff03dac6),
    background: Color(0xFF33333D),
    surface: Color(0xFF33333D),
    onBackground: Colors.white.withOpacity(0.05),
    error: darkColors['fillColor'],
    onError: darkColors['fillColor'],
    onPrimary: darkColors['fillColor'],
    onSecondary: darkColors['fillColor'],
    onSurface: darkColors['fillColor'],
    brightness: Brightness.dark,
  );

  static TextTheme _textTheme = TextTheme(
    display1: _GalleryTextStyles.display1,
    display2: _GalleryTextStyles.display2,
    display3: _GalleryTextStyles.display3,
    display4: _GalleryTextStyles.display4,
    caption: _GalleryTextStyles.caption,
    headline: _GalleryTextStyles.headline,
    subhead: _GalleryTextStyles.subhead,
    overline: _GalleryTextStyles.overline,
    body2: _GalleryTextStyles.body2,
    subtitle: _GalleryTextStyles.subtitle,
    body1: _GalleryTextStyles.body1,
    title: _GalleryTextStyles.title,
    button: _GalleryTextStyles.button,
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
    //fontFamily: _montserrat,
    fontWeight: _bold,
    fontSize: 16.0,
  );

  static const display2 = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _bold,
    fontSize: 14.0,
  );

  static const display3 = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _bold,
    fontSize: 12.0,
  );

  static const display4 = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _bold,
    fontSize: 10.0,
  );

  static const caption = TextStyle(
    //fontFamily: _oswald,
    fontWeight: _semiBold,
    fontSize: 16.0,
  );

  static const headline = TextStyle(
    //fontFamily: _oswald,
    fontWeight: _medium,
    fontSize: 16.0,
  );

  static const subhead = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _medium,
    fontSize: 16.0,
  );

  static const overline = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _medium,
    fontSize: 12.0,
  );

  static const subtitle = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _medium,
    fontSize: 14.0,
  );

  static const body1 = TextStyle(
    fontFamily: 'Roboto Condensed',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const body2 = TextStyle(
    fontFamily: 'Eczar',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    //letterSpacing: 1.4,
  );

  static const title = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _bold,
    fontSize: 16.0,
  );

  static const button = TextStyle(
    fontFamily: 'Roboto Condensed',
    fontWeight: FontWeight.w700,
    letterSpacing: 2.8,
  );
}