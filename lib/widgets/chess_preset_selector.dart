import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chess_time_preset.dart';
import '../services/chess_preset_service.dart';
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
              height: 120,
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
              const SizedBox(height: 8),
              Text(
                _getPresetDisplayName(preset, l10n),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${preset.initialTime.inMinutes}min',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (preset.increment.inSeconds > 0)
                Text(
                  '+${preset.increment.inSeconds}s',
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
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
    int incrementSeconds = initialPreset?.increment.inSeconds ?? 5;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(initialPreset == null ? l10n.createCustomPreset : l10n.editPreset),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: l10n.presetName,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.initialTime,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '$initialMinutes min',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: initialMinutes.toDouble(),
                          min: 1,
                          max: 120,
                          divisions: 119,
                          onChanged: (value) {
                            setDialogState(() {
                              initialMinutes = value.toInt();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.increment,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                incrementSeconds == 0 ? 'Nenhum' : '+$incrementSeconds s',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: incrementSeconds.toDouble(),
                          min: 0,
                          max: 30,
                          divisions: 30,
                          onChanged: (value) {
                            setDialogState(() {
                              incrementSeconds = value.toInt();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;

                final preset = ChessTimePreset.custom(
                  id: initialPreset?.id ?? 'custom_${DateTime.now().millisecondsSinceEpoch}',
                  customName: name,
                  initialTime: Duration(minutes: initialMinutes),
                  increment: Duration(seconds: incrementSeconds),
                );

                await presetService.saveCustomPreset(preset);
                
                if (mounted) {
                  Navigator.pop(context);
                  setState(() {});
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(initialPreset == null 
                          ? '${l10n.presetCreated}: $name'
                          : '${l10n.presetUpdated}: $name'),
                    ),
                  );
                }
              },
              child: Text(initialPreset == null ? l10n.create : l10n.save),
            ),
          ],
        ),
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
