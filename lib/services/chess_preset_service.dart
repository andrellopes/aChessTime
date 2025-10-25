import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chess_time_preset.dart';

class ChessPresetService extends ChangeNotifier {
  static const String _currentPresetKey = 'chess_current_preset';
  static const String _customPresetsKey = 'custom_chess_presets_v2';
  
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Gets the current preset
  String getCurrentPresetId() {
    if (_prefs == null) return 'tournament';
    return _prefs?.getString(_currentPresetKey) ?? 'tournament';
  }

  Future<void> setCurrentPreset(String presetId) async {
    await init();
    await _prefs!.setString(_currentPresetKey, presetId);
    notifyListeners();
  }

  // Gets all custom presets
  List<ChessTimePreset> getCustomPresets() {
    if (_prefs == null) return [];
    
    final customPresetsJson = _prefs?.getString(_customPresetsKey);
    if (customPresetsJson == null) return [];
    
    try {
      final List<dynamic> presetsList = jsonDecode(customPresetsJson);
      return presetsList.map((json) => ChessTimePreset.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveCustomPreset(ChessTimePreset preset) async {
    await init();
    final customPresets = getCustomPresets();
    
    // Remove preset existente com mesmo ID se houver
    customPresets.removeWhere((p) => p.id == preset.id);
    
    // Adiciona o novo preset
    customPresets.add(preset);
    
    // Salva no storage
    final jsonString = jsonEncode(customPresets.map((p) => p.toJson()).toList());
    await _prefs!.setString(_customPresetsKey, jsonString);
    notifyListeners();
  }

  Future<void> removeCustomPreset(String presetId) async {
    await init();
    final customPresets = getCustomPresets();
    customPresets.removeWhere((p) => p.id == presetId);
    
    // If the removed preset was active, revert to default
    if (getCurrentPresetId() == presetId) {
      await setCurrentPreset('tournament');
    }
    
    final jsonString = jsonEncode(customPresets.map((p) => p.toJson()).toList());
    await _prefs!.setString(_customPresetsKey, jsonString);
    notifyListeners();
  }

  // Gets all presets (default + custom)
  List<ChessTimePreset> getAllPresets() {
    final presets = <ChessTimePreset>[];
    presets.addAll(defaultChessPresets);
    presets.addAll(getCustomPresets());
    return presets;
  }

  // Gets the current preset as an object
  ChessTimePreset getCurrentPresetAsObject() {
    final currentId = getCurrentPresetId();
    final allPresets = getAllPresets();
    
    return allPresets.firstWhere(
      (preset) => preset.id == currentId,
      orElse: () => defaultChessPresets.first,
    );
  }

  // Applies a preset (returns the settings)
  Map<String, Duration> applyPreset(ChessTimePreset preset) {
    return {
      'initialTime': preset.initialTime,
      'increment': preset.increment,
    };
  }

  // Checks if a preset is active
  bool isPresetActive(String presetId) {
    return getCurrentPresetId() == presetId;
  }

  // METHODS FOR BACKUP AND RESTORATION

  // Gets data for backup
  Map<String, dynamic> getBackupData() {
    return {
      'customPresets': getCustomPresets().map((p) => p.toJson()).toList(),
      'currentPreset': getCurrentPresetId(),
    };
  }

  // Restores data from backup
  Future<void> restoreFromBackup(Map<String, dynamic> backupData) async {
    await init();

    await _prefs!.remove(_customPresetsKey);
    await _prefs!.remove(_currentPresetKey);

    if (backupData.containsKey('customPresets')) {
      final customPresetsJson = jsonEncode(backupData['customPresets']);
      await _prefs!.setString(_customPresetsKey, customPresetsJson);
    }

    if (backupData.containsKey('currentPreset')) {
      await setCurrentPreset(backupData['currentPreset']);
    }

    notifyListeners();
  }
}
