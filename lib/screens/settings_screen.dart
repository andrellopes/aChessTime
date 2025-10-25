import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/game_controller.dart';
import '../widgets/about_dialog.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/theme_selector_widget.dart';
import '../widgets/pro_upgrade_dialog.dart';
import '../widgets/chess_preset_selector.dart';
import '../services/purchase_service.dart';
import '../services/language_service.dart';
import '../services/backup_service.dart';
import '../services/chess_preset_service.dart';
import '../services/statistics_service.dart';
import '../l10n/app_localizations.dart';
import 'statistics_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<GameController>(
      builder: (context, game, child) {
        return Scaffold(
          appBar: AppBar(
            title: Consumer<PurchaseService>(
              builder: (context, purchaseService, child) => Row(
                children: [
                  Expanded(
                    child: Text(l10n.settingsTitle),
                  ),
                  if (purchaseService.isProVersion)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'PRO',
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: game.settings.isImmersiveMode
            ? Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Consumer<PurchaseService>(
                          builder: (context, purchaseService, child) {
                            if (purchaseService.isProVersion) {
                              return const SizedBox.shrink();
                            }
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Material(
                                borderRadius: BorderRadius.circular(12),
                                elevation: 3,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const ProUpgradeDialog(),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.purple.shade600,
                                          Colors.indigo.shade600,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.workspace_premium_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                l10n.upgradeToProTitle,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                l10n.unlockPremiumThemes,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white70,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        _expansionSection(l10n.timeControls, [
                          ChessPresetSelector(
                            onPresetSelected: (preset) {
                              // Apply the preset settings to GameController
                              game.updateTimePreset('custom', preset.initialTime);
                              game.updateIncrement(preset.increment, 'custom');
                            },
                          ),
                        ]),
                        _expansionSection(l10n.gameSettings, [
                          SwitchListTile(
                            title: Text('${l10n.player1} = ${l10n.whitePlayer}'),
                            subtitle: Text(l10n.player1StartsAsWhite),
                            value: game.settings.isPlayer1White,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            onChanged: (value) {
                              game.swapPlayers();
                            },
                          ),
                          _divider(),
                          SwitchListTile(
                            title: Text(l10n.sounds),
                            subtitle: Text(l10n.soundsSubtitle),
                            value: game.settings.isSoundEnabled,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            onChanged: (value) {
                              game.toggleSound();
                            },
                          ),
                          _divider(),
                          SwitchListTile(
                            title: Text(l10n.vibration),
                            subtitle: Text(l10n.vibrationSubtitle),
                            value: game.settings.isVibrateEnabled,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            onChanged: (value) {
                              game.toggleVibration();
                            },
                          ),
                          if (kDebugMode) ...[
                            _divider(),
                            Consumer<PurchaseService>(
                              builder: (context, purchaseService, child) => SwitchListTile(
                                title: Text(l10n.debugProMode),
                                subtitle: Text(l10n.debugProModeSubtitle),
                                value: purchaseService.isProVersion,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                onChanged: (value) {
                                  purchaseService.setDebugPro(value);
                                },
                              ),
                            ),
                          ],
                        ]),
                        _expansionSection(l10n.appearance, [
                          const ThemeSelectorWidget(),
                          _divider(),
                          _buildLanguageSelector(context, l10n),
                          _divider(),
                          SwitchListTile(
                            title: Text(l10n.immersiveMode),
                            subtitle: Text(l10n.immersiveModeSubtitle),
                            value: game.settings.isImmersiveMode,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            onChanged: (value) {
                              game.toggleImmersiveMode();
                            },
                          ),
                          _divider(),
                          ListTile(
                            title: Text(l10n.fontSizeTitle),
                            subtitle: Text(l10n.fontSizeSubtitle),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            trailing: Text('${game.settings.fontSize.toInt()}'),
                          ),
                          Slider(
                            min: 24,
                            max: 130,
                            divisions: 53,
                            value: game.settings.fontSize,
                            label: '${game.settings.fontSize.toInt()}',
                            onChanged: (value) {
                              game.updateFontSize(value);
                            },
                          ),
                        ]),
                        _expansionSection(l10n.statistics, [
                          ListTile(
                            leading: const Icon(Icons.analytics, color: Colors.green),
                            title: Text(l10n.viewStatistics),
                            subtitle: Text(l10n.statisticsSubtitle),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const StatisticsScreen(),
                                ),
                              );
                            },
                          ),
                        ]),
                        _expansionSection(l10n.backup, [
                          Consumer<PurchaseService>(
                            builder: (context, purchaseService, child) => ListTile(
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.backup, color: Colors.blue),
                                  if (!purchaseService.isProVersion) ...[
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.lock,
                                      color: Colors.amber.shade600,
                                      size: 16,
                                    ),
                                  ],
                                ],
                              ),
                              title: Row(
                                children: [
                                  Expanded(child: Text(l10n.createBackup)),
                                  if (!purchaseService.isProVersion)
                                    Text(
                                      'PRO',
                                      style: TextStyle(
                                        color: Colors.amber.shade600,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                              subtitle: Text(l10n.createBackupSubtitle),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              onTap: () => _createBackup(context),
                            ),
                          ),
                          _divider(),
                          Consumer<PurchaseService>(
                            builder: (context, purchaseService, child) => ListTile(
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.restore, color: Colors.orange),
                                  if (!purchaseService.isProVersion) ...[
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.lock,
                                      color: Colors.amber.shade600,
                                      size: 16,
                                    ),
                                  ],
                                ],
                              ),
                              title: Row(
                                children: [
                                  Expanded(child: Text(l10n.restoreBackup)),
                                  if (!purchaseService.isProVersion)
                                    Text(
                                      'PRO',
                                      style: TextStyle(
                                        color: Colors.amber.shade600,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                              subtitle: Text(l10n.restoreBackupSubtitle),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              onTap: () => _restoreBackup(context),
                            ),
                          ),
                          _divider(),
                          Consumer<PurchaseService>(
                            builder: (context, purchaseService, child) => ListTile(
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.file_download, color: Colors.green),
                                  if (!purchaseService.isProVersion) ...[
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.lock,
                                      color: Colors.amber.shade600,
                                      size: 16,
                                    ),
                                  ],
                                ],
                              ),
                              title: Row(
                                children: [
                                  Expanded(child: Text(l10n.exportStatistics)),
                                  if (!purchaseService.isProVersion)
                                    Text(
                                      'PRO',
                                      style: TextStyle(
                                        color: Colors.amber.shade600,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                              subtitle: Text(l10n.exportStatisticsSubtitle),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              onTap: () => _exportStatisticsToCSV(context),
                            ),
                          ),
                        ]),
                        _expansionSection(l10n.help, [
                          ListTile(
                            leading: const Icon(Icons.info_outline, color: Colors.blue),
                            title: Text(l10n.aboutApp),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            onTap: () {
                              showAppAboutDialog(context);
                            },
                          ),
                          _divider(),
                          ListTile(
                            leading: const Icon(Icons.star, color: Colors.amber),
                            title: Text(l10n.evaluateInPlayStore),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            onTap: () => _openPlayStore(),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  Consumer<PurchaseService>(
                    builder: (context, purchaseService, child) {
                      debugPrint('SettingsScreen: isProVersion = ${purchaseService.isProVersion}');
                      if (purchaseService.isProVersion) {
                        debugPrint('SettingsScreen: Pro user, no ads');
                        return const SizedBox.shrink();
                      }
                      debugPrint('SettingsScreen: Adding BannerAdWidget');
                      return const BannerAdWidget();
                    },
                  ),
                ],
              )
            : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          Consumer<PurchaseService>(
                            builder: (context, purchaseService, child) {
                              if (purchaseService.isProVersion) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Material(
                                  borderRadius: BorderRadius.circular(12),
                                  elevation: 3,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => const ProUpgradeDialog(),
                                      );
                                    },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.purple.shade600,
                                          Colors.indigo.shade600,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.workspace_premium_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                l10n.upgradeToProTitle,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                l10n.unlockPremiumThemes,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white70,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          ),
                          _expansionSection(l10n.timeControls, [
                            ChessPresetSelector(
                              onPresetSelected: (preset) {
                                // Apply the preset settings to GameController
                                game.updateTimePreset('custom', preset.initialTime);
                                game.updateIncrement(preset.increment, 'custom');
                              },
                            ),
                          ]),
                          _expansionSection(l10n.gameSettings, [
                            SwitchListTile(
                              title: Text('${l10n.player1} = ${l10n.whitePlayer}'),
                              subtitle: Text(l10n.player1StartsAsWhite),
                              value: game.settings.isPlayer1White,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              onChanged: (value) {
                                game.swapPlayers();
                              },
                            ),
                            _divider(),
                            SwitchListTile(
                              title: Text(l10n.sounds),
                              subtitle: Text(l10n.soundsSubtitle),
                              value: game.settings.isSoundEnabled,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              onChanged: (value) {
                                game.toggleSound();
                              },
                            ),
                            _divider(),
                            SwitchListTile(
                              title: Text(l10n.vibration),
                              subtitle: Text(l10n.vibrationSubtitle),
                              value: game.settings.isVibrateEnabled,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              onChanged: (value) {
                                game.toggleVibration();
                              },
                            ),
                            if (kDebugMode) ...[
                              _divider(),
                              Consumer<PurchaseService>(
                                builder: (context, purchaseService, child) => SwitchListTile(
                                  title: Text(l10n.debugProMode),
                                  subtitle: Text(l10n.debugProModeSubtitle),
                                  value: purchaseService.isProVersion,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  onChanged: (value) {
                                    purchaseService.setDebugPro(value);
                                  },
                                ),
                              ),
                            ],
                          ]),
                          _expansionSection(l10n.appearance, [
                            const ThemeSelectorWidget(),
                            _divider(),
                            _buildLanguageSelector(context, l10n),
                            _divider(),
                            SwitchListTile(
                              title: Text(l10n.immersiveMode),
                              subtitle: Text(l10n.immersiveModeSubtitle),
                              value: game.settings.isImmersiveMode,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              onChanged: (value) {
                                game.toggleImmersiveMode();
                              },
                            ),
                            _divider(),
                            ListTile(
                              title: Text(l10n.fontSizeTitle),
                              subtitle: Text(l10n.fontSizeSubtitle),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              trailing: Text('${game.settings.fontSize.toInt()}'),
                            ),
                            Slider(
                              min: 24,
                              max: 130,
                              divisions: 53,
                              value: game.settings.fontSize,
                              label: '${game.settings.fontSize.toInt()}',
                              onChanged: (value) {
                                game.updateFontSize(value);
                              },
                            ),
                          ]),
                          _expansionSection(l10n.statistics, [
                            ListTile(
                              leading: const Icon(Icons.analytics, color: Colors.green),
                              title: Text(l10n.viewStatistics),
                              subtitle: Text(l10n.statisticsSubtitle),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const StatisticsScreen(),
                                  ),
                                );
                              },
                            ),
                          ]),
                          _expansionSection(l10n.backup, [
                            Consumer<PurchaseService>(
                              builder: (context, purchaseService, child) => ListTile(
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.backup, color: Colors.blue),
                                    if (!purchaseService.isProVersion) ...[
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.lock,
                                        color: Colors.amber.shade600,
                                        size: 16,
                                      ),
                                    ],
                                  ],
                                ),
                                title: Row(
                                  children: [
                                    Expanded(child: Text(l10n.createBackup)),
                                    if (!purchaseService.isProVersion)
                                      Text(
                                        'PRO',
                                        style: TextStyle(
                                          color: Colors.amber.shade600,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle: Text(l10n.createBackupSubtitle),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                onTap: () => _createBackup(context),
                              ),
                            ),
                            _divider(),
                            Consumer<PurchaseService>(
                              builder: (context, purchaseService, child) => ListTile(
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.restore, color: Colors.orange),
                                    if (!purchaseService.isProVersion) ...[
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.lock,
                                        color: Colors.amber.shade600,
                                        size: 16,
                                      ),
                                    ],
                                  ],
                                ),
                                title: Row(
                                  children: [
                                    Expanded(child: Text(l10n.restoreBackup)),
                                    if (!purchaseService.isProVersion)
                                      Text(
                                        'PRO',
                                        style: TextStyle(
                                          color: Colors.amber.shade600,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle: Text(l10n.restoreBackupSubtitle),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                onTap: () => _restoreBackup(context),
                              ),
                            ),
                            _divider(),
                            Consumer<PurchaseService>(
                              builder: (context, purchaseService, child) => ListTile(
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.file_download, color: Colors.green),
                                    if (!purchaseService.isProVersion) ...[
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.lock,
                                        color: Colors.amber.shade600,
                                        size: 16,
                                      ),
                                    ],
                                  ],
                                ),
                                title: Row(
                                  children: [
                                    Expanded(child: Text(l10n.exportStatistics)),
                                    if (!purchaseService.isProVersion)
                                      Text(
                                        'PRO',
                                        style: TextStyle(
                                          color: Colors.amber.shade600,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle: Text(l10n.exportStatisticsSubtitle),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                onTap: () => _exportStatisticsToCSV(context),
                              ),
                            ),
                          ]),
                          _expansionSection(l10n.help, [
                            ListTile(
                              leading: const Icon(Icons.info_outline, color: Colors.blue),
                              title: Text(l10n.aboutApp),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              onTap: () {
                                showAppAboutDialog(context);
                              },
                            ),
                            _divider(),
                            ListTile(
                              leading: const Icon(Icons.star, color: Colors.amber),
                              title: Text(l10n.evaluateInPlayStore),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              onTap: () => _openPlayStore(),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Consumer<PurchaseService>(
                      builder: (context, purchaseService, child) {
                        debugPrint('SettingsScreen: isProVersion = ${purchaseService.isProVersion}');
                        if (purchaseService.isProVersion) {
                          debugPrint('SettingsScreen: Pro user, no ads');
                          return const SizedBox.shrink();
                        }
                        debugPrint('SettingsScreen: Adding BannerAdWidget');
                        return const BannerAdWidget();
                      },
                    ),
                  ],
                ),
              ),
        );
      },
    );
  }

  Widget _divider() => const Divider(height: 1);

  Widget _expansionSection(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          title, 
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        children: children,
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, AppLocalizations l10n) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return ListTile(
          title: Text(l10n.language),
          subtitle: Text(languageService.currentLanguageName),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          trailing: DropdownButton<String>(
            value: languageService.currentLanguageCode,
            underline: const SizedBox.shrink(),
            items: LanguageService.supportedLocales.map((locale) {
              final code = locale.languageCode;
              final name = LanguageService.languageNames[code] ?? code;
              final flag = languageService.getLanguageFlag(code);
              return DropdownMenuItem<String>(
                value: code,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(name),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newLanguageCode) {
              if (newLanguageCode != null) {
                languageService.changeLanguage(newLanguageCode);
              }
            },
          ),
        );
      },
    );
  }

  // Helper method to check if it's Pro and show upgrade if necessary
  bool _checkProAccess(BuildContext context) {
    final purchaseService = Provider.of<PurchaseService>(context, listen: false);
    if (!purchaseService.isProVersion) {
      showDialog(
        context: context,
        builder: (context) => const ProUpgradeDialog(),
      );
      return false;
    }
    return true;
  }

  Future<void> _createBackup(BuildContext context) async {
    if (!_checkProAccess(context)) return;

    final l10n = AppLocalizations.of(context)!;

    try {
      final presetService = Provider.of<ChessPresetService>(context, listen: false);
      final purchaseService = Provider.of<PurchaseService>(context, listen: false);
      final languageService = Provider.of<LanguageService>(context, listen: false);

      final success = await BackupService.shareBackup(
        presetService: presetService,
        purchaseService: purchaseService,
        languageService: languageService,
        l10n: l10n,
      );
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.backupCreatedMessage),
            backgroundColor: Colors.green,
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.backupError),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.backupError}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _restoreBackup(BuildContext context) async {
    if (!_checkProAccess(context)) return;

    final l10n = AppLocalizations.of(context)!;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.restoreBackup),
        content: Text(l10n.restoreBackupConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.restoreBackup),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final presetService = Provider.of<ChessPresetService>(context, listen: false);
      final purchaseService = Provider.of<PurchaseService>(context, listen: false);
      final languageService = Provider.of<LanguageService>(context, listen: false);
      final gameController = Provider.of<GameController>(context, listen: false);

      final result = await BackupService.restoreBackup(
        presetService: presetService,
        purchaseService: purchaseService,
        languageService: languageService,
        gameController: gameController,
        l10n: l10n,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: result.success ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.backupRestoreError}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportStatisticsToCSV(BuildContext context) async {
    if (!_checkProAccess(context)) return;

    final l10n = AppLocalizations.of(context)!;

    try {
      final success = await StatisticsService.shareStatisticsCSV(context);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportCsvSuccess),
            backgroundColor: Colors.green,
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportCsvNoData),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportCsvError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openPlayStore() async {
    final String packageName = 'dev.allc.a_chess_time';
    final Uri playStoreUri = Uri.parse('https://play.google.com/store/apps/details?id=$packageName');
    
    try {
      if (await canLaunchUrl(playStoreUri)) {
        await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(playStoreUri);
      }
    } catch (e) {
      debugPrint('Erro ao abrir Play Store: $e');
    }
  }

}
