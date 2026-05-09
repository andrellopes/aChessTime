import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chess_theme_manager.dart';
import '../controllers/game_controller.dart';
import '../l10n/app_localizations.dart';

class FideStandardDialog extends StatelessWidget {
  const FideStandardDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const FideStandardDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ChessThemeManager>(context);
    final game = Provider.of<GameController>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: theme.surfaceColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: theme.accentColor.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header com Ícone
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.accentColor.withOpacity(0.15),
                      theme.primaryColor.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.accentColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.emoji_events_rounded, 
                        size: 48, color: theme.accentColor),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.fideStandardTitle,
                      style: TextStyle(
                        color: theme.textPrimaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      l10n.fideStandardFideMode,
                      style: TextStyle(
                        color: theme.accentColor.withOpacity(0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Corpo
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                child: Column(
                  children: [
                    Text(
                      l10n.fideStandardDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.textSecondaryColor,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    
                    // Botão Profissional
                    _buildOption(
                      context: context,
                      title: l10n.fideStandardProfessional,
                      subtitle: l10n.fideStandardProfessionalSub,
                      icon: Icons.verified_rounded,
                      color: theme.accentColor,
                      onTap: () {
                        game.setFideStandard(true);
                        Navigator.pop(context);
                      },
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Botão Clássico
                    _buildOption(
                      context: context,
                      title: l10n.fideStandardClassic,
                      subtitle: l10n.fideStandardClassicSub,
                      icon: Icons.history_rounded,
                      color: theme.textSecondaryColor.withOpacity(0.8),
                      onTap: () {
                        game.setFideStandard(false);
                        Navigator.pop(context);
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    Text(
                      l10n.fideStandardSettingsNote,
                      style: TextStyle(
                        color: theme.textSecondaryColor.withOpacity(0.5),
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
            color: color.withOpacity(0.04),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: color.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: color.withOpacity(0.3), size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
