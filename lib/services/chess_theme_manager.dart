import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chess_theme_preset.dart';
import '../models/chess_theme_presets.dart';
import 'purchase_service.dart';

class ChessThemeManager extends ChangeNotifier {
  static final ChessThemeManager _instance = ChessThemeManager._internal();
  factory ChessThemeManager() => _instance;

  static const String _themeIndexKey = 'chess_theme_preset_index';
  static const String _customBackgroundKey = 'chess_custom_background';
  static const String _customSurfaceKey = 'chess_custom_surface';
  static const String _customPrimaryKey = 'chess_custom_primary';
  static const String _customSecondaryKey = 'chess_custom_secondary';
  static const String _customAccentKey = 'chess_custom_accent';
  static const String _customTextPrimaryKey = 'chess_custom_text_primary';
  static const String _customTextSecondaryKey = 'chess_custom_text_secondary';
  static const String _customWhitePlayerColorKey = 'chess_custom_white_player_color';
  static const String _customBlackPlayerColorKey = 'chess_custom_black_player_color';
  static const String _customActiveTimerColorKey = 'chess_custom_active_timer_color';
  static const String _customWarningColorKey = 'chess_custom_warning_color';
  static const String _customCriticalColorKey = 'chess_custom_critical_color';
  
  int _currentThemeIndex = 0;
  late ChessThemePreset _currentTheme;
  bool _isPremium = false; // Default: not premium
  PurchaseService? _purchaseService;
  
  void setPurchaseService(PurchaseService service) {
    _purchaseService = service;
    _purchaseService!.addListener(_onPurchaseChanged);
    _checkPremiumStatus();
  }
  
  void _onPurchaseChanged() {
    updatePremiumStatus(_purchaseService!.isProVersion);
  }
  
  Color _customBackground = const Color(0xFF0F172A);
  Color _customSurface = const Color(0xFF1E293B);
  Color _customPrimary = const Color(0xFF6366F1);
  Color _customSecondary = const Color(0xFF8B5CF6);
  Color _customAccent = const Color(0xFF32BCAD);
  Color _customTextPrimary = const Color(0xFFFFFFFF);
  Color _customTextSecondary = const Color(0xFFCBD5E1);
  Color _customWhitePlayerColor = const Color(0xFFF8FAFC);
  Color _customBlackPlayerColor = const Color(0xFF1E293B);
  Color _customActiveTimerColor = const Color(0xFF32BCAD);
  Color _customWarningColor = const Color(0xFFF59E0B);
  Color _customCriticalColor = const Color(0xFFEF4444);
  
  ChessThemeManager._internal() {
    _currentTheme = defaultChessTheme;
  }
  
  int get currentThemeIndex => _currentThemeIndex;
  bool get isPremium => _isPremium;
  ChessThemePreset get currentTheme => _currentTheme;
  bool get isCustomTheme => _currentThemeIndex == -1;
  
  void setPremiumStatus(bool isPremium) {
    _isPremium = isPremium;
    notifyListeners();
  }
  
  List<ChessThemePreset> get availableThemes => getAvailableChessThemes(_isPremium);
  
  Color get backgroundColor => isCustomTheme ? _customBackground : _currentTheme.background;
  Color get surfaceColor => isCustomTheme ? _customSurface : _currentTheme.surface;
  Color get primaryColor => isCustomTheme ? _customPrimary : _currentTheme.primary;
  Color get secondaryColor => isCustomTheme ? _customSecondary : _currentTheme.secondary;
  Color get accentColor => isCustomTheme ? _customAccent : _currentTheme.accent;
  Color get textPrimaryColor => isCustomTheme ? _customTextPrimary : _currentTheme.textPrimary;
  Color get textSecondaryColor => isCustomTheme ? _customTextSecondary : _currentTheme.textSecondary;
  Color get whitePlayerColor => isCustomTheme ? _customWhitePlayerColor : _currentTheme.whitePlayerColor;
  Color get blackPlayerColor => isCustomTheme ? _customBlackPlayerColor : _currentTheme.blackPlayerColor;
  Color get activeTimerColor => isCustomTheme ? _customActiveTimerColor : _currentTheme.activeTimerColor;
  Color get warningColor => isCustomTheme ? _customWarningColor : _currentTheme.warningColor;
  Color get criticalColor => isCustomTheme ? _customCriticalColor : _currentTheme.criticalColor;
  
