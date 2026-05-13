import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../widgets/chess_preset_selector.dart';
import '../services/chess_theme_manager.dart';
import '../services/purchase_service.dart';
import '../l10n/app_localizations.dart';
import 'banner_ad_widget.dart';

class CenterControls extends StatelessWidget {
  const CenterControls({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Consumer<GameController>(
      builder: (context, game, child) {
        if (!isLandscape) {
          // Portrait: layout original, sem mudanças
          return Container(
            height: 95,
            decoration: BoxDecoration(
              color: Colors.grey[900]!.withOpacity(0.95),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.grey[700]!.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMainControls(context, game, false, null),
                if (game.gameState == GameState.finished)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _buildGameInfo(context, game),
                  ),
              ],
            ),
          );
        }

        // Landscape: pill responsivo à altura disponível
        final mq = MediaQuery.of(context);
        // Altura disponível descontando safe area e margens verticais da pill (6 * 2 = 12)
        final availableHeight = mq.size.height - mq.padding.top - mq.padding.bottom - 12;

        // Tamanhos dinâmicos: calculamos um fator de escala baseado na altura
        // Referência: 5 botões (52+74+52+52+52) + 4 gaps (12*4) + padding vertical (8*2) = 394
        const double referenceHeight = 394.0;
        final double scale = (availableHeight / referenceHeight).clamp(0.6, 1.0);

        final double btnSize    = (52.0 * scale).floorToDouble();
        final double playSize   = (74.0 * scale).floorToDouble();
        final double gapSize    = (12.0 * scale).floorToDouble();
        final double vPadding   = (8.0  * scale).floorToDouble();
        final double pillWidth  = (87.0 * scale).clamp(72.0, 95.0);

        return Container(
          width: pillWidth,
          decoration: BoxDecoration(
            color: Colors.grey[900]!.withOpacity(0.95),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Colors.grey[700]!.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: EdgeInsets.symmetric(vertical: vPadding, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMainControls(context, game, true, _PillSizes(
                btnSize: btnSize,
                playSize: playSize,
                gapSize: gapSize,
              )),
              if (game.gameState == GameState.finished)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: _buildGameInfo(context, game),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainControls(
    BuildContext context,
    GameController game,
    bool isLandscape,
    _PillSizes? sizes,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (!isLandscape) {
      // Portrait: tamanhos fixos originais em Row
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPresetsButton(context, game),
          const SizedBox(width: 0),
          _buildControlButton(icon: Icons.gavel, onPressed: () => _showArbiterMenu(context, game), tooltip: 'Árbitro', color: Colors.cyan),
          const SizedBox(width: 0),
          _buildPlayButton(context, game, 74, 36),
          const SizedBox(width: 0),
          _buildControlButton(icon: Icons.swap_vert, onPressed: () => game.swapPlayers(), tooltip: l10n.swapTooltip, color: Colors.blue),
          const SizedBox(width: 0),
          _buildControlButton(icon: Icons.settings, onPressed: () => Navigator.pushNamed(context, '/settings'), tooltip: l10n.settingsTooltip, color: Colors.grey[400]!),
        ],
      );
    }

    // Landscape: tamanhos escalonados
    final s = sizes!;
    final gap = SizedBox(height: s.gapSize);
    final iconScale = (s.btnSize / 52.0).clamp(0.6, 1.0);
    final playIconSize = (36.0 * iconScale).floorToDouble();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPresetsButton(context, game, size: s.btnSize),
        gap,
        _buildControlButton(
          icon: Icons.gavel,
          onPressed: () => _showArbiterMenu(context, game),
          tooltip: 'Árbitro',
          color: Colors.cyan,
          size: s.btnSize,
          iconSize: 20 * iconScale,
        ),
        gap,
        _buildPlayButton(context, game, s.playSize, playIconSize),
        gap,
        _buildControlButton(
          icon: Icons.swap_vert,
          onPressed: () => game.swapPlayers(),
          tooltip: l10n.swapTooltip,
          color: Colors.blue,
          size: s.btnSize,
          iconSize: 20 * iconScale,
        ),
        gap,
        _buildControlButton(
          icon: Icons.settings,
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          tooltip: l10n.settingsTooltip,
          color: Colors.grey[400]!,
          size: s.btnSize,
          iconSize: 20 * iconScale,
        ),
      ],
    );
  }

  /// Botão Play/Pause com tamanho configurável
  Widget _buildPlayButton(BuildContext context, GameController game, double size, double iconSize) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: game.gameState == GameState.running
              ? [
                  Colors.amber.withOpacity(0.4),
                  Colors.amber.withOpacity(0.2),
                  Colors.orange.withOpacity(0.3),
                ]
              : [
                  Colors.green.withOpacity(0.4),
                  Colors.green.withOpacity(0.2),
                  Colors.teal.withOpacity(0.3),
                ],
        ),
        border: Border.all(
          color: game.gameState == GameState.running ? Colors.amber : Colors.green,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (game.gameState == GameState.running ? Colors.amber : Colors.green).withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => _handlePlayPause(context, game),
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Icon(
              game.gameState == GameState.running ? Icons.stop_rounded : Icons.play_arrow_rounded,
              size: iconSize,
              color: game.gameState == GameState.running ? Colors.amber : Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameInfo(BuildContext context, GameController game) {
    final l10n = AppLocalizations.of(context)!;
    String statusText = '';
    Color statusColor = Colors.white70;
    
    switch (game.gameState) {
      case GameState.initial:
      case GameState.paused:
      case GameState.running:
        return const SizedBox.shrink();
      case GameState.finished:
        final winner = game.player1Time.inMilliseconds <= 0 ? l10n.player2 : l10n.player1;
        statusText = l10n.victoryMessage(winner);
        statusColor = Colors.red;
        break;
    }
    
    return Text(
      statusText,
      style: TextStyle(
        color: statusColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPresetsButton(BuildContext context, GameController game, {double size = 52}) {
    final textScale = (size / 52.0).clamp(0.7, 1.0);
    return GestureDetector(
      onTap: () => _showPresetSelector(context, game),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[700]!.withOpacity(0.8),
              Colors.grey[800]!.withOpacity(0.9),
            ],
          ),
          border: Border.all(color: Colors.grey[500]!.withOpacity(0.4), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${game.settings.initialTime.inMinutes}'",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11 * textScale,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "+${game.settings.increment.inSeconds}",
              style: TextStyle(
                color: Colors.cyanAccent,
                fontSize: 9 * textScale,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    required Color color,
    double size = 52,
    double iconSize = 20,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: iconSize),
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  void _showPresetSelector(BuildContext context, GameController game) {
    final l10n = AppLocalizations.of(context)!;
    
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight < 700 ? screenHeight * 0.6 : screenHeight * 0.4;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.timeControls,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ChessPresetSelector(
                  onPresetSelected: (preset) {
                    // Apply preset settings to GameController in a single call
                    game.updateTimePreset(
                      preset.isCustom ? 'custom' : preset.id, 
                      preset.initialTime,
                      time2: preset.player2InitialTime,
                      increment: preset.increment,
                      incrementPreset: preset.isCustom ? 'custom' : preset.id,
                      mode: preset.timeMode,
                      periods: preset.timePeriods,
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handlePlayPause(BuildContext context, GameController game) {
    if (game.gameState == GameState.running) {
      // Pause and show end menu
      game.pauseGame();
      _showPauseMenu(context, game);
    } else {
      // Start/resume game
      game.startPauseGame();
    }
  }

  double _bottomSheetExtraInset(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final extraInset = mediaQuery.viewPadding.bottom - mediaQuery.padding.bottom;
    return extraInset > 0 ? extraInset : 0;
  }

  void _showArbiterMenu(BuildContext context, GameController game) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final bottomInset = _bottomSheetExtraInset(context);
        final l10n = AppLocalizations.of(context)!;
        return Consumer<ChessThemeManager>(
          builder: (context, themeManager, child) {
            return StatefulBuilder(
              builder: (context, setState) {
                return SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40, height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: themeManager.accentColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.gavel, color: themeManager.accentColor, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.arbiterMode, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeManager.textPrimaryColor)),
                                Text(l10n.penaltyBonusTime, style: TextStyle(fontSize: 12, color: themeManager.textSecondaryColor)),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.close, color: themeManager.textSecondaryColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildArbiterColumn(context, game, Player.player1, setState, l10n, themeManager)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildArbiterColumn(context, game, Player.player2, setState, l10n, themeManager)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.tapPlayerButtonToApply,
                          style: TextStyle(fontSize: 11, color: themeManager.textSecondaryColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildArbiterColumn(BuildContext context, GameController game, Player player, StateSetter setState, AppLocalizations l10n, ChessThemeManager themeManager) {
    final isWhite = player == Player.player1 ? game.settings.isPlayer1White : !game.settings.isPlayer1White;
    final playerColor = isWhite ? themeManager.textPrimaryColor : themeManager.textSecondaryColor;
    final label = isWhite ? '\u2654  ${l10n.whitePlayer}' : '\u265a  ${l10n.blackPlayer}';
    final bgColor = themeManager.surfaceColor;
    final borderColor = playerColor.withOpacity(0.3);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: TextStyle(color: playerColor, fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: themeManager.criticalColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(l10n.penalty, style: TextStyle(color: themeManager.criticalColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.2), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 8),
          _arbiterChip(label: '\u2212 2 ${l10n.minutesShort}', delta: const Duration(minutes: -2), color: themeManager.criticalColor, game: game, player: player, setState: setState),
          const SizedBox(height: 6),
          _arbiterChip(label: '\u2212 1 ${l10n.minutesShort}', delta: const Duration(minutes: -1), color: themeManager.criticalColor, game: game, player: player, setState: setState),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: themeManager.activeTimerColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(l10n.bonus, style: TextStyle(color: themeManager.activeTimerColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.2), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 8),
          _arbiterChip(label: '+ 1 ${l10n.minutesShort}', delta: const Duration(minutes: 1), color: themeManager.activeTimerColor, game: game, player: player, setState: setState),
          const SizedBox(height: 6),
          _arbiterChip(label: '+ 2 ${l10n.minutesShort}', delta: const Duration(minutes: 2), color: themeManager.activeTimerColor, game: game, player: player, setState: setState),
          const SizedBox(height: 10),
          Divider(height: 1, color: themeManager.textSecondaryColor.withOpacity(0.2)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _arbiterSmallChip(label: '\u221230${l10n.secondsShort}', delta: const Duration(seconds: -30), color: themeManager.warningColor, game: game, player: player, setState: setState)),
              const SizedBox(width: 6),
              Expanded(child: _arbiterSmallChip(label: '+30${l10n.secondsShort}', delta: const Duration(seconds: 30), color: themeManager.accentColor, game: game, player: player, setState: setState)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _arbiterChip({required String label, required Duration delta, required Color color, required GameController game, required Player player, required StateSetter setState}) {
    return GestureDetector(
      onTap: () { game.adjustTime(player, delta); setState(() {}); },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.5), width: 1),
        ),
        child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center),
      ),
    );
  }

  Widget _arbiterSmallChip({required String label, required Duration delta, required Color color, required GameController game, required Player player, required StateSetter setState}) {
    return GestureDetector(
      onTap: () { game.adjustTime(player, delta); setState(() {}); },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.4), width: 1),
        ),
        child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12), textAlign: TextAlign.center),
      ),
    );
  }


  void _showPauseMenu(BuildContext context, GameController game) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final bottomInset = _bottomSheetExtraInset(context);
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.menu,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Consumer<ChessThemeManager>(
                    builder: (context, themeManager, child) {
                      final currentTheme = themeManager.currentTheme;
                      return Column(
                        children: [
                          _buildMenuOption(
                            icon: Icons.flag,
                            title: l10n.whiteVictory,
                            onTap: () {
                              Navigator.pop(context);
                              final winner = game.settings.isPlayer1White ? Player.player1 : Player.player2;
                              game.endGameManually(winner, 'manual_white');
                            },
                            color: currentTheme.whitePlayerColor,
                          ),
                          _buildMenuOption(
                            icon: Icons.flag,
                            title: l10n.blackVictory,
                            onTap: () {
                              Navigator.pop(context);
                              final winner = game.settings.isPlayer1White ? Player.player2 : Player.player1;
                              game.endGameManually(winner, 'manual_black');
                            },
                            color: currentTheme.blackPlayerColor,
                          ),
                          _buildMenuOption(
                            icon: Icons.handshake,
                            title: l10n.drawGame,
                            onTap: () {
                              Navigator.pop(context);
                              game.endGameDraw();
                            },
                            color: Colors.grey[600]!,
                          ),
                        ],
                      );
                    },
                  ),
                  const Divider(height: 12),
                  _buildMenuOption(
                    icon: Icons.swap_vert,
                    title: l10n.swapTooltip,
                    onTap: () {
                      Navigator.pop(context);
                      game.swapPlayers();
                    },
                    color: Colors.blue,
                  ),
                  _buildMenuOption(
                    icon: Icons.play_arrow,
                    title: l10n.continueGame,
                    onTap: () {
                      Navigator.pop(context);
                      game.startPauseGame();
                    },
                    color: Colors.green,
                  ),
                  _buildMenuOption(
                    icon: Icons.refresh,
                    title: l10n.resetTooltip,
                    onTap: () {
                      Navigator.pop(context);
                      game.resetGame();
                    },
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  _buildAdBanner(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // O método _handleReset e _showResetMenu foram removidos pois eram duplicatas exatas do Pause Menu.

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: subtitle != null ? Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 10),
        ) : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        dense: true,
      ),
    );
  }

  Widget _buildAdBanner() {
    return Consumer<PurchaseService>(
      builder: (context, purchaseService, _) {
        if (purchaseService.isProVersion) {
          return const SizedBox.shrink();
        }
        return const SizedBox(
          height: 70,
          child: BannerAdWidget(),
        );
      },
    );
  }
}

/// Dados de tamanho responsivo para a pill no modo landscape
class _PillSizes {
  final double btnSize;
  final double playSize;
  final double gapSize;

  const _PillSizes({
    required this.btnSize,
    required this.playSize,
    required this.gapSize,
  });
}
