import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_palette.dart';

abstract final class AppTheme {
  static const _scheme = FlexSchemeColor(
    primary: AppPalette.primary,
    primaryContainer: AppPalette.iceBlue,
    secondary: AppPalette.accent,
    secondaryContainer: AppPalette.iceBlueLight,
    tertiary: AppPalette.sky,
    tertiaryContainer: Color(0xFFE0F2FE),
    error: AppPalette.expense,
    errorContainer: AppPalette.expenseLight,
    appBarColor: AppPalette.pureWhite,
  );

  static ThemeData light() {
    final inter = GoogleFonts.interTextTheme();
    final base = inter.copyWith(
      displaySmall: _headline(32),
      headlineMedium: _headline(26),
      headlineSmall: _headline(22),
      titleLarge: _headline(18),
      bodyLarge: inter.bodyLarge?.copyWith(color: AppPalette.ink),
      bodyMedium: inter.bodyMedium?.copyWith(color: AppPalette.ink),
      bodySmall: inter.bodySmall?.copyWith(color: AppPalette.inkSoft),
      labelLarge: inter.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      labelSmall: inter.labelSmall?.copyWith(
        color: AppPalette.inkSoft,
        fontWeight: FontWeight.w700,
      ),
    );

    return FlexThemeData.light(
      colors: _scheme,
      useMaterial3: true,
      scaffoldBackground: AppPalette.canvas,
      surface: AppPalette.pureWhite,
      dialogBackground: AppPalette.pureWhite,
      appBarBackground: AppPalette.pureWhite,
      appBarElevation: 0,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: base,
    ).copyWith(
      cardTheme: CardThemeData(
        color: AppPalette.cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppPalette.line, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.fieldFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppPalette.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppPalette.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppPalette.primary, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppPalette.primary,
          foregroundColor: AppPalette.pureWhite,
          disabledBackgroundColor: AppPalette.line,
          disabledForegroundColor: AppPalette.inkSoft,
          minimumSize: const Size.fromHeight(52),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppPalette.line,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppPalette.darkSurface,
        contentTextStyle: GoogleFonts.inter(
          textStyle: const TextStyle(color: AppPalette.pureWhite),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static TextStyle _headline(double size) => GoogleFonts.plusJakartaSans(
        textStyle: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w700,
          color: AppPalette.ink,
          letterSpacing: -0.5,
        ),
      );
}
