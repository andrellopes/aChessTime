import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../widgets/center_controls.dart';
import '../widgets/player_timer_widget.dart';
import '../widgets/game_end_dialog.dart';
import '../utils/time_utils.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _victoryDialogShown = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (context, game, child) {
        if (game.gameState == GameState.finished && !_victoryDialogShown) {
          _victoryDialogShown = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showGameEndDialog(context, game);
          });
        }
        
        // Reset of the flag when a new game starts
        if (game.gameState != GameState.finished && _victoryDialogShown) {
          _victoryDialogShown = false;
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: game.settings.isImmersiveMode 
            ? Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: PlayerTimerWidget(
                      timeText: TimeUtils.formatDuration(game.player2Time),
                      player: Player.player2,
                      isActive: game.activePlayer == Player.player2 && 
                               game.gameState == GameState.running,
                      isRotated: true,
                      onTap: () => game.switchPlayer(Player.player2),
                      gameController: game,
                    ),
                  ),
                  
                  const CenterControls(),
                  
                  Expanded(
                    flex: 4,
                    child: PlayerTimerWidget(
                      timeText: TimeUtils.formatDuration(game.player1Time),
                      player: Player.player1,
                      isActive: game.activePlayer == Player.player1 && 
                               game.gameState == GameState.running,
                      isRotated: false,
                      onTap: () => game.switchPlayer(Player.player1),
                      gameController: game,
                    ),
                  ),
                ],
              )
            : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: PlayerTimerWidget(
                        timeText: TimeUtils.formatDuration(game.player2Time),
                        player: Player.player2,
                        isActive: game.activePlayer == Player.player2 && 
                                 game.gameState == GameState.running,
                        isRotated: true,
                        onTap: () => game.switchPlayer(Player.player2),
                        gameController: game,
                      ),
                    ),
                    
                    const CenterControls(),
                    
                    Expanded(
                      flex: 4,
                      child: PlayerTimerWidget(
                        timeText: TimeUtils.formatDuration(game.player1Time),
                        player: Player.player1,
                        isActive: game.activePlayer == Player.player1 && 
                                 game.gameState == GameState.running,
                        isRotated: false,
                        onTap: () => game.switchPlayer(Player.player1),
                        gameController: game,
                      ),
                    ),
                  ],
                ),
              ),
        );
      },
    );
  }

  void _showGameEndDialog(BuildContext context, GameController game) {
    String? winnerName;
    
    // Only fetch winner's name if it's not a draw
    if (game.lastResultType != 'draw') {
      winnerName = game.getWinnerName(context);
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameEndDialog(
        resultType: game.lastResultType,
        winnerName: winnerName,
        onNewGame: () {
          Navigator.of(context).pop();
          game.resetGame();
        },
      ),
    );
  }
}