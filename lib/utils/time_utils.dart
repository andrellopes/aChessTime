class TimeUtils {
  /// Formats a duration in mm:ss format or ss.t (for low time)
  static String formatDuration(Duration duration) {
    // Ensures it doesn't show negative time if there's any delay
    if (duration.isNegative) return "00:00";

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    // Shows tenths of a second when time is less than 20 seconds
    if (duration.inSeconds < 20 && duration.inMinutes == 0) {
      final tenths = (duration.inMilliseconds.remainder(1000) ~/ 100).toString();
      return '$seconds.$tenths';
    }

    return '$minutes:$seconds';
  }

  /// Checks if it's low time (critical)
  static bool isLowTime(Duration duration) {
    return duration.inSeconds <= 20;
  }

  /// Checks if it's very low time (extreme critical)
  static bool isVeryLowTime(Duration duration) {
    return duration.inSeconds <= 10;
  }
}
