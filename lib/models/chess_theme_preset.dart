import 'package:flutter/material.dart';

class ChessThemePreset {
  final String labelKey;
  final Color background;
  final Color surface;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color whitePlayerColor;
  final Color blackPlayerColor;
  final Color activeTimerColor;
  final Color warningColor;
  final Color criticalColor;
  
  const ChessThemePreset({
    required this.labelKey,
    required this.background,
    required this.surface,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.whitePlayerColor,
    required this.blackPlayerColor,
    required this.activeTimerColor,
    required this.warningColor,
    required this.criticalColor,
  });
  
  /// Converts the preset to a Flutter ThemeData
  ThemeData toThemeData() {
    final brightness = _getBrightness();
    
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: brightness,
        primary: primary,
        secondary: secondary,
        surface: surface,
        background: background,
        onBackground: textPrimary,
        onSurface: textPrimary,
        onPrimary: brightness == Brightness.dark ? Colors.white : Colors.black,
        onSecondary: brightness == Brightness.dark ? Colors.white : Colors.black,
      ),
      scaffoldBackgroundColor: background,
      cardColor: surface,
      textTheme: TextTheme(
        displayLarge: TextStyle(color: textPrimary),
        displayMedium: TextStyle(color: textPrimary),
        displaySmall: TextStyle(color: textPrimary),
        headlineLarge: TextStyle(color: textPrimary),
        headlineMedium: TextStyle(color: textPrimary),
        headlineSmall: TextStyle(color: textPrimary),
        titleLarge: TextStyle(color: textPrimary),
        titleMedium: TextStyle(color: textPrimary),
        titleSmall: TextStyle(color: textPrimary),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textPrimary),
        bodySmall: TextStyle(color: textSecondary),
        labelLarge: TextStyle(color: textPrimary),
        labelMedium: TextStyle(color: textSecondary),
        labelSmall: TextStyle(color: textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
    );
  }
  
  Brightness _getBrightness() {
    return ThemeData.estimateBrightnessForColor(background);
  }
  
  /// Creates a gradient for the background using theme colors
  LinearGradient createBackgroundGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primary.withOpacity(0.8),
        secondary.withOpacity(0.6),
        accent.withOpacity(0.4),
      ],
    );
  }
  
  /// Gets the player color based on type (white/black)
  Color getPlayerColor(bool isWhite) {
    return isWhite ? whitePlayerColor : blackPlayerColor;
  }
  
  /// Gets the timer color based on state
  Color getTimerColor(bool isActive, bool isLowTime, bool isVeryLowTime) {
    if (isVeryLowTime) return criticalColor;
    if (isLowTime) return warningColor;
    if (isActive) return activeTimerColor;
    return textPrimary;
  }
}
