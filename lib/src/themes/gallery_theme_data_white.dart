// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './../layout/letter_spacing.dart';

const defaultLetterSpacing = 0.03;
const mediumLetterSpacing = 0.04;
const largeLetterSpacing = 1.0;

class GalleryThemeData {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  static Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData =
      themeDataLight(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);

  static ThemeData lightArabicThemeData =
      themeArabicData(lightColorScheme, _lightFocusColor);
  static ThemeData darkArabicThemeData =
      themeArabicData(darkColorScheme, _darkFocusColor);

  static ThemeData themeDataLight(ColorScheme colorScheme, Color focusColor) {
    final ThemeData base = colorScheme.brightness == Brightness.dark
        ? ThemeData.dark()
        : ThemeData.light();
    return ThemeData(
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      textTheme: _buildLightTextTheme(base.textTheme),
      brightness: colorScheme.brightness,
      primaryTextTheme: _textTheme.apply(bodyColor: colorScheme.onPrimary),
      appBarTheme: AppBarTheme(
        textTheme: _textTheme.apply(bodyColor: colorScheme.onPrimary),
        color: colorScheme.background,
        elevation: 0.0,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        brightness: colorScheme.brightness,
      ),
      primaryIconTheme: IconThemeData(color: colorScheme.onPrimary),
      accentIconTheme: IconThemeData(color: colorScheme.onSecondary),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.surface,
      scaffoldBackgroundColor: colorScheme.background,
      accentColor: colorScheme.secondary,
      focusColor: focusColor,
      hintColor: Colors.grey[600],
      cardColor: colorScheme.background,
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue,
        //shape: StadiumBorder(),
        textTheme: ButtonTextTheme.primary,
        height: 45.0,
        colorScheme: new ColorScheme(
            primary: Colors.blue,//Color(0xff6200ee),
            primaryVariant: Colors.blueAccent,//const Color(0xff3700b3),
            secondary: Color(0xff03dac6),
            secondaryVariant: const Color(0xff018786),
            surface: Colors.white,
            background: Colors.white,
            error: Color(0xffb00020),
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.black,
            onBackground: Colors.black,
            onError: Colors.white,
            brightness: Brightness.light),
      ),
      tabBarTheme: TabBarTheme(
          unselectedLabelColor: colorScheme.onPrimary,
          labelColor: colorScheme.onPrimary),
      cardTheme: CardTheme(elevation: 0.5, margin: EdgeInsets.all(2.0)),
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

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    final ThemeData base = colorScheme.brightness == Brightness.dark
        ? ThemeData.dark()
        : ThemeData.light();
    return ThemeData(
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      textTheme: _buildLightTextTheme(base.textTheme),
      brightness: colorScheme.brightness,
      primaryTextTheme: _textTheme.apply(bodyColor: colorScheme.onPrimary),
      appBarTheme: AppBarTheme(
        textTheme: _textTheme.apply(bodyColor: colorScheme.onPrimary),
        color: colorScheme.background,
        elevation: 0.0,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        brightness: colorScheme.brightness,
      ),
      primaryIconTheme: IconThemeData(color: colorScheme.onPrimary),
      accentIconTheme: IconThemeData(color: colorScheme.onSecondary),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.surface,
      scaffoldBackgroundColor: colorScheme.background,
      accentColor: colorScheme.secondary,
      focusColor: focusColor,
      hintColor: Colors.grey[600],
      cardColor: colorScheme.background,
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue,
        //shape: StadiumBorder(),
        textTheme: ButtonTextTheme.primary,
        height: 45.0,
        colorScheme: new ColorScheme(
            primary: Colors.blue,//Color(0xff6200ee),
            primaryVariant: Colors.blueAccent,//const Color(0xff3700b3),
            secondary: Color(0xff03dac6),
            secondaryVariant: const Color(0xff018786),
            surface: Colors.white,
            background: Colors.white,
            error: Color(0xffb00020),
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.black,
            onBackground: Colors.black,
            onError: Colors.white,
            brightness: Brightness.light),
      ),
      tabBarTheme: TabBarTheme(
          unselectedLabelColor: colorScheme.onPrimary,
          labelColor: colorScheme.onPrimary),
      cardTheme: CardTheme(elevation: 0.5, margin: EdgeInsets.all(2.0)),
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
        textTheme: _textArabicTheme.apply(bodyColor: colorScheme.onPrimary),
        color: colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        brightness: colorScheme.brightness,
      ),
      primaryIconTheme: IconThemeData(color: colorScheme.onPrimary),
      accentIconTheme: IconThemeData(color: colorScheme.onSecondary),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      //highlightColor: Colors.transparent,
      accentColor: colorScheme.secondary,
      focusColor: focusColor,
      cardColor: colorScheme.surface,
      hintColor: Colors.grey[200],
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue,
        //shape: StadiumBorder(),
        textTheme: ButtonTextTheme.primary,
        height: 45.0,
        colorScheme: new ColorScheme(
            primary: Colors.blue,//Color(0xff6200ee),
            primaryVariant: Colors.blueAccent,//const Color(0xff3700b3),
            secondary: Color(0xff03dac6),
            secondaryVariant: const Color(0xff018786),
            surface: Colors.white,
            background: Colors.white,
            error: Color(0xffb00020),
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.black,
            onBackground: Colors.black,
            onError: Colors.white,
            brightness: Brightness.light),
      ),
      tabBarTheme: TabBarTheme(unselectedLabelColor: Colors.black),
      cardTheme: CardTheme(elevation: 0.5, margin: EdgeInsets.all(2.0)),
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
    primary: Colors.blue,
    primaryVariant: Colors.blue[700],
    secondary: Colors.blue[700],
    secondaryVariant: const Color(0xFF000000),
    background: const Color(0xFFFFFFFF),
    surface: const Color(0xFFFFFFFF),
    onBackground: Colors.black,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: _darkFillColor,
    onSurface: const Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xff03dac6),
    primaryVariant: const Color(0xff03dac6),
    secondary: const Color(0xff03dac6),
    secondaryVariant: const Color(0xff03dac6),
    background: const Color(0xff000000),
    surface: const Color(0xff121212),
    onBackground: Colors.white.withOpacity(0.05),
    error: _darkFillColor,
    onError: _darkFillColor,
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

TextTheme _buildLightTextTheme(TextTheme base) {
  return GoogleFonts.rubikTextTheme(base.copyWith(
    headline5: base.headline5.copyWith(
      fontWeight: FontWeight.w500,
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    headline6: base.headline6.copyWith(
      fontSize: 18,
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    bodyText1: base.bodyText1.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    bodyText2: base.bodyText2.copyWith(
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    subtitle1: base.subtitle1.copyWith(
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    headline4: base.headline4.copyWith(
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    button: base.button.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
  ));
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

  static const studyTitle = TextStyle(
    //fontFamily: _oswald,
    fontWeight: _semiBold,
    fontSize: 16.0,
  );

  static const categoryTitle = TextStyle(
    //fontFamily: _oswald,
    fontWeight: _medium,
    fontSize: 16.0,
  );

  static const listTitle = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _medium,
    fontSize: 16.0,
  );

  static const listDescription = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _medium,
    fontSize: 12.0,
  );

  static const sliderTitle = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _regular,
    fontSize: 14.0,
  );

  static const settingsFooter = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _medium,
    fontSize: 14.0,
  );

  static const options = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _regular,
    fontSize: 16.0,
  );

  static const title = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _bold,
    fontSize: 16.0,
  );

  static const button = TextStyle(
    //fontFamily: _montserrat,
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
