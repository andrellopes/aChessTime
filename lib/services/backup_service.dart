import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/preferences_service.dart';
import '../services/statistics_service.dart';
import '../services/chess_preset_service.dart';
import '../services/purchase_service.dart';
import '../services/language_service.dart';
import '../controllers/game_controller.dart';
import '../models/game_result.dart';
import '../models/chess_time_preset.dart';
import '../l10n/app_localizations.dart';

class BackupData {
  final String backupVersion;
  final String appVersion;
  final DateTime createdAt;
  final String deviceInfo;
  final Map<String, dynamic> userPreferences;
  final List<GameResult> gameStatistics;
  final List<ChessTimePreset> customPresets;
  final String currentPreset;
  final Map<String, dynamic> purchaseStatus;
  final Map<String, dynamic> languageSettings;

  BackupData({
    required this.backupVersion,
    required this.appVersion,
    required this.createdAt,
    required this.deviceInfo,
    required this.userPreferences,
    required this.gameStatistics,
    required this.customPresets,
    required this.currentPreset,
    required this.purchaseStatus,
    required this.languageSettings,
  });

  Map<String, dynamic> toJson() {
    return {
      'backupVersion': backupVersion,
      'appVersion': appVersion,
      'createdAt': createdAt.toIso8601String(),
      'deviceInfo': deviceInfo,
      'userPreferences': userPreferences,
      'gameStatistics': gameStatistics.map((result) => result.toJson()).toList(),
      'customPresets': customPresets.map((preset) => preset.toJson()).toList(),
      'currentPreset': currentPreset,
      'purchaseStatus': purchaseStatus,
      'languageSettings': languageSettings,
    };
  }

  factory BackupData.fromJson(Map<String, dynamic> json) {
    return BackupData(
      backupVersion: json['backupVersion'] ?? '1.0',
      appVersion: json['appVersion'] ?? '1.0.0',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      deviceInfo: json['deviceInfo'] ?? 'Unknown',
      userPreferences: json['userPreferences'] ?? {},
      gameStatistics: (json['gameStatistics'] as List<dynamic>?)
          ?.map((item) => GameResult.fromJson(item))
          .toList() ?? [],
      customPresets: (json['customPresets'] as List<dynamic>?)
          ?.map((item) => ChessTimePreset.fromJson(item))
          .toList() ?? [],
      currentPreset: json['currentPreset'] ?? 'tournament',
      purchaseStatus: json['purchaseStatus'] ?? {'isProVersion': false},
      languageSettings: json['languageSettings'] ?? {'selectedLanguage': 'en'},
    );
  }
}

class BackupService {
  static const String _backupFileName = 'chess_time_backup.json';
  static const String _backupVersion = '1.0';

  static Future<String?> createBackup({
    required ChessPresetService presetService,
    required PurchaseService purchaseService,
    required LanguageService languageService,
  }) async {
    try {
      // Get app information
      final packageInfo = await PackageInfo.fromPlatform();

      final userPreferences = await _collectUserPreferences();
      final gameStatistics = await StatisticsService.getAllResults();
      final customPresets = await _collectCustomPresets(presetService);
      final currentPreset = await _collectCurrentPreset(presetService);
      final purchaseStatus = await _collectPurchaseStatus(purchaseService);
      final languageSettings = await _collectLanguageSettings(languageService);

      final backupData = BackupData(
        backupVersion: _backupVersion,
        appVersion: packageInfo.version,
        createdAt: DateTime.now(),
        deviceInfo: Platform.isAndroid ? 'Android' : Platform.isIOS ? 'iOS' : 'Unknown',
        userPreferences: userPreferences,
        gameStatistics: gameStatistics,
        customPresets: customPresets,
        currentPreset: currentPreset,
        purchaseStatus: purchaseStatus,
        languageSettings: languageSettings,
      );

      // Convert to JSON
      final jsonString = jsonEncode(backupData.toJson());

      // Save temporary file
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$_backupFileName';
      final file = File(filePath);
      await file.writeAsString(jsonString);

      return filePath;
    } catch (e) {
      debugPrint('Erro ao criar backup: $e');
      return null;
    }
  }

