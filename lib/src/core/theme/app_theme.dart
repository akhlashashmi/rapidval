import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  final Ref ref;

  AppThemes(this.ref);

  ColorScheme get _darkMUIScheme {
    return ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.blue,
    );
  }

  ColorScheme get _lightMUIScheme {
    return ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.blue,
    );
  }

  ThemeData get materialLightTheme {
    final scheme = _lightMUIScheme;
    return ThemeData(
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        surfaceTintColor: scheme.surface,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      scaffoldBackgroundColor: scheme.surface,
      // textTheme: GoogleFonts.outfitTextTheme(
      //   ThemeData.dark().textTheme,
      // ).apply(bodyColor: Colors.white, displayColor: Colors.white),
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.light().textTheme,
      ).apply(bodyColor: Colors.black, displayColor: Colors.black),
      useMaterial3: true,
    );
  }

  ThemeData get materialDarkTheme {
    final scheme = _darkMUIScheme;
    return ThemeData(
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        surfaceTintColor: scheme.surface,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      scaffoldBackgroundColor: scheme.surface,
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.dark().textTheme,
      ).apply(bodyColor: Colors.white, displayColor: Colors.white),
      useMaterial3: true,
    );
  }
}

final appThemesProvider = Provider<AppThemes>((ref) {
  // Return an AppThemes instance configured with a default color
  return AppThemes(ref);
});
