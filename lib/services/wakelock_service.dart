import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter/foundation.dart';

class WakelockService {
  static final WakelockService _instance = WakelockService._internal();
  factory WakelockService() => _instance;
  WakelockService._internal();

  bool _isEnabled = false;

  /// Enables wakelock to keep screen always on
  Future<void> enable() async {
    if (_isEnabled) return;
    
    try {
      await WakelockPlus.enable();
      _isEnabled = true;
      debugPrint('WakelockService: Tela sempre ligada ativada');
    } catch (e) {
      debugPrint('WakelockService: Erro ao ativar wakelock - $e');
    }
  }

  /// Disables wakelock allowing screen to turn off normally
  Future<void> disable() async {
    if (!_isEnabled) return;
    
    try {
      await WakelockPlus.disable();
      _isEnabled = false;
      debugPrint('WakelockService: Tela sempre ligada desativada');
    } catch (e) {
      debugPrint('WakelockService: Erro ao desativar wakelock - $e');
    }
  }

  /// Checks if wakelock is active
  Future<bool> get isEnabled async {
    try {
      return await WakelockPlus.enabled;
    } catch (e) {
      debugPrint('WakelockService: Erro ao verificar status - $e');
      return false;
    }
  }

  /// Toggles wakelock state
  Future<void> toggle() async {
    final enabled = await isEnabled;
    if (enabled) {
      await disable();
    } else {
      await enable();
    }
  }
}
