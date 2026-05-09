import 'dart:convert';
import '../services/preferences_service.dart';

enum TimeMode { fischer, usDelay, bronstein, none }

class TimePeriod {
  final Duration extraTime;
  final int triggerMoveCount;

  TimePeriod({required this.extraTime, required this.triggerMoveCount});

  Map<String, dynamic> toJson() => {
    'extraTime': extraTime.inMinutes,
    'triggerMoveCount': triggerMoveCount,
  };

  factory TimePeriod.fromJson(Map<String, dynamic> json) => TimePeriod(
    extraTime: Duration(minutes: json['extraTime'] as int),
    triggerMoveCount: json['triggerMoveCount'] as int,
  );
}

class GameSettings {
  final Duration initialTime;
  final Duration? player2InitialTime;
  final Duration increment;
  final TimeMode timeMode;
  final List<TimePeriod>? timePeriods;
  final bool isDarkMode;
  final bool isVibrateEnabled;
  final bool isSoundEnabled;
  final String timePreset;
  final String incrementPreset;
  final bool isPlayer1White;
  final double fontSize;
  final int themeIndex;
  final bool isImmersiveMode;
  final bool? addIncrementAtStart;

  GameSettings({
    required this.initialTime,
    this.player2InitialTime,
    required this.increment,
    this.timeMode = TimeMode.fischer,
    this.timePeriods,
    this.isDarkMode = true,
    this.isVibrateEnabled = true,
    this.isSoundEnabled = true,
    this.timePreset = "5min",
    this.incrementPreset = "2s",
    this.isPlayer1White = true,
    this.fontSize = 100.0,
    this.themeIndex = 1,
    this.isImmersiveMode = false,
    this.addIncrementAtStart,
  });

  // Constructor that loads from preferences
  GameSettings.fromPreferences()
      : initialTime = Duration(minutes: PreferencesService.getInitialTimeMinutes()),
        player2InitialTime = PreferencesService.getPlayer2InitialTimeMinutes() != null ? Duration(minutes: PreferencesService.getPlayer2InitialTimeMinutes()!) : null,
        increment = Duration(seconds: PreferencesService.getIncrementSeconds()),
        timeMode = TimeMode.values.firstWhere((e) => e.toString() == PreferencesService.getTimeMode(), orElse: () => TimeMode.fischer),
        timePeriods = PreferencesService.getTimePeriods().map((jsonStr) => TimePeriod.fromJson(jsonDecode(jsonStr))).toList(),
        timePreset = PreferencesService.getTimePreset(),
        incrementPreset = PreferencesService.getIncrementPreset(),
        isPlayer1White = PreferencesService.getIsPlayer1White(),
        isSoundEnabled = PreferencesService.getIsSoundEnabled(),
        isDarkMode = PreferencesService.getIsDarkMode(),
        isVibrateEnabled = PreferencesService.getIsVibrateEnabled(),
        fontSize = PreferencesService.getFontSize(),
        themeIndex = PreferencesService.getThemeIndex(),
        isImmersiveMode = PreferencesService.getIsImmersiveMode(),
        addIncrementAtStart = PreferencesService.getAddIncrementAtStart();

  GameSettings copyWith({
    Duration? initialTime,
    Duration? player2InitialTime,
    Duration? increment,
    TimeMode? timeMode,
    List<TimePeriod>? timePeriods,
    bool? isDarkMode,
    bool? isVibrateEnabled,
    bool? isSoundEnabled,
    String? timePreset,
    String? incrementPreset,
    bool? isPlayer1White,
    double? fontSize,
    int? themeIndex,
    bool? isImmersiveMode,
    bool? addIncrementAtStart,
  }) {
    return GameSettings(
      initialTime: initialTime ?? this.initialTime,
      player2InitialTime: player2InitialTime ?? this.player2InitialTime,
      increment: increment ?? this.increment,
      timeMode: timeMode ?? this.timeMode,
      timePeriods: timePeriods ?? this.timePeriods,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isVibrateEnabled: isVibrateEnabled ?? this.isVibrateEnabled,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      timePreset: timePreset ?? this.timePreset,
      incrementPreset: incrementPreset ?? this.incrementPreset,
      isPlayer1White: isPlayer1White ?? this.isPlayer1White,
      fontSize: fontSize ?? this.fontSize,
      themeIndex: themeIndex ?? this.themeIndex,
      isImmersiveMode: isImmersiveMode ?? this.isImmersiveMode,
      addIncrementAtStart: addIncrementAtStart ?? this.addIncrementAtStart,
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