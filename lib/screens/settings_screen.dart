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
      builder: (context, game, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              Expanded(child: Text(l10n.settingsTitle)),
              Consumer<PurchaseService>(
                builder: (_, ps, __) => ps.isProVersion
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 4),
                          Text(
                            'PRO',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        body: SafeArea(
          top: !game.settings.isImmersiveMode,
          child: Column(
            children: [
              Expanded(child: _buildList(context, game, l10n)),
              _buildAdBanner(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Main list ──────────────────────────────────────────────────────────────

  Widget _buildList(BuildContext context, GameController game, AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        _buildProBanner(context, l10n),
        _section(l10n.timeControls, [
          ChessPresetSelector(
            onPresetSelected: (preset) {
              game.updateTimePreset(
                'custom', 
                preset.initialTime,
                increment: preset.increment,
                incrementPreset: 'custom',
              );
            },
          ),
        ]),
        _section(l10n.gameSettings, [
          _switchTile(
            title: '${l10n.player1} = ${l10n.whitePlayer}',
            subtitle: l10n.player1StartsAsWhite,
            value: game.settings.isPlayer1White,
            onChanged: (_) => game.swapPlayers(),
          ),
          _divider(),
          _switchTile(
            title: l10n.sounds,
            subtitle: l10n.soundsSubtitle,
            value: game.settings.isSoundEnabled,
            onChanged: (_) => game.toggleSound(),
          ),
          _divider(),
          _switchTile(
            title: l10n.vibration,
            subtitle: l10n.vibrationSubtitle,
            value: game.settings.isVibrateEnabled,
            onChanged: (_) => game.toggleVibration(),
          ),
          _divider(),
          _switchTile(
            title: l10n.fideStandardSettingTitle,
            subtitle: l10n.fideStandardSettingSubtitle,
            value: game.settings.addIncrementAtStart ?? false,
            onChanged: (val) => game.setFideStandard(val),
          ),
        ]),
        _section(l10n.appearance, [
          const ThemeSelectorWidget(),
          _divider(),
          _buildLanguageSelector(context, l10n),
          _divider(),
          _switchTile(
            title: l10n.immersiveMode,
            subtitle: l10n.immersiveModeSubtitle,
            value: game.settings.isImmersiveMode,
            onChanged: (_) => game.toggleImmersiveMode(),
          ),
          _divider(),
          ListTile(
            title: Text(l10n.fontSizeTitle),
            subtitle: Text(l10n.fontSizeSubtitle),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            trailing: Text(
              '${game.settings.fontSize.toInt()}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Slider(
            min: 24,
            max: 130,
            divisions: 53,
            value: game.settings.fontSize,
            label: '${game.settings.fontSize.toInt()}',
            onChanged: game.updateFontSize,
          ),
        ]),
        _section(l10n.statistics, [
          _simpleTile(
            icon: Icons.analytics,
            iconColor: Colors.green,
            title: l10n.viewStatistics,
            subtitle: l10n.statisticsSubtitle,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const StatisticsScreen()),
            ),
          ),
        ]),
        _section(l10n.backup, [
          _proTile(
            icon: Icons.backup,
            iconColor: Colors.blue,
            title: l10n.createBackup,
            subtitle: l10n.createBackupSubtitle,
            onTap: () => _createBackup(context),
          ),
          _divider(),
          _proTile(
            icon: Icons.restore,
            iconColor: Colors.orange,
            title: l10n.restoreBackup,
            subtitle: l10n.restoreBackupSubtitle,
            onTap: () => _restoreBackup(context),
          ),
          _divider(),
          _proTile(
            icon: Icons.file_download,
            iconColor: Colors.green,
            title: l10n.exportStatistics,
            subtitle: l10n.exportStatisticsSubtitle,
            onTap: () => _exportStatisticsToCSV(context),
          ),
        ]),
        _section(l10n.help, [
          _simpleTile(
            icon: Icons.info_outline,
            iconColor: Colors.blue,
            title: l10n.aboutApp,
            onTap: () => showAppAboutDialog(context),
          ),
          _divider(),
          _simpleTile(
            icon: Icons.star,
            iconColor: Colors.amber,
            title: l10n.evaluateInPlayStore,
            onTap: _openPlayStore,
          ),
        ]),
      ],
    );
  }

  // ── PRO upgrade banner ─────────────────────────────────────────────────────

  Widget _buildProBanner(BuildContext context, AppLocalizations l10n) {
    return Consumer<PurchaseService>(
      builder: (context, ps, _) {
        if (ps.isProVersion) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            elevation: 3,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => showDialog(
                context: context,
                builder: (_) => const ProUpgradeDialog(),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade600, Colors.indigo.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 24),
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
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Section card ───────────────────────────────────────────────────────────

  Widget _section(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        children: children,
      ),
    );
  }

  // ── Tile helpers ───────────────────────────────────────────────────────────

  Widget _switchTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      value: value,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onChanged: onChanged,
    );
  }

  Widget _simpleTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: onTap,
    );
  }

  /// A ListTile that shows a lock + PRO badge when the user isn't PRO.
  Widget _proTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Consumer<PurchaseService>(
      builder: (_, ps, __) => ListTile(
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: iconColor),
            if (!ps.isProVersion)
              Positioned(
                right: -4,
                bottom: -4,
                child: Icon(Icons.lock, color: Colors.amber.shade600, size: 14),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(child: Text(title)),
            if (!ps.isProVersion)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.amber.shade600,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'PRO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
          ],
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: onTap,
      ),
    );
  }

  Widget _divider() => const Divider(height: 1);

  // ── Language selector ──────────────────────────────────────────────────────

  Widget _buildLanguageSelector(BuildContext context, AppLocalizations l10n) {
    return Consumer<LanguageService>(
      builder: (_, languageService, __) => ListTile(
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
          onChanged: (code) {
            if (code != null) languageService.changeLanguage(code);
          },
        ),
      ),
    );
  }

  // ── Ad banner ──────────────────────────────────────────────────────────────

  Widget _buildAdBanner() {
    return Consumer<PurchaseService>(
      builder: (_, ps, __) => ps.isProVersion ? const SizedBox.shrink() : const BannerAdWidget(),
    );
  }

  // ── PRO gate ───────────────────────────────────────────────────────────────

  bool _checkProAccess(BuildContext context) {
    final ps = Provider.of<PurchaseService>(context, listen: false);
    if (!ps.isProVersion) {
      showDialog(context: context, builder: (_) => const ProUpgradeDialog());
      return false;
    }
    return true;
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _createBackup(BuildContext context) async {
    if (!_checkProAccess(context)) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      final success = await BackupService.shareBackup(
        presetService: Provider.of<ChessPresetService>(context, listen: false),
        purchaseService: Provider.of<PurchaseService>(context, listen: false),
        languageService: Provider.of<LanguageService>(context, listen: false),
        l10n: l10n,
      );
      if (context.mounted) {
        _showSnack(context, success ? l10n.backupCreatedMessage : l10n.backupError,
            success ? Colors.green : Colors.red);
      }
    } catch (e) {
      if (context.mounted) _showSnack(context, '${l10n.backupError}: $e', Colors.red);
    }
  }

  Future<void> _restoreBackup(BuildContext context) async {
    if (!_checkProAccess(context)) return;
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.restoreBackup),
        content: Text(l10n.restoreBackupConfirmMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.restoreBackup),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final result = await BackupService.restoreBackup(
        presetService: Provider.of<ChessPresetService>(context, listen: false),
        purchaseService: Provider.of<PurchaseService>(context, listen: false),
        languageService: Provider.of<LanguageService>(context, listen: false),
        gameController: Provider.of<GameController>(context, listen: false),
        l10n: l10n,
      );
      if (context.mounted) {
        _showSnack(context, result.message, result.success ? Colors.green : Colors.red);
      }
    } catch (e) {
      if (context.mounted) _showSnack(context, '${l10n.backupRestoreError}: $e', Colors.red);
    }
  }

  Future<void> _exportStatisticsToCSV(BuildContext context) async {
    if (!_checkProAccess(context)) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      final success = await StatisticsService.shareStatisticsCSV(context);
      if (context.mounted) {
        _showSnack(
          context,
          success ? l10n.exportCsvSuccess : l10n.exportCsvNoData,
          success ? Colors.green : Colors.orange,
        );
      }
    } catch (e) {
      if (context.mounted) _showSnack(context, l10n.exportCsvError(e.toString()), Colors.red);
    }
  }

  Future<void> _openPlayStore() async {
    final uri = Uri.parse('https://play.google.com/store/apps/details?id=dev.allc.a_chess_time');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('Erro ao abrir Play Store: $e');
    }
  }

  void _showSnack(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}
