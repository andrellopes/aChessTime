import '../services/preferences_service.dart';

class GameSettings {
  final Duration initialTime;
  final Duration increment;
  final bool isDarkMode;
  final bool isVibrateEnabled;
  final bool isSoundEnabled;
  final String timePreset;
  final String incrementPreset;
  final bool isPlayer1White;
  final double fontSize;
  final int themeIndex;
  final bool isImmersiveMode;

  GameSettings({
    required this.initialTime,
    required this.increment,
    this.isDarkMode = true,
    this.isVibrateEnabled = true,
    this.isSoundEnabled = true,
    this.timePreset = "5min",
    this.incrementPreset = "2s",
    this.isPlayer1White = true,
    this.fontSize = 100.0,
    this.themeIndex = 0,
    this.isImmersiveMode = false,
  });

  // Constructor that loads from preferences
  GameSettings.fromPreferences()
      : initialTime = Duration(minutes: PreferencesService.getInitialTimeMinutes()),
        increment = Duration(seconds: PreferencesService.getIncrementSeconds()),
        timePreset = PreferencesService.getTimePreset(),
        incrementPreset = PreferencesService.getIncrementPreset(),
        isPlayer1White = PreferencesService.getIsPlayer1White(),
        isSoundEnabled = PreferencesService.getIsSoundEnabled(),
        isDarkMode = PreferencesService.getIsDarkMode(),
        isVibrateEnabled = PreferencesService.getIsVibrateEnabled(),
        fontSize = PreferencesService.getFontSize(),
        themeIndex = PreferencesService.getThemeIndex(),
        isImmersiveMode = PreferencesService.getIsImmersiveMode();

  GameSettings copyWith({
    Duration? initialTime,
    Duration? increment,
    bool? isDarkMode,
    bool? isVibrateEnabled,
    bool? isSoundEnabled,
    String? timePreset,
    String? incrementPreset,
    bool? isPlayer1White,
    double? fontSize,
    int? themeIndex,
    bool? isImmersiveMode,
  }) {
    return GameSettings(
      initialTime: initialTime ?? this.initialTime,
      increment: increment ?? this.increment,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isVibrateEnabled: isVibrateEnabled ?? this.isVibrateEnabled,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      timePreset: timePreset ?? this.timePreset,
      incrementPreset: incrementPreset ?? this.incrementPreset,
      isPlayer1White: isPlayer1White ?? this.isPlayer1White,
      fontSize: fontSize ?? this.fontSize,
      themeIndex: themeIndex ?? this.themeIndex,
      isImmersiveMode: isImmersiveMode ?? this.isImmersiveMode,
    );
  }

  static Map<String, Duration> timePresets = {
    "1min": const Duration(minutes: 1),
    "3min": const Duration(minutes: 3),
    "5min": const Duration(minutes: 5),
    "10min": const Duration(minutes: 10),
    "custom": const Duration(minutes: 5),
  };

  static Map<String, Duration> incrementPresets = {
    "0s": Duration.zero,
    "1s": const Duration(seconds: 1),
    "2s": const Duration(seconds: 2),
    "3s": const Duration(seconds: 3),
    "5s": const Duration(seconds: 5),
    "10s": const Duration(seconds: 10),
    "custom": const Duration(seconds: 2),
  };
}