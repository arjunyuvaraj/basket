import 'package:basket/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = mainTheme.copyWith(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF202124),
  colorScheme: ColorScheme.dark(
    primary: Colors.white,
    secondary: Color(0xFFC7C7C7),
    tertiary: Color(0xFFd2d3d3),
    surface: Color(0xFF202124),
    error: Colors.redAccent[100] as Color,
    onError: Colors.white,
    onPrimary: Color(0xFF202124),
    onSecondary: Colors.white70,
    onTertiary: Colors.white60,
    onSurface: Colors.white,
  ),
  primaryTextTheme: GoogleFonts.poppinsTextTheme(
    ThemeData.dark().textTheme.apply(bodyColor: Colors.white),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF202124),
    selectedIconTheme: const IconThemeData(color: Colors.white, size: 28),
    unselectedIconTheme: IconThemeData(color: Colors.white60, size: 26),
    selectedLabelStyle: const TextStyle(color: Colors.white),
    unselectedLabelStyle: const TextStyle(color: Colors.white60),
    type: BottomNavigationBarType.fixed,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF202124),
    hintStyle: const TextStyle(color: Colors.white54),
    labelStyle: const TextStyle(color: Colors.white),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white54, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.raleway(fontSize: 14, color: Colors.white),
    bodySmall: GoogleFonts.raleway(
      fontSize: 12,
      fontStyle: FontStyle.italic,
      color: Colors.white60,
    ),
  ),
);
