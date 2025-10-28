import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../widgets/chess_preset_selector.dart';
import '../services/chess_theme_manager.dart';
import '../services/purchase_service.dart';
import '../l10n/app_localizations.dart';
import 'native_ad_widget.dart';

class CenterControls extends StatelessWidget {
  const CenterControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (context, game, child) {
        return Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey[900]!.withOpacity(0.95),
                Colors.grey[850]!.withOpacity(0.9),
                Colors.grey[900]!.withOpacity(0.98),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[600]!.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main row with controls - always centered
              _buildMainControls(context, game),
              
              // Bottom row with game information (only when finished)
              if (game.gameState == GameState.finished)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _buildGameInfo(context, game),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainControls(BuildContext context, GameController game) {
    final l10n = AppLocalizations.of(context)!;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Preset settings
        _buildPresetsButton(context, game),

        // Reset button with menu
        _buildControlButton(
          icon: Icons.refresh,
          onPressed: () => _handleReset(context, game),
          tooltip: l10n.resetTooltip,
          color: Colors.orange,
        ),

        // Play/Pause button (larger)
        Container(
          width: 70,
          height: 70,
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
              color: game.gameState == GameState.running 
                ? Colors.amber
                : Colors.green,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: (game.gameState == GameState.running 
                  ? Colors.amber 
                  : Colors.green).withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => _handlePlayPause(context, game),
            icon: Icon(
              game.gameState == GameState.running 
                ? Icons.pause 
                : Icons.play_arrow,
              size: 32,
              color: game.gameState == GameState.running 
                ? Colors.amber
                : Colors.green,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),

        // Invert colors button
        _buildControlButton(
          icon: Icons.swap_vert,
          onPressed: game.swapPlayers,
          tooltip: l10n.swapTooltip,
          color: Colors.blue,
        ),

        // Menu/Settings button
        _buildControlButton(
          icon: Icons.more_vert,
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          tooltip: l10n.settingsTooltip,
          color: Colors.purple,
        ),
      ],
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
        statusText = '$winner ${l10n.playerWon}';
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

  Widget _buildPresetsButton(BuildContext context, GameController game) {
    return GestureDetector(
      onTap: () => _showPresetSelector(context, game),
      child: Container(
        width: 45,
        height: 45,
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
              game.settings.timePreset == "custom" 
                ? "${game.settings.initialTime.inMinutes}'"
                : game.settings.timePreset.replaceAll('min', "'"),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "+${game.settings.increment.inSeconds}",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 8,
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
  }) {
    return Container(
      width: 60,
      height: 60,
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
        icon: Icon(icon, color: color, size: 20),
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
      builder: (context) => Container(
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
                  // Apply preset settings to GameController
                  game.updateTimePreset('custom', preset.initialTime);
                  game.updateIncrement(preset.increment, 'custom');
                  Navigator.pop(context);
                },
              ),
            ],
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

  void _handleReset(BuildContext context, GameController game) {
    if (game.gameState == GameState.running) {
      game.pauseGame();
    }
    _showResetMenu(context, game);
  }

  void _showPauseMenu(BuildContext context, GameController game) {
    final l10n = AppLocalizations.of(context)!;
    
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              l10n.menu,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // End options
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
            
            // AdMob Native Ad - Apenas para usuários não-pro
            Consumer<PurchaseService>(
              builder: (context, purchaseService, child) {
                if (purchaseService.isProVersion) {
                  return const SizedBox.shrink();
                }
                return SizedBox(
                  height: 80,
                  child: const NativeAdWidget(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showResetMenu(BuildContext context, GameController game) {
    final l10n = AppLocalizations.of(context)!;
    
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              l10n.menu,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // End options
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
            
            // AdMob Native Ad - Apenas para usuários não-pro
            Consumer<PurchaseService>(
              builder: (context, purchaseService, child) {
                if (purchaseService.isProVersion) {
                  return const SizedBox.shrink();
                }
                return SizedBox(
                  height: 80,
                  child: const NativeAdWidget(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

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
}
