import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'statistics_service.dart';

class AppReviewService {
  static const String _lastReviewMilestoneKey = 'last_review_milestone';
  
  // The exact milestones we agreed on
  static const List<int> reviewMilestones = [3, 10, 25];

  /// Checks the total games played and requests an app review if a milestone is reached.
  static Future<void> checkAndRequestReview() async {
    try {
      // Get total games played
      final results = await StatisticsService.getAllResults();
      final totalGames = results.length;
      
      // Look if the current game count matches one of our milestones
      if (reviewMilestones.contains(totalGames)) {
        final prefs = await SharedPreferences.getInstance();
        final lastMilestone = prefs.getInt(_lastReviewMilestoneKey) ?? 0;
        
        // Prevent calling it multiple times for the exact same milestone if tapped multiple times
        if (lastMilestone < totalGames) {
          debugPrint('AppReviewService: Milestone $totalGames reached! Requesting review...');
          
          final InAppReview inAppReview = InAppReview.instance;

          if (await inAppReview.isAvailable()) {
            await inAppReview.requestReview();
            // Save that we already asked at this specific milestone
            await prefs.setInt(_lastReviewMilestoneKey, totalGames);
            debugPrint('AppReviewService: Review requested successfully.');
          } else {
            debugPrint('AppReviewService: Review API not available on this device.');
          }
        }
      }
    } catch (e) {
      debugPrint('AppReviewService Error: $e');
    }
  }
}
