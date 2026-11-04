import 'package:flutter/material.dart';
import 'package:workly/core/theme/design_tokens.dart';

abstract final class AppTheme {
  static const fontFamily = 'Plus Jakarta Sans';
  static TextStyle _text(double size, FontWeight weight) => TextStyle(
    fontFamily: fontFamily,
    fontSize: size,
    fontWeight: weight,
    height: 1.4,
    color: EmeraldColors.textPrimary,
  );
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: EmeraldColors.background,
    colorScheme: const ColorScheme.light(
      primary: EmeraldColors.primary,
      onPrimary: EmeraldColors.surface,
      secondary: EmeraldColors.primaryDark,
      onSecondary: EmeraldColors.surface,
      surface: EmeraldColors.surface,
      onSurface: EmeraldColors.textPrimary,
    ),
    textTheme: TextTheme(
      displaySmall: _text(32, FontWeight.w700),
      headlineLarge: _text(25, FontWeight.w700),
      headlineMedium: _text(21, FontWeight.w700),
      headlineSmall: _text(18, FontWeight.w700),
      bodyMedium: _text(14, FontWeight.w400),
      labelLarge: _text(13, FontWeight.w500),
      bodySmall: _text(11, FontWeight.w400),
    ),
  );
}
