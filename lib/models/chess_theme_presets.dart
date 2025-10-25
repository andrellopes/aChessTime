import 'package:flutter/material.dart';
import 'chess_theme_preset.dart';

/// Free themes - 4 basic themes for chess games
const List<ChessThemePreset> chessFreeThemes = [
  // 1. Classic Dark - Current app theme (default)
  ChessThemePreset(
    labelKey: 'themeClassicDark',
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    primary: Color(0xFF6366F1),
    secondary: Color(0xFF8B5CF6),
    accent: Color(0xFF32BCAD),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFCBD5E1),
    whitePlayerColor: Color(0xFFF8FAFC),
    blackPlayerColor: Color(0xFF1E293B),
    activeTimerColor: Color(0xFF32BCAD),
    warningColor: Color(0xFFF59E0B),
    criticalColor: Color(0xFFEF4444),
  ),
  
  // Traditional Board - Inspired by chess board
  ChessThemePreset(
    labelKey: 'themeTraditionalBoard',
    background: Color(0xFF1A1611),
    surface: Color(0xFF2C2419),
    primary: Color(0xFFD4B896),
    secondary: Color(0xFF8B5A2B),
    accent: Color(0xFFE4C29F),
    textPrimary: Color(0xFFF5F5DC),
    textSecondary: Color(0xFFD4B896),
    whitePlayerColor: Color(0xFFF5F5DC),
    blackPlayerColor: Color(0xFF8B5A2B),
    activeTimerColor: Color(0xFFE4C29F),
    warningColor: Color(0xFFD97706),
    criticalColor: Color(0xFFDC2626),
  ),
  
  // Green Focus - Green for focus and concentration
  ChessThemePreset(
    labelKey: 'themeGreenFocus',
    background: Color(0xFF0F1B0C),
    surface: Color(0xFF1F2F1A),
    primary: Color(0xFF22C55E),
    secondary: Color(0xFF059669),
    accent: Color(0xFF84CC16),
    textPrimary: Color(0xFFE8F5E8),
    textSecondary: Color(0xFFBBF7D0),
    whitePlayerColor: Color(0xFFE8F5E8),
    blackPlayerColor: Color(0xFF15803D),
    activeTimerColor: Color(0xFF84CC16),
    warningColor: Color(0xFFEAB308),
    criticalColor: Color(0xFFEF4444),
  ),
  
  // Tournament Blue - Inspired by professional tournaments
  ChessThemePreset(
    labelKey: 'themeTournamentBlue',
    background: Color(0xFF051025),
    surface: Color(0xFF1E3A8A),
    primary: Color(0xFF3B82F6),
    secondary: Color(0xFF1E40AF),
    accent: Color(0xFF60A5FA),
    textPrimary: Color(0xFFDDEAFE),
    textSecondary: Color(0xFF93C5FD),
    whitePlayerColor: Color(0xFFDDEAFE),
    blackPlayerColor: Color(0xFF1E40AF),
    activeTimerColor: Color(0xFF60A5FA),
    warningColor: Color(0xFFF59E0B),
    criticalColor: Color(0xFFEF4444),
  ),
];

