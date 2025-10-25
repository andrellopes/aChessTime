import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/game_screen.dart';
import 'screens/settings_screen.dart';
import 'controllers/game_controller.dart';
import 'services/chess_theme_manager.dart';
import 'services/language_service.dart';
import 'l10n/app_localizations.dart';

class AChessTimeApp extends StatelessWidget {
  const AChessTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<GameController, ChessThemeManager, LanguageService>(
      builder: (context, game, themeManager, languageService, child) {
        return MaterialApp(
          title: 'ChessTime',
          locale: languageService.currentLocale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: themeManager.getThemeData(),
          darkTheme: themeManager.getThemeData(),
          themeMode: ThemeMode.dark,
          initialRoute: '/',
          routes: {
            '/': (context) => const GameScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}