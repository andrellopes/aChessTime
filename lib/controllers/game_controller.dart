import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../models/game_settings.dart';
import '../models/game_result.dart';
import '../services/preferences_service.dart';
import '../services/sound_service.dart';
import '../services/vibration_service.dart';
import '../services/wakelock_service.dart';
import '../services/chess_theme_manager.dart';
import '../services/statistics_service.dart';

enum Player { player1, player2 }
enum GameState { initial, running, paused, finished }

class GameController extends ChangeNotifier {
  void updateFontSize(double value) {
    _settings = _settings.copyWith(fontSize: value);
    PreferencesService.setFontSize(value);
    notifyListeners();
  }

  void updateTheme(int themeIndex) {
    _settings = _settings.copyWith(themeIndex: themeIndex);
    PreferencesService.setThemeIndex(themeIndex);
    
    ChessThemeManager().setTheme(themeIndex);
    
    notifyListeners();
  }
  GameSettings _settings;

  late Duration _player1Time;
  late Duration _player2Time;
  Player? _activePlayer;
  GameState _gameState = GameState.initial;
  Timer? _timer;
  int _whiteMoves = 0;
  int _blackMoves = 0;
  DateTime? _gameStartTime;
  String? _lastResultType;

  Duration get player1Time => _player1Time;
  Duration get player2Time => _player2Time;
  GameState get gameState => _gameState;
  Player? get activePlayer => _activePlayer;
  GameSettings get settings => _settings;
  int get whiteMoves => _whiteMoves;
  int get blackMoves => _blackMoves;
  String? get lastResultType => _lastResultType;

  GameController({required GameSettings settings}) : _settings = settings {
    resetGame();
  }

  GameController.fromPreferences() : _settings = GameSettings.fromPreferences() {
    resetGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WakelockService().disable();
    super.dispose();
  }

  void _tick(Timer timer) {
    if (_gameState != GameState.running) return;

    if (_activePlayer == Player.player1) {
      if (_player1Time.inMilliseconds > 0) {
        _player1Time -= const Duration(milliseconds: 100);
      } else {
        _gameState = GameState.finished;
        _timer?.cancel();
        WakelockService().disable();
        if (_settings.isSoundEnabled) {
          SoundService().playVictory();
        }
        _lastResultType = 'timeout_white';
        _saveGameResult(Player.player2, 'timeout_white');
      }
    } else {
      if (_player2Time.inMilliseconds > 0) {
        _player2Time -= const Duration(milliseconds: 100);
      } else {
        _gameState = GameState.finished;
        _timer?.cancel();
        WakelockService().disable();
        if (_settings.isSoundEnabled) {
          SoundService().playVictory();
        }
        _lastResultType = 'timeout_black';
        _saveGameResult(Player.player1, 'timeout_black');
      }
    }
    notifyListeners();
  }

  void startPauseGame() {
    if (gameState == GameState.finished) return;

    if (_gameState == GameState.running) {
      pauseGame();
    } else {
      startGame();
    }
  }

  void pauseGame() {
    if (_gameState == GameState.running) {
      _gameState = GameState.paused;
      _timer?.cancel();
      WakelockService().disable();
      notifyListeners();
    }
  }

  void startGame() {
    if (_gameState != GameState.finished) {
      _gameState = GameState.running;
      _activePlayer ??= Player.player1;
      _gameStartTime ??= DateTime.now();
      _timer = Timer.periodic(const Duration(milliseconds: 100), _tick);
      WakelockService().enable();
    }
    notifyListeners();
  }

  void switchPlayer(Player tappedPlayer) {
    if (_gameState != GameState.running || _activePlayer != tappedPlayer) return;

    if (_settings.isSoundEnabled) {
      SoundService().playClick();
    }

    if (_settings.isVibrateEnabled) {
      VibrationService().lightVibration();
    }

    if (_activePlayer == Player.player1) {
      _player1Time += _settings.increment;
      _activePlayer = Player.player2;
      if (_settings.isPlayer1White) {
        _whiteMoves++;
      } else {
        _blackMoves++;
      }
    } else {
      _player2Time += _settings.increment;
      _activePlayer = Player.player1;
      if (_settings.isPlayer1White) {
        _blackMoves++;
      } else {
        _whiteMoves++;
      }
    }
    notifyListeners();
  }

  void resetGame() {
    _timer?.cancel();
    _player1Time = _settings.initialTime;
    _player2Time = _settings.initialTime;
    _activePlayer = null;
    _gameState = GameState.initial;
    _whiteMoves = 0;
    _blackMoves = 0;
    _gameStartTime = null;
    _lastResultType = null;
    WakelockService().disable();
    notifyListeners();
  }

  void updateTimePreset(String preset, Duration time) {
    _settings = _settings.copyWith(
      timePreset: preset,
      initialTime: time,
    );
    resetGame();
    PreferencesService.setTimePreset(preset);
    PreferencesService.setInitialTimeMinutes(time.inMinutes);
  }

  void updateIncrement(Duration increment, [String? preset]) {
    _settings = _settings.copyWith(
      increment: increment,
      incrementPreset: preset ?? _settings.incrementPreset,
    );
    notifyListeners();
    PreferencesService.setIncrementSeconds(increment.inSeconds);
    if (preset != null) {
      PreferencesService.setIncrementPreset(preset);
    }
  }

  void swapPlayers() {
    _settings = _settings.copyWith(isPlayer1White: !_settings.isPlayer1White);
    notifyListeners();
    PreferencesService.setIsPlayer1White(_settings.isPlayer1White);
  }

