import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

import 'app.dart';
import 'controllers/game_controller.dart';
import 'services/preferences_service.dart';
import 'services/sound_service.dart';
import 'services/chess_theme_manager.dart';
import 'services/purchase_service.dart';
import 'services/language_service.dart';
import 'services/chess_preset_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  await PreferencesService.init();
  
  await ChessThemeManager().init();
  
  await SoundService().init();
  
  final chessPresetService = ChessPresetService();
  await chessPresetService.init();
  
  final purchaseService = PurchaseService();
  final chessThemeManager = ChessThemeManager();
  chessThemeManager.setPurchaseService(purchaseService);
  
  if (Platform.isAndroid || Platform.isIOS) {
    await MobileAds.instance.initialize();
  }
  
  if (PreferencesService.getIsImmersiveMode()) {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GameController>(
          create: (context) => GameController.fromPreferences(),
        ),
        ChangeNotifierProvider.value(value: chessThemeManager),
        ChangeNotifierProvider.value(value: purchaseService),
        ChangeNotifierProvider<LanguageService>(
          create: (context) => LanguageService(),
        ),
        ChangeNotifierProvider<ChessPresetService>(
          create: (context) => chessPresetService,
        ),
      ],
      child: const AChessTimeApp(),
    ),
  );
}