/// Premium themes - 8 exclusive themes for enhanced experience
const List<ChessThemePreset> chessPremiumThemes = [
  // Royal Gold - Elegant golden tones
  ChessThemePreset(
    labelKey: 'themeRoyalGold',
    background: Color(0xFF1C1407),
    surface: Color(0xFF451A03),
    primary: Color(0xFFF59E0B),
    secondary: Color(0xFFD97706),
    accent: Color(0xFFFBBF24),
    textPrimary: Color(0xFFFEF3C7),
    textSecondary: Color(0xFFFDE68A),
    whitePlayerColor: Color(0xFFFEF3C7),
    blackPlayerColor: Color(0xFFB45309),
    activeTimerColor: Color(0xFFFBBF24),
    warningColor: Color(0xFFEA580C),
    criticalColor: Color(0xFFDC2626),
  ),
  
  // Grandmaster Purple - Luxury and sophistication colors
  ChessThemePreset(
    labelKey: 'themeGrandmasterPurple',
    background: Color(0xFF1E1B4B),
    surface: Color(0xFF312E81),
    primary: Color(0xFFA855F7),
    secondary: Color(0xFF9333EA),
    accent: Color(0xFFC084FC),
    textPrimary: Color(0xFFF3E8FF),
    textSecondary: Color(0xFFE9D5FF),
    whitePlayerColor: Color(0xFFF3E8FF),
    blackPlayerColor: Color(0xFF7C3AED),
    activeTimerColor: Color(0xFFC084FC),
    warningColor: Color(0xFFF59E0B),
    criticalColor: Color(0xFFEF4444),
  ),
  
  // Competitive Red - For intense games
  ChessThemePreset(
    labelKey: 'themeCompetitiveRed',
    background: Color(0xFF1F0A0A),
    surface: Color(0xFF451A03),
    primary: Color(0xFFDC2626),
    secondary: Color(0xFFEA580C),
    accent: Color(0xFFF59E0B),
    textPrimary: Color(0xFFFEF2F2),
    textSecondary: Color(0xFFFECACA),
    whitePlayerColor: Color(0xFFFEF2F2),
    blackPlayerColor: Color(0xFFB91C1C),
    activeTimerColor: Color(0xFFF59E0B),
    warningColor: Color(0xFFEA580C),
    criticalColor: Color(0xFFDC2626),
  ),
  
  // Deep Ocean - Calming blues
  ChessThemePreset(
    labelKey: 'themeDeepOcean',
    background: Color(0xFF051025),
    surface: Color(0xFF1E3A8A),
    primary: Color(0xFF0284C7),
    secondary: Color(0xFF0EA5E9),
    accent: Color(0xFF06B6D4),
    textPrimary: Color(0xFFBAE6FD),
    textSecondary: Color(0xFF7DD3FC),
    whitePlayerColor: Color(0xFFBAE6FD),
    blackPlayerColor: Color(0xFF0369A1),
    activeTimerColor: Color(0xFF06B6D4),
    warningColor: Color(0xFFF59E0B),
    criticalColor: Color(0xFFEF4444),
  ),
  
  // Mystic Forest - Natural and relaxing greens
  ChessThemePreset(
    labelKey: 'themeMysticForest',
    background: Color(0xFF052E16),
    surface: Color(0xFF14532D),
    primary: Color(0xFF16A34A),
    secondary: Color(0xFF15803D),
    accent: Color(0xFF22C55E),
    textPrimary: Color(0xFFDCFCE7),
    textSecondary: Color(0xFFBBF7D0),
    whitePlayerColor: Color(0xFFDCFCE7),
    blackPlayerColor: Color(0xFF166534),
    activeTimerColor: Color(0xFF22C55E),
    warningColor: Color(0xFFEAB308),
    criticalColor: Color(0xFFEF4444),
  ),
  
  // Elegant Rose - Sophisticated and unique
  ChessThemePreset(
    labelKey: 'themeElegantRose',
    background: Color(0xFF190A0E),
    surface: Color(0xFF44172C),
    primary: Color(0xFFEC4899),
    secondary: Color(0xFFF472B6),
    accent: Color(0xFFF9A8D4),
    textPrimary: Color(0xFFFDF2F8),
    textSecondary: Color(0xFFFCE7F3),
    whitePlayerColor: Color(0xFFFDF2F8),
    blackPlayerColor: Color(0xFFBE185D),
    activeTimerColor: Color(0xFFF9A8D4),
    warningColor: Color(0xFFF59E0B),
    criticalColor: Color(0xFFEF4444),
  ),
  
  // Premium Silver - Sophisticated metallic tones
  ChessThemePreset(
    labelKey: 'themePremiumSilver',
    background: Color(0xFF0C0A09),
    surface: Color(0xFF1F2937),
    primary: Color(0xFF9CA3AF),
    secondary: Color(0xFF6B7280),
    accent: Color(0xFFE5E7EB),
    textPrimary: Color(0xFFF9FAFB),
    textSecondary: Color(0xFFD1D5DB),
    whitePlayerColor: Color(0xFFF9FAFB),
    blackPlayerColor: Color(0xFF374151),
    activeTimerColor: Color(0xFFE5E7EB),
    warningColor: Color(0xFFF59E0B),
    criticalColor: Color(0xFFEF4444),
  ),
  
  // Aurora Borealis - Mystical and inspiring colors
  ChessThemePreset(
    labelKey: 'themeAuroraBoreal',
    background: Color(0xFF0A0F1C),
    surface: Color(0xFF1E1B4B),
    primary: Color(0xFF06B6D4),
    secondary: Color(0xFF8B5CF6),
    accent: Color(0xFF10B981),
    textPrimary: Color(0xFFE0F2FE),
    textSecondary: Color(0xFFBAE6FD),
    whitePlayerColor: Color(0xFFE0F2FE),
    blackPlayerColor: Color(0xFF581C87),
    activeTimerColor: Color(0xFF10B981),
    warningColor: Color(0xFFF59E0B),
    criticalColor: Color(0xFFEF4444),
  ),
];

List<ChessThemePreset> getAvailableChessThemes(bool isPremium) {
  return isPremium 
    ? [...chessFreeThemes, ...chessPremiumThemes]
    : chessFreeThemes;
}

bool isChessThemePremium(int index) {
  return index >= chessFreeThemes.length;
}

ChessThemePreset? getChessThemeByIndex(int index, bool isPremium) {
  final availableThemes = getAvailableChessThemes(isPremium);
  if (index >= 0 && index < availableThemes.length) {
    return availableThemes[index];
  }
  return null;
}

ChessThemePreset get defaultChessTheme => chessFreeThemes[0];
