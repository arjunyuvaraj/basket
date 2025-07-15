import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData mainTheme = ThemeData(
  fontFamily: 'Poppins', // fallback font
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
    bodyMedium: GoogleFonts.raleway(fontSize: 14),
    bodySmall: GoogleFonts.raleway(fontSize: 12, fontStyle: FontStyle.italic),
  ),
  primaryTextTheme: GoogleFonts.poppinsTextTheme(), // For AppBar etc.
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  ),
  dividerColor: Colors.transparent,
  useMaterial3: true,
  iconTheme: IconThemeData(size: 32),
);
