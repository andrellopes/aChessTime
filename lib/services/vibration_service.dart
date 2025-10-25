import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class VibrationService {
  static final VibrationService _instance = VibrationService._internal();
  factory VibrationService() => _instance;
  VibrationService._internal();

  /// Light vibration (ideal for touch feedback)
  Future<void> lightVibration() async {
    try {
      await HapticFeedback.lightImpact();
      debugPrint('VibrationService: Vibração leve executada');
    } catch (e) {
      debugPrint('VibrationService: Erro na vibração leve - $e');
    }
  }

  /// Medium vibration (ideal for important actions)
  Future<void> mediumVibration() async {
    try {
      await HapticFeedback.mediumImpact();
      debugPrint('VibrationService: Vibração média executada');
    } catch (e) {
      debugPrint('VibrationService: Erro na vibração média - $e');
    }
  }

  /// Heavy vibration (ideal for alerts)
  Future<void> heavyVibration() async {
    try {
      await HapticFeedback.heavyImpact();
      debugPrint('VibrationService: Vibração forte executada');
    } catch (e) {
      debugPrint('VibrationService: Erro na vibração forte - $e');
    }
  }

  /// Selection vibration (ideal for state change)
  Future<void> selectionVibration() async {
    try {
      await HapticFeedback.selectionClick();
      debugPrint('VibrationService: Vibração de seleção executada');
    } catch (e) {
      debugPrint('VibrationService: Erro na vibração de seleção - $e');
    }
  }
}
