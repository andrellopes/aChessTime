import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chess_time_preset.dart';
import '../models/game_settings.dart';
import '../services/chess_preset_service.dart';
import '../services/chess_theme_manager.dart';
import '../l10n/app_localizations.dart';

class ChessPresetSelector extends StatefulWidget {
  final Function(ChessTimePreset) onPresetSelected;
  
  const ChessPresetSelector({
    super.key,
    required this.onPresetSelected,
  });

  @override
  State<ChessPresetSelector> createState() => _ChessPresetSelectorState();
}

class _ChessPresetSelectorState extends State<ChessPresetSelector> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<ChessPresetService>(
      builder: (context, presetService, child) {
        final allPresets = presetService.getAllPresets();
        final currentPreset = presetService.getCurrentPresetAsObject();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(l10n.timePresets),
              subtitle: Text(
                _getPresetDisplayName(currentPreset, l10n),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showCreateCustomPreset(presetService),
                tooltip: l10n.createCustomPreset,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 140, // Aumentado de 120 para 140 para evitar overflow
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: allPresets.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final preset = allPresets[index];
              final isSelected = presetService.getCurrentPresetId() == preset.id;
              
              return _buildPresetCard(preset, isSelected, l10n, presetService);
            },
          ),
        ),
      ],
    );
      },
    );
  }

  Widget _buildPresetCard(ChessTimePreset preset, bool isSelected, AppLocalizations l10n, ChessPresetService presetService) {
    return GestureDetector(
      onTap: () => _selectPreset(preset, presetService),
      onLongPress: preset.isCustom ? () => _showEditCustomPreset(preset, presetService) : null,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Garante que a coluna não tente ocupar espaço infinito
            children: [
              Row(
                children: [
                  Icon(
                    _getPresetIcon(preset.icon),
                    color: isSelected 
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const Spacer(),
                  if (preset.isCustom)
                    GestureDetector(
                      onTap: () => _showDeleteConfirmation(preset, presetService),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _getPresetDisplayName(preset, l10n),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 1, // Reduzido para 1 linha para economizar espaço vertical
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(), // Empurra as informações de tempo para o fundo do card
              Text(
                preset.player2InitialTime != null
                  ? '${preset.initialTime.inMinutes}m vs ${preset.player2InitialTime!.inMinutes}m'
                  : '${preset.initialTime.inMinutes} min',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (preset.increment.inSeconds > 0)
                    Text(
                      '+${preset.increment.inSeconds}s',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  if (preset.timeMode != TimeMode.none)
                    Text(
                      preset.timeMode == TimeMode.usDelay 
                        ? 'US DELAY' 
                        : preset.timeMode.toString().split('.').last.toUpperCase(),
                      style: TextStyle(
                        fontSize: 8,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPresetIcon(String iconName) {
    switch (iconName) {
      case 'emoji_events':
        return Icons.emoji_events;
      case 'flash_on':
        return Icons.flash_on;
      case 'speed':
        return Icons.speed;
      case 'timer':
        return Icons.timer;
      case 'account_balance':
        return Icons.account_balance;
      case 'play_circle':
        return Icons.play_circle;
      case 'tune':
        return Icons.tune;
      default:
        return Icons.timer;
    }
  }

  String _getPresetDisplayName(ChessTimePreset preset, AppLocalizations l10n) {
    if (preset.isCustom && preset.customName != null) {
      return preset.customName!;
    }
    
    switch (preset.nameKey) {
      case 'presetTournament':
        return l10n.presetTournament;
      case 'presetBlitz':
        return l10n.presetBlitz;
      case 'presetBullet':
        return l10n.presetBullet;
      case 'presetRapid':
        return l10n.presetRapid;
      case 'presetClassical':
        return l10n.presetClassical;
      case 'presetBasic':
        return l10n.presetBasic;
      default:
        return preset.customName ?? preset.nameKey;
    }
  }

  Future<void> _selectPreset(ChessTimePreset preset, ChessPresetService presetService) async {
    await presetService.setCurrentPreset(preset.id);
    widget.onPresetSelected(preset);
  }

  void _showCreateCustomPreset(ChessPresetService presetService) {
    _showCustomPresetDialog(presetService: presetService);
  }

  void _showEditCustomPreset(ChessTimePreset preset, ChessPresetService presetService) {
    _showCustomPresetDialog(presetService: presetService, initialPreset: preset);
  }

  void _showCustomPresetDialog({required ChessPresetService presetService, ChessTimePreset? initialPreset}) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: initialPreset?.customName ?? '');
    int initialMinutes = initialPreset?.initialTime.inMinutes ?? 10;
    bool isHandicap = initialPreset?.player2InitialTime != null;
    int player2InitialMinutes = initialPreset?.player2InitialTime?.inMinutes ?? 10;
    int incrementSeconds = initialPreset?.increment.inSeconds ?? 5;
    TimeMode timeMode = initialPreset?.timeMode ?? TimeMode.fischer;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Consumer<ChessThemeManager>(
        builder: (context, themeManager, _) => StatefulBuilder(
          builder: (context, setDialogState) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(
                          color: themeManager.textSecondaryColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Header
                    Row(
                      children: [
                        Icon(Icons.tune, color: themeManager.primaryColor, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          initialPreset == null ? l10n.createCustomPreset : l10n.editPreset,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeManager.textPrimaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Nome
                    TextField(
                      controller: nameController,
                      onChanged: (val) => setDialogState(() {}),
                      style: TextStyle(color: themeManager.textPrimaryColor),
                      decoration: InputDecoration(
                        labelText: l10n.presetName,
                        hintText: 'Ex: Blitz Profissional',
                        errorText: nameController.text.trim().isEmpty ? l10n.fieldRequired : null,
                        labelStyle: TextStyle(color: themeManager.textSecondaryColor),
                        prefixIcon: Icon(Icons.label_outline, color: themeManager.primaryColor),
                        filled: true,
                        fillColor: themeManager.surfaceColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: themeManager.primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Seção: Tempo Brancas
                    _buildSliderSection(
                      context: context,
                      themeManager: themeManager,
                      icon: Icons.timer_outlined,
                      iconColor: themeManager.whitePlayerColor,
                      label: '\u2654  ${l10n.whitePlayer}',
                      valueLabel: '$initialMinutes ${l10n.minutesShort}',
                      badgeColor: themeManager.primaryColor,
                      sliderValue: initialMinutes.toDouble(),
                      sliderMin: 1,
                      sliderMax: 120,
                      divisions: 119,
                      onChanged: (v) => setDialogState(() => initialMinutes = v.toInt()),
                    ),
                    const SizedBox(height: 12),

                    // Seção: Incremento
                    _buildSliderSection(
                      context: context,
                      themeManager: themeManager,
                      icon: Icons.add_circle_outline,
                      iconColor: themeManager.accentColor,
                      label: l10n.increment,
                      valueLabel: incrementSeconds == 0 ? l10n.modeNone : '+$incrementSeconds ${l10n.secondsShort}',
                      badgeColor: themeManager.secondaryColor,
                      sliderValue: incrementSeconds.toDouble(),
                      sliderMin: 0,
                      sliderMax: 60,
                      divisions: 60,
                      onChanged: (v) => setDialogState(() => incrementSeconds = v.toInt()),
                    ),
                    const SizedBox(height: 16),

                    // Modo de Delay — chips horizontais
                    Text(l10n.timeMode, style: TextStyle(color: themeManager.textSecondaryColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: TimeMode.values.map((mode) {
                          final labels = {
                            TimeMode.fischer: l10n.modeFischer,
                            TimeMode.bronstein: l10n.modeBronstein,
                            TimeMode.usDelay: l10n.modeUSDelay,
                            TimeMode.none: l10n.modeNone,
                          };
                          final isSelected = timeMode == mode;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => setDialogState(() => timeMode = mode),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? themeManager.primaryColor.withOpacity(0.25) : themeManager.surfaceColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? themeManager.primaryColor : themeManager.textSecondaryColor.withOpacity(0.3),
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Text(
                                  labels[mode]!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? themeManager.primaryColor : themeManager.textSecondaryColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Handicap toggle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: themeManager.surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.balance, color: isHandicap ? themeManager.warningColor : themeManager.textSecondaryColor, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.handicap, style: TextStyle(color: themeManager.textPrimaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                                Text(l10n.differentTimesPerPlayer, style: TextStyle(color: themeManager.textSecondaryColor, fontSize: 11)),
                              ],
                            ),
                          ),
                          Switch(
                            value: isHandicap,
                            onChanged: (val) => setDialogState(() => isHandicap = val),
                            activeColor: themeManager.warningColor,
                          ),
                        ],
                      ),
                    ),

                    // Seção: Tempo Pretas (visível só se handicap ativo)
                    if (isHandicap) ...[
                      const SizedBox(height: 12),
                      _buildSliderSection(
                        context: context,
                        themeManager: themeManager,
                        icon: Icons.timer_outlined,
                        iconColor: themeManager.textSecondaryColor,
                        label: '\u265a  ${l10n.blackPlayer}',
                        valueLabel: '$player2InitialMinutes ${l10n.minutesShort}',
                        badgeColor: themeManager.secondaryColor,
                        sliderValue: player2InitialMinutes.toDouble(),
                        sliderMin: 1,
                        sliderMax: 120,
                        divisions: 119,
                        onChanged: (v) => setDialogState(() => player2InitialMinutes = v.toInt()),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Botões de ação
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: themeManager.textSecondaryColor.withOpacity(0.4)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(l10n.cancel, style: TextStyle(color: themeManager.textSecondaryColor)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: nameController.text.trim().isEmpty ? null : () async {
                              final name = nameController.text.trim();
                              final preset = ChessTimePreset.custom(
                                id: initialPreset?.id ?? 'custom_${DateTime.now().millisecondsSinceEpoch}',
                                customName: name,
                                initialTime: Duration(minutes: initialMinutes),
                                player2InitialTime: isHandicap ? Duration(minutes: player2InitialMinutes) : null,
                                increment: Duration(seconds: incrementSeconds),
                                timeMode: timeMode,
                              );
                              await presetService.saveCustomPreset(preset);
                              if (mounted) {
                                Navigator.pop(context);
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(initialPreset == null ? '${l10n.presetCreated}: $name' : '${l10n.presetUpdated}: $name')),
                                );
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: themeManager.primaryColor,
                              disabledBackgroundColor: themeManager.textSecondaryColor.withOpacity(0.1),
                              disabledForegroundColor: themeManager.textSecondaryColor.withOpacity(0.3),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(initialPreset == null ? l10n.create : l10n.save),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        ),
      ),
    );
  }

  Widget _buildSliderSection({
    required BuildContext context,
    required ChessThemeManager themeManager,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String valueLabel,
    required Color badgeColor,
    required double sliderValue,
    required double sliderMin,
    required double sliderMax,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: themeManager.textPrimaryColor, fontWeight: FontWeight.w600, fontSize: 13)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(valueLabel, style: TextStyle(color: themeManager.textPrimaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: iconColor,
              thumbColor: iconColor,
              inactiveTrackColor: themeManager.textSecondaryColor.withOpacity(0.2),
            ),
            child: Slider(
              value: sliderValue,
              min: sliderMin,
              max: sliderMax,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(ChessTimePreset preset, ChessPresetService presetService) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text('${l10n.deletePresetConfirm} "${preset.customName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              await presetService.removeCustomPreset(preset.id);
              if (mounted) {
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${l10n.presetDeleted}: ${preset.customName}'),
                  ),
                );
              }
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
