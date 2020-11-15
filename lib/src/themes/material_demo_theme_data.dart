// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MaterialDemoThemeData {
  static final themeData = ThemeData(
    colorScheme: colorScheme,
    appBarTheme: AppBarTheme(
      color: colorScheme.primary,
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: colorScheme.primary,
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      colorScheme: colorScheme,
    ),
    canvasColor: colorScheme.background,
    cursorColor: colorScheme.primary,
    toggleableActiveColor: colorScheme.primary,
    highlightColor: Colors.transparent,
    indicatorColor: colorScheme.onPrimary,
    primaryColor: colorScheme.primary,
    accentColor: colorScheme.primary,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: colorScheme.background,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
    typography: Typography(
      platform: defaultTargetPlatform,
      englishLike: Typography.englishLike2018,
      dense: Typography.dense2018,
      tall: Typography.tall2018,
    ),
  );

  static const colorScheme = ColorScheme(
    primary: Color(0xFF6200EE),
    primaryVariant: Color(0xFF6200EE),
    secondary: Color(0xFFFF5722),
    secondaryVariant: Color(0xFFFF5722),
    background: Colors.white,
    surface: Color(0xFFF2F2F2),
    onBackground: Colors.black,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    brightness: Brightness.light,
  );
}
