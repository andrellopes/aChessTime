import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../utils/time_utils.dart';
import '../services/chess_theme_manager.dart';

class PlayerTimerWidget extends StatelessWidget {
  final String timeText;
  final Player player;
  final bool isActive;
  final bool isRotated;
  final VoidCallback onTap;
  final GameController gameController;

  const PlayerTimerWidget({
    super.key,
    required this.timeText,
    required this.player,
    required this.isActive,
    required this.isRotated,
    required this.onTap,
    required this.gameController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ChessThemeManager>(
      builder: (context, themeManager, child) {
        final playerColor = themeManager.getPlayerColor(player == Player.player1 
            ? gameController.settings.isPlayer1White 
            : !gameController.settings.isPlayer1White);
        final playerLabel = gameController.getPlayerLabel(player, context);
        final duration = player == Player.player1 
            ? gameController.player1Time 
            : gameController.player2Time;
        final isLowTime = TimeUtils.isLowTime(duration);
        final isVeryLowTime = TimeUtils.isVeryLowTime(duration);
        
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: _buildGradient(themeManager, playerColor, isActive, isLowTime),
              border: isActive ? Border.all(
                color: isLowTime ? themeManager.criticalColor : themeManager.activeTimerColor,
                width: 3,
              ) : null,
              boxShadow: isActive ? [
                BoxShadow(
                  color: (isLowTime ? themeManager.criticalColor : themeManager.activeTimerColor).withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ] : null,
            ),
            child: isRotated 
              ? RotatedBox(
                  quarterTurns: 2,
                  child: _buildTimerContent(context, themeManager, playerLabel, isLowTime, isVeryLowTime),
                )
              : _buildTimerContent(context, themeManager, playerLabel, isLowTime, isVeryLowTime),
          ),
        );
      },
    );
  }

  Widget _buildTimerContent(BuildContext context, ChessThemeManager themeManager, String playerLabel, bool isLowTime, bool isVeryLowTime) {
    final moveCount = gameController.getPlayerMoves(player);
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // Background with subtle chess pattern
          _buildChessPattern(themeManager),
          
          // Main content centered
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: gameController.settings.fontSize * 1.2,
                      fontWeight: FontWeight.w900,
                      color: themeManager.getTimerColor(isActive, isLowTime, isVeryLowTime),
                      fontFamily: 'monospace',
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.7),
                          offset: const Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Text(timeText),
                  ),
                ),
                
                const SizedBox(height: 8), // Reduced from 16 to 8 since timer has fixed height
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive ? (isLowTime ? themeManager.criticalColor : themeManager.activeTimerColor) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        playerLabel,
                        style: TextStyle(
                          color: themeManager.textPrimaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.touch_app,
                            color: themeManager.textSecondaryColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$moveCount',
                            style: TextStyle(
                              color: themeManager.textSecondaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Activity indicator - now always present but invisible when inactive
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 80,
                height: 3,
                decoration: BoxDecoration(
                  color: isActive ? (isLowTime ? themeManager.criticalColor : themeManager.activeTimerColor) : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: isActive ? [
                    BoxShadow(
                      color: (isLowTime ? themeManager.criticalColor : themeManager.activeTimerColor).withOpacity(0.8),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ] : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChessPattern(ChessThemeManager themeManager) {
    return Positioned.fill(
      child: CustomPaint(
        painter: ChessPatternPainter(
          lightColor: themeManager.textSecondaryColor.withOpacity(0.02),
          darkColor: themeManager.backgroundColor.withOpacity(0.02),
        ),
      ),
    );
  }

  LinearGradient _buildGradient(ChessThemeManager themeManager, Color baseColor, bool isActive, bool isLowTime) {
    if (isActive) {
      if (isLowTime) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeManager.criticalColor.withOpacity(0.8),
            themeManager.criticalColor.withOpacity(0.6),
            baseColor.withOpacity(0.3),
          ],
        );
      } else {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor.withOpacity(0.9),
            baseColor.withOpacity(0.7),
            themeManager.activeTimerColor.withOpacity(0.1),
          ],
        );
      }
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          baseColor.withOpacity(0.6),
          baseColor.withOpacity(0.4),
          themeManager.backgroundColor.withOpacity(0.3),
        ],
      );
    }
  }
}

// Painter to create a subtle chess pattern
class ChessPatternPainter extends CustomPainter {
  final Color lightColor;
  final Color darkColor;

  ChessPatternPainter({
    required this.lightColor,
    required this.darkColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const squareSize = 40.0;
    final lightPaint = Paint()..color = lightColor;
    final darkPaint = Paint()..color = darkColor;

    for (double x = 0; x < size.width; x += squareSize) {
      for (double y = 0; y < size.height; y += squareSize) {
        final isLight = ((x / squareSize).floor() + (y / squareSize).floor()) % 2 == 0;
        canvas.drawRect(
          Rect.fromLTWH(x, y, squareSize, squareSize),
          isLight ? lightPaint : darkPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
