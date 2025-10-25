import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:audio_session/audio_session.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  late AudioPlayer _clickPlayer;
  late AudioPlayer _victoryPlayer;
  bool _isInitialized = false;
  bool _clickLoaded = false;
  bool _victoryLoaded = false;

  /// Initializes the sound service
  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.ambient,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.sonification,
          usage: AndroidAudioUsage.assistanceSonification,
          flags: AndroidAudioFlags.none,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
        androidWillPauseWhenDucked: false,
      ));

      _clickPlayer = AudioPlayer();
      _victoryPlayer = AudioPlayer();
      await _clickPlayer.setLoopMode(LoopMode.off);
      await _victoryPlayer.setLoopMode(LoopMode.off);
      await _clickPlayer.setVolume(1.0);
      await _victoryPlayer.setVolume(1.0);
      
      // Tries to load click sound
      try {
        await _clickPlayer.setAsset('assets/sounds/click.mp3');
        _clickLoaded = true;
      } catch (e) {
        debugPrint('SoundService: Erro ao carregar click.mp3 - $e');
        _clickLoaded = false;
      }
      
      // Tries to load victory sound in MP3
      try {
        await _victoryPlayer.setAsset('assets/sounds/victory.mp3');
        _victoryLoaded = true;
      } catch (e) {
        debugPrint('SoundService: Erro ao carregar victory.mp3, usando click.mp3 - $e');
        try {
          await _victoryPlayer.setAsset('assets/sounds/click.mp3');
          _victoryLoaded = true;
        } catch (e2) {
          debugPrint('SoundService: Fallback para click em victoryPlayer falhou - $e2');
          _victoryLoaded = false;
        }
      }
      
      _isInitialized = true;
      debugPrint('SoundService: Inicializado com sucesso');
    } catch (e) {
      debugPrint('SoundService: Erro ao inicializar - $e');
      // Even with error, mark as initialized to avoid loops
      _isInitialized = true;
    }
  }

  /// Plays click sound if sound is enabled
  Future<void> playClick() async {
    if (!_isInitialized) {
      await init();
    }

    try {
      if (!_clickLoaded) {
        try {
          await _clickPlayer.setAsset('assets/sounds/click.mp3');
          _clickLoaded = true;
        } catch (loadErr) {
          debugPrint('SoundService: re-tentativa de carregar click.mp3 falhou - $loadErr');
          return;
        }
      }
      await _clickPlayer.seek(Duration.zero);
      await _clickPlayer.play();
    } catch (e) {
      debugPrint('SoundService: Erro ao tocar som de clique - $e');
    }
  }

  /// Plays victory sound
  Future<void> playVictory() async {
    if (!_isInitialized) {
      await init();
    }

    debugPrint('SoundService: playVictory chamado');
    try {
      debugPrint('SoundService: Tentando tocar victory');
      if (!_victoryLoaded) {
        try {
          await _victoryPlayer.setAsset('assets/sounds/victory.mp3');
          _victoryLoaded = true;
        } catch (e) {
          debugPrint('SoundService: re-tentativa de carregar victory.mp3 falhou - $e');
        }
      }
      await _victoryPlayer.seek(Duration.zero);
      await _victoryPlayer.play();
      debugPrint('SoundService: victory tocado com sucesso');
    } catch (e) {
      debugPrint('SoundService: Erro ao tocar som de vitória - $e');
      try {
        debugPrint('SoundService: Tentando fallback para click.mp3');
        await _clickPlayer.setVolume(1.0);
        await _clickPlayer.seek(Duration.zero);
        await _clickPlayer.play();
        debugPrint('SoundService: click.mp3 tocado como fallback');
      } catch (fallbackError) {
        debugPrint('SoundService: Erro no fallback para click - $fallbackError');
      }
    }
  }

  /// Releases resources
  Future<void> dispose() async {
    if (_isInitialized) {
      await _clickPlayer.dispose();
      await _victoryPlayer.dispose();
      _isInitialized = false;
      debugPrint('SoundService: Recursos liberados');
    }
  }
}
