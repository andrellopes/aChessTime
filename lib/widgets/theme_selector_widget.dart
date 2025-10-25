import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chess_theme_manager.dart';
import '../widgets/pro_upgrade_dialog.dart';
import '../l10n/app_localizations.dart';
import '../models/chess_theme_presets.dart';

class ThemeSelectorWidget extends StatelessWidget {
  const ThemeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<ChessThemeManager>(
      builder: (context, themeManager, child) {
        return Column(
          children: [
            ListTile(
              title: Text(l10n.themeTitle),
              subtitle: Text(themeManager.getThemeName((key) => _getLocalizedThemeName(l10n, key))),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              trailing: const Icon(Icons.palette_outlined),
              onTap: () => _showThemeSelector(context, themeManager, l10n),
            ),
          ],
        );
      },
    );
  }

  void _showThemeSelector(BuildContext context, ChessThemeManager themeManager, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Drag handle
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Title
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    l10n.themeTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                // Theme list
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: chessFreeThemes.length + chessPremiumThemes.length,
                    itemBuilder: (context, index) {
                      final allThemes = [...chessFreeThemes, ...chessPremiumThemes];
                      final theme = allThemes[index];
                      final isSelected = themeManager.currentThemeIndex == index;
                      final isPremium = index >= chessFreeThemes.length;
                      final canUse = !isPremium || themeManager.isPremium;
                      
                      return GestureDetector(
                        onTap: () async {
                          if (canUse) {
                            final success = await themeManager.setTheme(index);
                            if (success && context.mounted) {
                              Navigator.pop(context);
                            }
                          } else {
                            // Show upgrade required message
                            _showPremiumDialog(context, l10n);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected 
                                ? Border.all(color: theme.accent, width: 3)
                                : Border.all(color: Colors.grey.withOpacity(0.3)),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                theme.background,
                                theme.surface,
                                theme.primary.withOpacity(0.3),
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Theme preview
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Theme name
                                    Text(
                                      _getLocalizedThemeName(l10n, theme.labelKey),
                                      style: TextStyle(
                                        color: theme.textPrimary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    
                                    const SizedBox(height: 8),
                                    
                                    // Color preview
                                    Expanded(
                                      child: Row(
                                        children: [
                                          // White player color
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(right: 2),
                                              decoration: BoxDecoration(
                                                color: theme.whitePlayerColor,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'W',
                                                  style: TextStyle(
                                                    color: theme.background,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          
                                          // Black player color
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(left: 2),
                                              decoration: BoxDecoration(
                                                color: theme.blackPlayerColor,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'B',
                                                  style: TextStyle(
                                                    color: theme.textPrimary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 4),
                                    
                                    // Status colors
                                    Row(
                                      children: [
                                        _colorDot(theme.activeTimerColor),
                                        const SizedBox(width: 2),
                                        _colorDot(theme.warningColor),
                                        const SizedBox(width: 2),
                                        _colorDot(theme.criticalColor),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Premium indicator
                              if (isPremium)
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: canUse ? Colors.amber : Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'PRO',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              
                              // Selected indicator
                              if (isSelected)
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: theme.accent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: theme.background,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              
                              // Overlay if cannot use
                              if (!canUse)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 16),
              ],
            );
          },
        );
      },
    );
  }

  Widget _colorDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  void _showPremiumDialog(BuildContext context, AppLocalizations l10n) {
    Navigator.pop(context); // Close theme selector
    showDialog(
      context: context,
      builder: (context) => const ProUpgradeDialog(),
    );
  }

  String _getLocalizedThemeName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'themeClassicDark':
        return l10n.themeClassicDark;
      case 'themeTraditionalBoard':
        return l10n.themeTraditionalBoard;
      case 'themeGreenFocus':
        return l10n.themeGreenFocus;
      case 'themeTournamentBlue':
        return l10n.themeTournamentBlue;
      case 'themeRoyalGold':
        return l10n.themeRoyalGold;
      case 'themeGrandmasterPurple':
        return l10n.themeGrandmasterPurple;
      case 'themeCompetitiveRed':
        return l10n.themeCompetitiveRed;
      case 'themeDeepOcean':
        return l10n.themeDeepOcean;
      case 'themeMysticForest':
        return l10n.themeMysticForest;
      case 'themeElegantRose':
        return l10n.themeElegantRose;
      case 'themePremiumSilver':
        return l10n.themePremiumSilver;
      case 'themeAuroraBoreal':
        return l10n.themeAuroraBoreal;
      case 'themeCustom':
        return l10n.themeCustom;
      default:
        return key;
    }
  }
}
