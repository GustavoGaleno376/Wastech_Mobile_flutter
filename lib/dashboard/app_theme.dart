import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF2D6A4F);
  static const Color primaryLight = Color(0xFF52B788);
  static const Color primaryLighter = Color(0xFF95D5B2);
  static const Color primaryDark = Color(0xFF1B4332);
  static const Color background = Color(0xFFF8FAF9);
  static const Color backgroundGreen = Color(0xFFE8FFF0);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1D1D1D);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);

  static const Color blue = Color(0xFF2196F3);
  static const Color blueLight = Color(0xFFE3F2FD);
  static const Color purple = Color(0xFF7B61FF);
  static const Color purpleLight = Color(0xFFEDE7F6);
  static const Color orange = Color(0xFFFF8C42);
  static const Color orangeLight = Color(0xFFFFF3E0);
  static const Color red = Color(0xFFE53935);
  static const Color redLight = Color(0xFFFFEBEE);
  static const Color amber = Color(0xFFFFA726);
  static const Color greenLight = Color(0xFFE8F5E9);
  static const Color brown = Color(0xFF8D6E63);
  static const Color brownLight = Color(0xFFEFEBE9);

  static const Color gradientStart = Color(0xFF2D6A4F);
  static const Color gradientEnd = Color(0xFF52B788);
  static const Color gradientFireStart = Color(0xFFE53935);
  static const Color gradientFireEnd = Color(0xFFFF8C42);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.zero,
        color: AppColors.surface,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 8,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),

      ),
    );
  }
}
