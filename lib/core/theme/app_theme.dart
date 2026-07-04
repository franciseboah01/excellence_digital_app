import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EdcTheme {
  // Couleurs du Design System
  static const Color bgDeep = Color(0xFF0B0F1A);
  static const Color bgBase = Color(0xFF111827);
  static const Color bgCard = Color(0xFF1A2235);
  static const Color bgInput = Color(0xFF151B2B);
  static const Color bgElevated = Color(0xFF232D45);
  
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1D4ED8);
  
  static const Color secondary = Color(0xFF10B981);
  static const Color accentWarm = Color(0xFFF43F5E);
  static const Color accentGold = Color(0xFFFBBF24);
  static const Color purple = Color(0xFF8B5CF6);
  
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  
  static const Color border = Color(0xFF2A3552);
  static const Color borderFocus = Color(0xFF3B82F6);
  
  static const Color success = Color(0xFF10B981);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  // Dégradés
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F2447), Color(0xFF1A1642), Color(0xFF1E1B4B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [secondary, Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient whatsappGradient = LinearGradient(
    colors: [Color(0xFF25D366), Color(0xFF128C7E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Ombres
  static BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.35),
    blurRadius: 24,
    offset: const Offset(0, 4),
  );
  
  static BoxShadow glowShadow = BoxShadow(
    color: primary.withOpacity(0.2),
    blurRadius: 24,
    offset: Offset.zero,
  );
  
  // Radius
  static const double radiusXs = 8;
  static const double radiusSm = 10;
  static const double radius = 14;
  static const double radiusLg = 20;
  static const double radiusXl = 24;

  // Thème Material 3
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDeep,
      
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: bgCard,
        error: danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
        surfaceContainerHighest: bgElevated,
      ),
      
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
          headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
          titleSmall: TextStyle(color: textSecondary, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: textPrimary),
          bodyMedium: TextStyle(color: textSecondary),
          bodySmall: TextStyle(color: textMuted),
          labelLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
          labelMedium: TextStyle(color: textSecondary, fontWeight: FontWeight.w500),
          labelSmall: TextStyle(color: textMuted, fontWeight: FontWeight.w500),
        ),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: bgDeep.withOpacity(0.92),
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: textSecondary),
      ),
      
      cardTheme: CardTheme(
        color: bgCard,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primary.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          minimumSize: const Size(double.infinity, 52),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryLight,
          side: const BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          minimumSize: const Size(double.infinity, 52),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryLight,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgInput,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: danger),
        ),
        hintStyle: const TextStyle(color: textMuted),
        labelStyle: const TextStyle(color: textSecondary),
        prefixIconColor: textMuted,
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgBase,
        selectedItemColor: primaryLight,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
      
      chipTheme: ChipThemeData(
        backgroundColor: primary.withOpacity(0.12),
        labelStyle: GoogleFonts.inter(color: primaryLight, fontSize: 12, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      
      snackBarTheme: SnackBarThemeData(
        backgroundColor: bgCard,
        contentTextStyle: const TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
      
      dialogTheme: DialogTheme(
        backgroundColor: bgCard,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: border),
        ),
      ),
      
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
      ),
      
      tabBarTheme: TabBarTheme(
        labelColor: primaryLight,
        unselectedLabelColor: textMuted,
        indicatorColor: primary,
        dividerColor: Colors.transparent,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
      ),
    );
  }
}