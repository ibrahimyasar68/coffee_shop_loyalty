import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Uygulamanın marka renkleri — tüm ekranlarda buradan kullanılmalı.
/// Daha önce ekranlara dağılmış hex kodları bunlarla değiştirildi.
class AppColors {
  AppColors._();

  // Kahve paleti
  static const espresso = Color(0xFF3B1F0E); // en koyu — appbar/surface vurgu
  static const coffee = Color(0xFF6B3A2A); // koyu kahve
  static const mocha = Color(0xFF8B5E3C); // orta kahve
  static const caramel = Color(0xFFD4A574); // altın aksan
  static const cream = Color(0xFFFAF6F1); // açık arka plan
  static const espressoNight = Color(0xFF1A0A05); // koyu tema arka planı

  // Nötr
  static const ink = Color(0xFF3B1F0E); // ana metin (açık tema)
  static const muted = Color(0xFF9CA3AF); // ikincil metin

  // ── Gradyanlar ──────────────────────────────────────────────
  /// Başlık/AppBar derinliği için espresso → koyu kahve geçişi.
  static const headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2A1308), espresso, coffee],
  );

  /// Birincil CTA butonları için sıcak, altın vurgulu geçiş.
  static const ctaGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [coffee, espresso],
  );

  /// Kartların krem zeminden ayrışması için yumuşak ama belirgin gölge.
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: espresso.withValues(alpha: 0.10),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
}

class AppRadius {
  AppRadius._();
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 20.0;
}

class AppTheme {
  AppTheme._();

  // Poppins gövde + Playfair Display başlık tipografisi
  static TextTheme _textTheme(TextTheme base) {
    final body = GoogleFonts.poppinsTextTheme(base);
    return body.copyWith(
      displayLarge: GoogleFonts.playfairDisplay(textStyle: body.displayLarge),
      displayMedium: GoogleFonts.playfairDisplay(textStyle: body.displayMedium),
      displaySmall: GoogleFonts.playfairDisplay(textStyle: body.displaySmall),
      headlineLarge: GoogleFonts.playfairDisplay(
          textStyle: body.headlineLarge, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.playfairDisplay(
          textStyle: body.headlineMedium, fontWeight: FontWeight.w700),
    );
  }

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.espresso,
      primary: AppColors.espresso,
      secondary: AppColors.caramel,
      surface: Colors.white,
      brightness: Brightness.light,
    );
    return _base(scheme, scaffold: AppColors.cream);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.caramel,
      primary: AppColors.caramel,
      secondary: AppColors.mocha,
      surface: const Color(0xFF241309),
      brightness: Brightness.dark,
    );
    return _base(scheme, scaffold: AppColors.espressoNight);
  }

  static ThemeData _base(ColorScheme scheme, {required Color scaffold}) {
    final isDark = scheme.brightness == Brightness.dark;
    final onSurface = isDark ? Colors.white : AppColors.ink;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      textTheme: _textTheme(
          isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.espresso,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),

      // Modern dolgulu, yuvarlak, çizgisiz inputlar
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Colors.white10 : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(color: onSurface.withValues(alpha: 0.7)),
        floatingLabelStyle: const TextStyle(color: AppColors.mocha),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
              color: isDark ? Colors.white12 : const Color(0xFFE5DDD5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.mocha, width: 1.6),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.espresso,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFE5DDD5),
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          textStyle: GoogleFonts.poppins(
              fontSize: 15, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.mocha,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.mocha),
          textStyle: GoogleFonts.poppins(
              fontSize: 15, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF2A1710) : Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.espresso,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.espresso,
        indicatorColor: AppColors.caramel.withValues(alpha: 0.22),
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.caramel,
          ),
        ),
        iconTheme: WidgetStateProperty.all(
          const IconThemeData(color: AppColors.caramel, size: 22),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.coffee,
        foregroundColor: Colors.white,
      ),
    );
  }
}
