import 'package:basket/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = mainTheme.copyWith(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: Color(0xFF202124),
    secondary: Colors.grey.shade800,
    tertiary: Colors.black45,
    surface: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white, // text on primary (black) if needed
    onSecondary: Color(0xFF202124),
    onTertiary: Colors.white,
    onSurface: Color(0xFF202124),
  ),
  primaryTextTheme: GoogleFonts.poppinsTextTheme(
    ThemeData.dark().textTheme.apply(bodyColor: Color(0xFF202124)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white, // white background
    selectedIconTheme: const IconThemeData(color: Color(0xFF202124), size: 28),
    unselectedIconTheme: IconThemeData(color: Colors.grey.shade600, size: 28),
    selectedLabelStyle: const TextStyle(color: Color(0xFF202124)),
    unselectedLabelStyle: TextStyle(color: Colors.grey.shade600),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: Color(0xFF202124),
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Color(0xFF202124),
    ),
    headlineSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color(0xFF202124),
    ),
    bodyLarge: GoogleFonts.raleway(fontSize: 16, color: Color(0xFF202124)),
    bodyMedium: GoogleFonts.raleway(fontSize: 14, color: Color(0xFF202124)),
    bodySmall: GoogleFonts.raleway(
      fontSize: 12,
      fontStyle: FontStyle.italic,
      color: Color(0xFF202124),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      color: Color(0xFF202124), // visible label color when not focused
      fontWeight: FontWeight.w600,
    ),
    floatingLabelStyle: TextStyle(
      color: Color(0xFF202124),
      fontWeight: FontWeight.w700,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black45, width: 1.5),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black45, width: 1.5),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);