  Color get cardColor => surfaceColor;
  Color get mutedTextColor => textSecondaryColor.withOpacity(0.6);
  
  LinearGradient get backgroundGradient {
    if (isCustomTheme) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          _customPrimary.withOpacity(0.8),
          _customSecondary.withOpacity(0.6),
          _customAccent.withOpacity(0.4),
        ],
      );
    }
    return _currentTheme.createBackgroundGradient();
  }
  
  /// Methods for compatibility with PlayerTimerWidget
  Color getPlayerColor(bool isWhite) {
    return isWhite ? whitePlayerColor : blackPlayerColor;
  }
  
  Color getTimerColor(bool isActive, bool isLowTime, bool isVeryLowTime) {
    if (isVeryLowTime) return criticalColor;
    if (isLowTime) return warningColor;
    if (isActive) return activeTimerColor;
    return textPrimaryColor;
  }
  
  /// Initialization
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    await _loadSettings(prefs);
    await _checkPremiumStatus();
  }
  
  Future<void> _checkPremiumStatus() async {
    if (_purchaseService != null) {
      _isPremium = _purchaseService!.isProVersion;
    } else {
      _isPremium = false;
    }
    notifyListeners();
  }
  
  void updatePremiumStatus(bool isPremium) {
    if (_isPremium != isPremium) {
      _isPremium = isPremium;
      notifyListeners();
    }
  }
  
  Future<void> _loadSettings(SharedPreferences prefs) async {
    _currentThemeIndex = prefs.getInt(_themeIndexKey) ?? 0;
    
    _customBackground = Color(prefs.getInt(_customBackgroundKey) ?? _customBackground.value);
    _customSurface = Color(prefs.getInt(_customSurfaceKey) ?? _customSurface.value);
    _customPrimary = Color(prefs.getInt(_customPrimaryKey) ?? _customPrimary.value);
    _customSecondary = Color(prefs.getInt(_customSecondaryKey) ?? _customSecondary.value);
    _customAccent = Color(prefs.getInt(_customAccentKey) ?? _customAccent.value);
    _customTextPrimary = Color(prefs.getInt(_customTextPrimaryKey) ?? _customTextPrimary.value);
    _customTextSecondary = Color(prefs.getInt(_customTextSecondaryKey) ?? _customTextSecondary.value);
    _customWhitePlayerColor = Color(prefs.getInt(_customWhitePlayerColorKey) ?? _customWhitePlayerColor.value);
    _customBlackPlayerColor = Color(prefs.getInt(_customBlackPlayerColorKey) ?? _customBlackPlayerColor.value);
    _customActiveTimerColor = Color(prefs.getInt(_customActiveTimerColorKey) ?? _customActiveTimerColor.value);
    _customWarningColor = Color(prefs.getInt(_customWarningColorKey) ?? _customWarningColor.value);
    _customCriticalColor = Color(prefs.getInt(_customCriticalColorKey) ?? _customCriticalColor.value);
    
    await _updateCurrentTheme();
    notifyListeners();
  }
  
  /// Applies a theme by index
  Future<bool> setTheme(int index) async {
    // Validate if it's premium theme
    if (isChessThemePremium(index) && !_isPremium) {
      return false; // Not premium, cannot use
    }
    
    if (index == -1) {
      _currentThemeIndex = -1;
      await _saveThemeIndex(-1);
      notifyListeners();
      return true;
    }
    
    final theme = getChessThemeByIndex(index, _isPremium);
    if (theme != null) {
      _currentThemeIndex = index;
      _currentTheme = theme;
      
      await _saveThemeIndex(index);
      notifyListeners();
      return true;
    }
    
    return false;
  }
  
  Future<void> setCustomTheme({
    required Color background,
    required Color surface,
    required Color primary,
    required Color secondary,
    required Color accent,
    required Color textPrimary,
    required Color textSecondary,
    required Color whitePlayerColor,
    required Color blackPlayerColor,
    required Color activeTimerColor,
    required Color warningColor,
    required Color criticalColor,
  }) async {
    _currentThemeIndex = -1;
    _customBackground = background;
    _customSurface = surface;
    _customPrimary = primary;
    _customSecondary = secondary;
    _customAccent = accent;
    _customTextPrimary = textPrimary;
    _customTextSecondary = textSecondary;
    _customWhitePlayerColor = whitePlayerColor;
    _customBlackPlayerColor = blackPlayerColor;
    _customActiveTimerColor = activeTimerColor;
    _customWarningColor = warningColor;
    _customCriticalColor = criticalColor;
    
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      _saveThemeIndex(-1),
      prefs.setInt(_customBackgroundKey, background.value),
      prefs.setInt(_customSurfaceKey, surface.value),
      prefs.setInt(_customPrimaryKey, primary.value),
      prefs.setInt(_customSecondaryKey, secondary.value),
      prefs.setInt(_customAccentKey, accent.value),
      prefs.setInt(_customTextPrimaryKey, textPrimary.value),
      prefs.setInt(_customTextSecondaryKey, textSecondary.value),
      prefs.setInt(_customWhitePlayerColorKey, whitePlayerColor.value),
      prefs.setInt(_customBlackPlayerColorKey, blackPlayerColor.value),
      prefs.setInt(_customActiveTimerColorKey, activeTimerColor.value),
      prefs.setInt(_customWarningColorKey, warningColor.value),
      prefs.setInt(_customCriticalColorKey, criticalColor.value),
    ]);
    
    notifyListeners();
  }
  
  /// Updates current theme based on index
  Future<void> _updateCurrentTheme() async {
    if (_currentThemeIndex != -1) {
      // Always uses true to load saved theme
      final theme = getChessThemeByIndex(_currentThemeIndex, true);
      if (theme != null) {
        _currentTheme = theme;
      } else {
        // Invalid theme, revert to default
        _currentThemeIndex = 0;
        _currentTheme = defaultChessTheme;
        await _saveThemeIndex(0);
      }
    }
  }
  
  Future<void> _saveThemeIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeIndexKey, index);
  }
  
  /// Gets the localized name of the current theme
  String getThemeName(String Function(String) localizer) {
    if (isCustomTheme) {
      return localizer('themeCustom');
    }
    return localizer(_currentTheme.labelKey);
  }
  
  /// Resets to the default theme
  Future<void> resetToDefault() async {
    await setTheme(0);
  }
  
  /// Gets the ThemeData based on the current theme
  ThemeData getThemeData() {
    if (isCustomTheme) {
      return _createCustomThemeData();
    } else if (_currentThemeIndex >= 0) {
      return _currentTheme.toThemeData();
    } else {
      return _createFallbackThemeData();
    }
  }
  
  ThemeData _createCustomThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: _customPrimary,
        secondary: _customSecondary,
        surface: _customSurface,
        background: _customBackground,
        onBackground: _customTextPrimary,
        onSurface: _customTextPrimary,
      ),
      scaffoldBackgroundColor: _customBackground,
      cardColor: _customSurface,
      appBarTheme: AppBarTheme(
        backgroundColor: _customSurface,
        foregroundColor: _customTextPrimary,
        elevation: 0,
      ),
    );
  }
  
  ThemeData _createFallbackThemeData() {
    return defaultChessTheme.toThemeData();
  }
}
