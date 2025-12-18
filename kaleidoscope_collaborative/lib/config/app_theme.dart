import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// App Theme Constants
class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF6750A4);
  static const Color primaryColorDark = Color(0xFF4A3580);
  static const Color backgroundColor = Colors.white;

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryColorDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Styles with Open Sans font
  static TextStyle headingStyle = GoogleFonts.openSans(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static TextStyle subheadingStyle = GoogleFonts.openSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );

  static TextStyle buttonTextStyle = GoogleFonts.openSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle textButtonStyle = GoogleFonts.openSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: primaryColorDark,
  );

  // Get theme data for the entire app
  static ThemeData getThemeData() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: GoogleFonts.openSans().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.openSans(fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.openSans(fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.normal),
        bodyMedium: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.normal),
        bodySmall: GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.normal),
      ),
    );
  }
}
