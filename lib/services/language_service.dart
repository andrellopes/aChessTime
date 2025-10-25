import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  
  Locale _currentLocale = const Locale('en'); // Default English
  
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('pt'), // Portuguese
    Locale('es'), // Español
    Locale('de'), // Deutsch
    Locale('fr'), // French
    Locale('it'), // Italiano
  ];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'pt': 'Português',
    'es': 'Español',
    'de': 'Deutsch',
    'fr': 'Français',
    'it': 'Italiano',
  };

  Locale get currentLocale => _currentLocale;
  String get currentLanguageCode => _currentLocale.languageCode;
  String get currentLanguageName => languageNames[_currentLocale.languageCode] ?? 'English';

  LanguageService() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString(_languageKey);
    
    if (savedLanguageCode != null) {
      _currentLocale = Locale(savedLanguageCode);
    } else {
      _currentLocale = _detectSystemLanguage();
      // Save automatic detection
      await _saveLanguage(_currentLocale.languageCode);
    }
    
    notifyListeners();
  }

  Locale _detectSystemLanguage() {
    final systemLocale = PlatformDispatcher.instance.locale;
    final systemLanguageCode = systemLocale.languageCode;
    
    // Check if system language is supported
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == systemLanguageCode) {
        debugPrint('System language detected: $systemLanguageCode');
        return supportedLocale;
      }
    }
    
    // If not supported, use English as default
    debugPrint('System language ($systemLanguageCode) not supported, using English');
    return const Locale('en');
  }

  Future<void> changeLanguage(String languageCode) async {
    if (!supportedLocales.any((locale) => locale.languageCode == languageCode)) {
      debugPrint('Unsupported language: $languageCode');
      return;
    }

    _currentLocale = Locale(languageCode);
    await _saveLanguage(languageCode);
    notifyListeners();
    
    debugPrint('Language changed to: $languageCode');
  }

  Future<void> _saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  // Method to get country flag/emoji (optional)
  String getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇺🇸';
      case 'pt':
        return '🇧🇷';
      case 'es':
        return '🇪🇸';
      case 'de':
        return '🇩🇪';
      case 'fr':
        return '🇫🇷';
      case 'it':
        return '🇮🇹';
      default:
        return '🌐';
    }
  }

  // METHODS FOR BACKUP AND RESTORATION

  // Gets data for backup
  Map<String, dynamic> getBackupData() {
    return {
      'selectedLanguage': currentLanguageCode,
    };
  }

  Future<void> restoreFromBackup(Map<String, dynamic> backupData) async {
    final languageCode = backupData['selectedLanguage'] ?? 'en';
    await changeLanguage(languageCode);
  }
}
