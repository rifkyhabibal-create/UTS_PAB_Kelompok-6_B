import 'package:flutter/material.dart';

class AppColors {
  static const Color teal = Color(0xFF00A3BA);
  static const Color tealDark = Color(0xFF007A8C); 
  static const Color navy = Color(0xFF0B3A4F);
  static const Color yellow = Color(0xFFF6D042); 

  static const Color background = Color(0xFFEEF5F7); 
  static const Color textSoft = Color(0xFF4A6B7C); 

  static const Color diajukan = Color(0xFFF59E0B);
  static const Color ditinjau = Color(0xFF2563EB);
  static const Color disetujui = Color(0xFF16A34A);
  static const Color ditolak = Color(0xFFDC2626);
}

class AppTheme {
  static ThemeData get light {
    final skema = ColorScheme.fromSeed(seedColor: AppColors.tealDark)
        .copyWith(primary: AppColors.tealDark);

    return ThemeData(
      useMaterial3: true,
      colorScheme: skema,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: ThemeData.light()
          .textTheme
          .apply(bodyColor: AppColors.navy, displayColor: AppColors.navy),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xCCFFFFFF),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0x33007A8C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0x33007A8C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.tealDark, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.ditolak),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.ditolak, width: 1.6),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tealDark,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