  static Future<bool> shareBackup({
    required ChessPresetService presetService,
    required PurchaseService purchaseService,
    required LanguageService languageService,
    required AppLocalizations l10n,
  }) async {
    final filePath = await createBackup(
      presetService: presetService,
      purchaseService: purchaseService,
      languageService: languageService,
    );
    if (filePath == null) return false;

    try {
      await Share.shareXFiles(
        [XFile(filePath)],
        text: l10n.backupShareTitle,
        subject: l10n.backupShareSubject,
      );
      return true;
    } catch (e) {
      debugPrint('Erro ao compartilhar backup: $e');
      return false;
    }
  }

  static Future<BackupRestoreResult> restoreBackup({
    required ChessPresetService presetService,
    required PurchaseService purchaseService,
    required LanguageService languageService,
    required GameController gameController,
    required AppLocalizations l10n,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return BackupRestoreResult(
          success: false,
          message: l10n.backupNoFileSelected,
        );
      }

      final filePath = result.files.first.path;
      if (filePath == null) {
        return BackupRestoreResult(
          success: false,
          message: l10n.backupInvalidFile,
        );
      }

      final file = File(filePath);
      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString);

      final validationResult = _validateBackupData(jsonData, l10n);
      if (!validationResult.isValid) {
        return BackupRestoreResult(
          success: false,
          message: validationResult.errorMessage ?? l10n.backupValidationError,
        );
      }

      final backupData = BackupData.fromJson(jsonData);

      await _restoreUserPreferences(backupData.userPreferences);
      await _restoreGameStatistics(backupData.gameStatistics);
      await _restoreCustomPresets(backupData.customPresets, backupData.currentPreset, presetService);
      await _restorePurchaseStatus(backupData.purchaseStatus, purchaseService);
      await _restoreLanguageSettings(backupData.languageSettings, languageService);

      // Reload settings in GameController to update the UI
      gameController.reloadSettings();

