import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _initialTimeKey = 'initial_time_minutes';
  static const String _incrementKey = 'increment_seconds';
  static const String _timePresetKey = 'time_preset';
  static const String _incrementPresetKey = 'increment_preset';
  static const String _isPlayer1WhiteKey = 'is_player1_white';
  static const String _isSoundEnabledKey = 'is_sound_enabled';
  static const String _isVibrateEnabledKey = 'is_vibrate_enabled';
  static const String _isDarkModeKey = 'is_dark_mode';
  static const String _fontSizeKey = 'font_size';
  static const String _themeIndexKey = 'theme_index';
  static const String _isImmersiveModeKey = 'is_immersive_mode';
  
  static double getFontSize() {
    return _prefs?.getDouble(_fontSizeKey) ?? 60.0;
  }

  static Future<void> setFontSize(double value) async {
    await _prefs?.setDouble(_fontSizeKey, value);
  }

  static int getThemeIndex() {
    return _prefs?.getInt(_themeIndexKey) ?? 0;
  }

  static Future<void> setThemeIndex(int value) async {
    await _prefs?.setInt(_themeIndexKey, value);
  }

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Getters
  static int getInitialTimeMinutes() {
    return _prefs?.getInt(_initialTimeKey) ?? 5;
  }

  static int getIncrementSeconds() {
    return _prefs?.getInt(_incrementKey) ?? 3;
  }

  static String getTimePreset() {
    return _prefs?.getString(_timePresetKey) ?? '5min';
  }

  static String getIncrementPreset() {
    return _prefs?.getString(_incrementPresetKey) ?? '3s';
  }

  static bool getIsPlayer1White() {
    return _prefs?.getBool(_isPlayer1WhiteKey) ?? true;
  }

  static bool getIsSoundEnabled() {
    return _prefs?.getBool(_isSoundEnabledKey) ?? true;
  }

  static bool getIsVibrateEnabled() {
    return _prefs?.getBool(_isVibrateEnabledKey) ?? true;
  }

  static bool getIsDarkMode() {
    return _prefs?.getBool(_isDarkModeKey) ?? false;
  }

  static bool getIsImmersiveMode() {
    return _prefs?.getBool(_isImmersiveModeKey) ?? false;
  }

  // Setters
  static Future<void> setInitialTimeMinutes(int minutes) async {
    await _prefs?.setInt(_initialTimeKey, minutes);
  }

  static Future<void> setIncrementSeconds(int seconds) async {
    await _prefs?.setInt(_incrementKey, seconds);
  }

  static Future<void> setTimePreset(String preset) async {
    await _prefs?.setString(_timePresetKey, preset);
  }

  static Future<void> setIncrementPreset(String preset) async {
    await _prefs?.setString(_incrementPresetKey, preset);
  }

  static Future<void> setIsPlayer1White(bool value) async {
    await _prefs?.setBool(_isPlayer1WhiteKey, value);
  }

  static Future<void> setIsSoundEnabled(bool value) async {
    await _prefs?.setBool(_isSoundEnabledKey, value);
  }

  static Future<void> setIsVibrateEnabled(bool value) async {
    await _prefs?.setBool(_isVibrateEnabledKey, value);
  }

  static Future<void> setIsDarkMode(bool value) async {
    await _prefs?.setBool(_isDarkModeKey, value);
  }

  static Future<void> setIsImmersiveMode(bool value) async {
    await _prefs?.setBool(_isImmersiveModeKey, value);
  }

  // Clear all preferences
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
