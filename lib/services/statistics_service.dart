import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/game_result.dart';
import '../l10n/app_localizations.dart';

class StatisticsService {
  static const String _statisticsKey = 'game_statistics';
  
  // Save game result
  static Future<void> saveGameResult(GameResult result) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Fetch existing statistics
    final existingData = prefs.getString(_statisticsKey);
    List<GameResult> results = [];
    
    if (existingData != null) {
      final List<dynamic> jsonList = json.decode(existingData);
      results = jsonList.map((json) => GameResult.fromJson(json)).toList();
    }
    
    // Add new result
    results.add(result);
    
    // Keep only the last 1000 games to avoid excessive memory usage
    if (results.length > 1000) {
      results = results.sublist(results.length - 1000);
    }
    
    // Save back
    final jsonList = results.map((result) => result.toJson()).toList();
    await prefs.setString(_statisticsKey, json.encode(jsonList));
  }
  
  // Fetch all results
  static Future<List<GameResult>> getAllResults() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_statisticsKey);
    
    if (data == null) return [];
    
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => GameResult.fromJson(json)).toList();
  }
  
  // Clear all statistics
  static Future<void> clearAllStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_statisticsKey);
  }
  
  // Aggregated statistics
  static Future<Map<String, dynamic>> getStatisticsSummary() async {
    final results = await getAllResults();
    
    if (results.isEmpty) {
      return {
        'totalGames': 0,
        'whiteWins': 0,
        'blackWins': 0,
        'draws': 0,
        'timeoutGames': 0,
        'manualGames': 0,
        'averageGameDuration': Duration.zero,
        'totalPlayTime': Duration.zero,
        'winRate': {'white': 0.0, 'black': 0.0, 'draw': 0.0},
      };
    }
    
    final totalGames = results.length;
    final whiteWins = results.where((r) => r.whiteWon).length;
    final blackWins = results.where((r) => r.blackWon).length;
    final draws = results.where((r) => r.isDraw).length;
    final timeoutGames = results.where((r) => r.isTimeoutResult).length;
    final manualGames = results.where((r) => r.isManualResult).length;
    
    final totalPlayTime = results.fold<Duration>(
      Duration.zero,
      (sum, result) => sum + result.gameDuration,
    );
    
    final averageGameDuration = totalGames > 0 
        ? Duration(milliseconds: totalPlayTime.inMilliseconds ~/ totalGames)
        : Duration.zero;
    
    return {
      'totalGames': totalGames,
      'whiteWins': whiteWins,
      'blackWins': blackWins,
      'draws': draws,
      'timeoutGames': timeoutGames,
      'manualGames': manualGames,
      'averageGameDuration': averageGameDuration,
      'totalPlayTime': totalPlayTime,
      'winRate': {
        'white': totalGames > 0 ? (whiteWins / totalGames * 100) : 0.0,
        'black': totalGames > 0 ? (blackWins / totalGames * 100) : 0.0,
        'draw': totalGames > 0 ? (draws / totalGames * 100) : 0.0,
      },
    };
  }
  
  // Statistics by period
  static Future<Map<String, dynamic>> getStatisticsForPeriod(DateTime startDate, DateTime endDate) async {
    final allResults = await getAllResults();
    final periodResults = allResults.where((result) {
      return result.dateTime.isAfter(startDate) && result.dateTime.isBefore(endDate);
    }).toList();
    
    if (periodResults.isEmpty) {
      return {
        'totalGames': 0,
        'whiteWins': 0,
        'blackWins': 0,
        'draws': 0,
        'results': <GameResult>[],
      };
    }
    
    return {
      'totalGames': periodResults.length,
      'whiteWins': periodResults.where((r) => r.whiteWon).length,
      'blackWins': periodResults.where((r) => r.blackWon).length,
      'draws': periodResults.where((r) => r.isDraw).length,
      'results': periodResults,
    };
  }
  
  // Recent statistics (last X games)
  static Future<List<GameResult>> getRecentResults([int count = 10]) async {
    final allResults = await getAllResults();
    allResults.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    
    return allResults.take(count).toList();
  }

  // Export statistics to CSV
  static Future<String?> exportStatisticsToCSV(BuildContext context) async {
    try {
      final results = await getAllResults();

      if (results.isEmpty) {
        return null;
      }

      final l10n = AppLocalizations.of(context)!;

      final csvHeader = '${l10n.csvHeader}\n';

      final csvData = results.map((result) {
        final dateTime = result.dateTime.toIso8601String();
        final resultType = result.resultType;
        final winner = result.winner ?? '';
        final gameDuration = result.gameDuration.inSeconds;
        final whiteTimeRemaining = result.whiteTimeRemaining.inSeconds;
        final blackTimeRemaining = result.blackTimeRemaining.inSeconds;
        final whiteMoves = result.whiteMoves;
        final blackMoves = result.blackMoves;
        final initialTime = result.initialTime.inSeconds;
        final increment = result.increment.inSeconds;

        return '$dateTime,$resultType,$winner,$gameDuration,$whiteTimeRemaining,$blackTimeRemaining,$whiteMoves,$blackMoves,$initialTime,$increment';
      }).join('\n');

      final csvContent = csvHeader + csvData;

      // Save temporary file
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/chess_stats_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File(filePath);
      await file.writeAsString(csvContent);

      return filePath;
    } catch (e) {
      print('Erro ao exportar estatísticas para CSV: $e');
      return null;
    }
  }

  // Share statistics in CSV
  static Future<bool> shareStatisticsCSV(BuildContext context) async {
    final filePath = await exportStatisticsToCSV(context);
    if (filePath == null) return false;

    final l10n = AppLocalizations.of(context)!;

    try {
      await Share.shareXFiles(
        [XFile(filePath)],
        text: l10n.exportCsvShareText,
        subject: l10n.exportCsvShareSubject,
      );
      return true;
    } catch (e) {
      print('Erro ao compartilhar estatísticas CSV: $e');
      return false;
    }
  }
}