      return BackupRestoreResult(
        success: true,
        message: l10n.backupRestoreSuccess,
        restoredItems: {
          'preferências': backupData.userPreferences.isNotEmpty,
          'estatísticas': backupData.gameStatistics.isNotEmpty,
          'presets': backupData.customPresets.isNotEmpty,
          'compras': backupData.purchaseStatus['isProVersion'] == true,
          'idioma': backupData.languageSettings.isNotEmpty,
        },
      );

    } catch (e) {
      debugPrint('Erro ao restaurar backup: $e');
      return BackupRestoreResult(
        success: false,
        message: l10n.backupRestoreErrorWithMessage(e.toString()),
      );
    }
  }

  // Helper methods to collect data
  static Future<Map<String, dynamic>> _collectUserPreferences() async {
    return {
      'initialTimeMinutes': PreferencesService.getInitialTimeMinutes(),
      'incrementSeconds': PreferencesService.getIncrementSeconds(),
      'timePreset': PreferencesService.getTimePreset(),
      'incrementPreset': PreferencesService.getIncrementPreset(),
      'isPlayer1White': PreferencesService.getIsPlayer1White(),
      'isSoundEnabled': PreferencesService.getIsSoundEnabled(),
      'isVibrateEnabled': PreferencesService.getIsVibrateEnabled(),
      'isDarkMode': PreferencesService.getIsDarkMode(),
      'fontSize': PreferencesService.getFontSize(),
      'themeIndex': PreferencesService.getThemeIndex(),
      'isImmersiveMode': PreferencesService.getIsImmersiveMode(),
    };
  }

  static Future<List<ChessTimePreset>> _collectCustomPresets(ChessPresetService presetService) async {
    return presetService.getCustomPresets();
  }

  static Future<String> _collectCurrentPreset(ChessPresetService presetService) async {
    return presetService.getCurrentPresetId();
  }

  static Future<Map<String, dynamic>> _collectPurchaseStatus(PurchaseService purchaseService) async {
    return purchaseService.getBackupData();
  }

  static Future<Map<String, dynamic>> _collectLanguageSettings(LanguageService languageService) async {
    return languageService.getBackupData();
  }

  // Helper methods to restore data
  static Future<void> _restoreUserPreferences(Map<String, dynamic> preferences) async {
    if (preferences.containsKey('initialTimeMinutes')) {
      await PreferencesService.setInitialTimeMinutes(preferences['initialTimeMinutes']);
    }
    if (preferences.containsKey('incrementSeconds')) {
      await PreferencesService.setIncrementSeconds(preferences['incrementSeconds']);
    }
    if (preferences.containsKey('timePreset')) {
      await PreferencesService.setTimePreset(preferences['timePreset']);
    }
    if (preferences.containsKey('incrementPreset')) {
      await PreferencesService.setIncrementPreset(preferences['incrementPreset']);
    }
    if (preferences.containsKey('isPlayer1White')) {
      await PreferencesService.setIsPlayer1White(preferences['isPlayer1White']);
    }
    if (preferences.containsKey('isSoundEnabled')) {
      await PreferencesService.setIsSoundEnabled(preferences['isSoundEnabled']);
    }
    if (preferences.containsKey('isVibrateEnabled')) {
      await PreferencesService.setIsVibrateEnabled(preferences['isVibrateEnabled']);
    }
    if (preferences.containsKey('isDarkMode')) {
      await PreferencesService.setIsDarkMode(preferences['isDarkMode']);
    }
    if (preferences.containsKey('fontSize')) {
      await PreferencesService.setFontSize(preferences['fontSize']);
    }
    if (preferences.containsKey('themeIndex')) {
      await PreferencesService.setThemeIndex(preferences['themeIndex']);
    }
    if (preferences.containsKey('isImmersiveMode')) {
      await PreferencesService.setIsImmersiveMode(preferences['isImmersiveMode']);
    }
  }

  static Future<void> _restoreGameStatistics(List<GameResult> statistics) async {
    // Clear current statistics
    await StatisticsService.clearAllStatistics();

    // Save new statistics
    for (final result in statistics) {
      await StatisticsService.saveGameResult(result);
    }
  }

  static Future<void> _restoreCustomPresets(List<ChessTimePreset> presets, String currentPreset, ChessPresetService presetService) async {
    await presetService.restoreFromBackup({
      'customPresets': presets.map((p) => p.toJson()).toList(),
      'currentPreset': currentPreset,
    });
  }

  static Future<void> _restorePurchaseStatus(Map<String, dynamic> purchaseStatus, PurchaseService purchaseService) async {
    await purchaseService.restoreFromBackup(purchaseStatus);
  }

  static Future<void> _restoreLanguageSettings(Map<String, dynamic> languageSettings, LanguageService languageService) async {
    await languageService.restoreFromBackup(languageSettings);
  }

  // Backup validation
  static BackupValidationResult _validateBackupData(Map<String, dynamic> jsonData, AppLocalizations l10n) {
    // Check backup version
    final backupVersion = jsonData['backupVersion'];
    if (backupVersion == null) {
      return BackupValidationResult(
        isValid: false,
        errorMessage: l10n.backupVersionNotFound,
      );
    }

    if (backupVersion != _backupVersion) {
      return BackupValidationResult(
        isValid: false,
        errorMessage: l10n.backupVersionIncompatibleWithDetails(_backupVersion, backupVersion.toString()),
      );
    }

    // Check required fields
    final requiredFields = ['userPreferences', 'gameStatistics', 'customPresets', 'purchaseStatus', 'languageSettings'];
    for (final field in requiredFields) {
      if (!jsonData.containsKey(field)) {
        return BackupValidationResult(
          isValid: false,
          errorMessage: l10n.backupRequiredFieldMissing(field),
        );
      }
    }

    return BackupValidationResult(isValid: true);
  }
}

class BackupValidationResult {
  final bool isValid;
  final String? errorMessage;

  BackupValidationResult({
    required this.isValid,
    this.errorMessage,
  });
}

class BackupRestoreResult {
  final bool success;
  final String message;
  final Map<String, bool>? restoredItems;

  BackupRestoreResult({
    required this.success,
    required this.message,
    this.restoredItems,
  });
}