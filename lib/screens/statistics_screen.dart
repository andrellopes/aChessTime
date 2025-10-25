import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/statistics_service.dart';
import '../services/purchase_service.dart';
import '../models/game_result.dart';
import '../widgets/banner_ad_widget.dart';
import '../services/chess_theme_manager.dart';
import '../l10n/app_localizations.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _summary;
  List<GameResult> _recentResults = [];
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadStatistics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStatistics() async {
    setState(() => _isLoading = true);
    
    try {
      final summary = await StatisticsService.getStatisticsSummary();
      final recent = await StatisticsService.getRecentResults(20);
      
      setState(() {
        _summary = summary;
        _recentResults = recent;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorLoadingStatisticsWithMessage(e.toString()))),
        );
      }
    }
  }

  Future<void> _clearStatistics() async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearStatistics),
        content: Text(l10n.clearStatisticsConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.deleteStatistics),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await StatisticsService.clearAllStatistics();
      _loadStatistics();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.statisticsCleared)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statisticsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStatistics,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _clearStatistics,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.generalSummary, icon: Icon(Icons.analytics)),
            Tab(text: l10n.recentGames, icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: Consumer<PurchaseService>(
        builder: (context, purchaseService, child) {
          debugPrint('StatisticsScreen: isProVersion = ${purchaseService.isProVersion}');
          return Column(
            children: [
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _summary == null
                        ? Center(child: Text(l10n.errorLoadingStatistics))
                        : TabBarView(
                            controller: _tabController,
                            children: [
                              _buildSummaryTab(),
                              _buildHistoryTab(),
                            ],
                          ),
              ),
              // Fixed banner at the bottom (only for non-Pro users)
              if (!purchaseService.isProVersion) ...[
                const BannerAdWidget(),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryTab() {
    return RefreshIndicator(
      onRefresh: _loadStatistics,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(),
            const SizedBox(height: 16),
            _buildTimeCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return RefreshIndicator(
      onRefresh: _loadStatistics,
      child: _recentResults.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noGamesFound,
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _recentResults.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final result = _recentResults[index];
                return _buildGameResultTile(result);
              },
            ),
    );
  }

  Widget _buildSummaryCards() {
    final l10n = AppLocalizations.of(context)!;
    
    if (_summary == null) return const SizedBox();
    
    final summary = _summary!;
    
    return Consumer<ChessThemeManager>(
      builder: (context, themeManager, child) {
        final currentTheme = themeManager.currentTheme;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    l10n.totalGames,
                    '${summary['totalGames']}',
                    Icons.sports_esports,
                    currentTheme.primary, // Using primary color of the theme
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    l10n.draws,
                    '${summary['draws']}',
                    Icons.handshake,
                    Colors.grey[600]!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Second line: White wins | Black wins
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    l10n.whiteWins,
                    '${summary['whiteWins']}',
                    Icons.circle_outlined,
                    currentTheme.whitePlayerColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    l10n.blackWins,
                    '${summary['blackWins']}',
                    Icons.circle,
                    currentTheme.blackPlayerColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    l10n.timeoutGames,
                    '${summary['timeoutGames']}',
                    Icons.timer_off,
                    currentTheme.criticalColor, // Using critical color of the theme for timeout
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    l10n.manualGames,
                    '${summary['manualGames']}',
                    Icons.flag,
                    currentTheme.secondary, // Using secondary color of the theme
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCards() {
    final l10n = AppLocalizations.of(context)!;
    
    if (_summary == null) return const SizedBox();
    
    final summary = _summary!;
    final totalPlayTime = summary['totalPlayTime'] as Duration;
    final avgGameDuration = summary['averageGameDuration'] as Duration;
    
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, size: 28, color: Colors.purple),
                  const SizedBox(height: 8),
                  Text(
                    _formatDuration(totalPlayTime),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.totalTime, 
                    style: const TextStyle(fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer, size: 28, color: Colors.teal),
                  const SizedBox(height: 8),
                  Text(
                    _formatDuration(avgGameDuration),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.averageDuration, 
                    style: const TextStyle(fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameResultTile(GameResult result) {
    final resultIcon = _getResultIcon(result);
    final resultText = _getResultText(result);
    final resultColor = _getResultColor(result);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: resultColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(resultIcon, color: resultColor, size: 20),
        ),
        title: Text(
          resultText,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${_formatDate(result.dateTime)} • ${_formatDuration(result.gameDuration)}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Consumer<ChessThemeManager>(
          builder: (context, themeManager, child) {
            final currentTheme = themeManager.currentTheme;
            return Text(
              '${result.whiteMoves}/${result.blackMoves}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: currentTheme.textSecondary,
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getResultIcon(GameResult result) {
    if (result.isDraw) return Icons.handshake;
    if (result.isTimeoutResult) return Icons.timer_off;
    return Icons.flag;
  }

  String _getResultText(GameResult result) {
    final l10n = AppLocalizations.of(context)!;
    
    if (result.isDraw) return l10n.draw;
    if (result.whiteWon) {
      return result.isTimeoutResult ? l10n.whiteWinsTimeout : l10n.whiteWinsManual;
    } else {
      return result.isTimeoutResult ? l10n.blackWinsTimeout : l10n.blackWinsManual;
    }
  }

  Color _getResultColor(GameResult result) {
    final themeManager = Provider.of<ChessThemeManager>(context, listen: false);
    final currentTheme = themeManager.currentTheme;
    
    if (result.isDraw) return Colors.grey[600]!;
    if (result.whiteWon) return currentTheme.whitePlayerColor;
    return currentTheme.blackPlayerColor;
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  String _formatDate(DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return '${l10n.today} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return '${l10n.yesterday} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${l10n.daysAgo}';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }
}