  void toggleSound() {
    _settings = _settings.copyWith(isSoundEnabled: !_settings.isSoundEnabled);
    notifyListeners();
    PreferencesService.setIsSoundEnabled(_settings.isSoundEnabled);
  }

  void toggleVibration() {
    _settings = _settings.copyWith(isVibrateEnabled: !_settings.isVibrateEnabled);
    notifyListeners();
    PreferencesService.setIsVibrateEnabled(_settings.isVibrateEnabled);
  }

  void toggleImmersiveMode() {
    _settings = _settings.copyWith(isImmersiveMode: !_settings.isImmersiveMode);
    notifyListeners();
    PreferencesService.setIsImmersiveMode(_settings.isImmersiveMode);
    
    _applyImmersiveMode(_settings.isImmersiveMode);
  }

  void _applyImmersiveMode(bool enabled) {
    if (enabled) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    }
  }

  void toggleDarkMode() {
    _settings = _settings.copyWith(isDarkMode: !_settings.isDarkMode);
    notifyListeners();
    PreferencesService.setIsDarkMode(_settings.isDarkMode);
  }

  void updateSettings(GameSettings newSettings) {
    _settings = newSettings;
    resetGame();
    PreferencesService.setInitialTimeMinutes(_settings.initialTime.inMinutes);
    PreferencesService.setIncrementSeconds(_settings.increment.inSeconds);
    PreferencesService.setTimePreset(_settings.timePreset);
    PreferencesService.setIncrementPreset(_settings.incrementPreset);
    PreferencesService.setIsPlayer1White(_settings.isPlayer1White);
    PreferencesService.setIsSoundEnabled(_settings.isSoundEnabled);
    PreferencesService.setIsVibrateEnabled(_settings.isVibrateEnabled);
    PreferencesService.setIsDarkMode(_settings.isDarkMode);
  }

  void reloadSettings() {
    _settings = GameSettings.fromPreferences();
    _applyImmersiveMode(_settings.isImmersiveMode);
    ChessThemeManager().setTheme(_settings.themeIndex);
    notifyListeners();
  }

  String getPlayerLabel(Player player, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (player == Player.player1) {
      return _settings.isPlayer1White ? l10n.whitePlayer : l10n.blackPlayer;
    } else {
      return _settings.isPlayer1White ? l10n.blackPlayer : l10n.whitePlayer;
    }
  }

  Color getPlayerColor(Player player) {
    if (player == Player.player1) {
      return _settings.isPlayer1White ? const Color(0xFFF5F5DC) : const Color(0xFF2C2C2C);
    } else {
      return _settings.isPlayer1White ? const Color(0xFF2C2C2C) : const Color(0xFFF5F5DC);
    }
  }

  int getPlayerMoves(Player player) {
    if (player == Player.player1) {
      return _settings.isPlayer1White ? _whiteMoves : _blackMoves;
    } else {
      return _settings.isPlayer1White ? _blackMoves : _whiteMoves;
    }
  }

  String getWinnerName(BuildContext context) {
    if (_gameState != GameState.finished) return '';
    if (_player1Time.inMilliseconds <= 0) {
      return getPlayerLabel(Player.player2, context);
    } else if (_player2Time.inMilliseconds <= 0) {
      return getPlayerLabel(Player.player1, context);
    }
    return '';
  }

  void endGameManually(Player winner, String resultType) {
    if (_gameState == GameState.finished) return;
    
    _gameState = GameState.finished;
    _timer?.cancel();
    WakelockService().disable();
    
    if (_settings.isSoundEnabled) {
      SoundService().playVictory();
    }
    
    if (_settings.isVibrateEnabled) {
      VibrationService().heavyVibration();
    }
    
    _lastResultType = resultType;
    _saveGameResult(winner, resultType);
    
    notifyListeners();
  }

  void endGameDraw() {
    if (_gameState == GameState.finished) return;
    
    _gameState = GameState.finished;
    _timer?.cancel();
    WakelockService().disable();
    
    if (_settings.isSoundEnabled) {
      SoundService().playClick();
    }
    
    _lastResultType = 'draw';
    _saveGameResult(null, 'draw');
    
    notifyListeners();
  }

  void _saveGameResult(Player? winner, String resultType) async {
    if (_gameStartTime == null) return;
    
    final gameDuration = DateTime.now().difference(_gameStartTime!);
    
    String? winnerColor;
    if (winner != null) {
      if (winner == Player.player1) {
        winnerColor = _settings.isPlayer1White ? 'white' : 'black';
      } else {
        winnerColor = _settings.isPlayer1White ? 'black' : 'white';
      }
    }
    
    final result = GameResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      dateTime: DateTime.now(),
      resultType: resultType,
      winner: winnerColor,
      gameDuration: gameDuration,
      whiteTimeRemaining: _settings.isPlayer1White ? _player1Time : _player2Time,
      blackTimeRemaining: _settings.isPlayer1White ? _player2Time : _player1Time,
      whiteMoves: _whiteMoves,
      blackMoves: _blackMoves,
      initialTime: _settings.initialTime,
      increment: _settings.increment,
    );
    
    try {
      await StatisticsService.saveGameResult(result);
      debugPrint('Game result saved: Winner=$winnerColor, Type=$resultType');
    } catch (e) {
      debugPrint('Error saving game result: $e');
    }
  }
}