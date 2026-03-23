import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' as root_bundle;

/// Centralizer of secrets/IDs loaded from secrets.json or fallback to test defaults
/// Environment variables (--dart-define) can still override values.
class Secrets {
  static String _admobAppIdAndroid = '';
  static String _androidBannerAdUnitId = '';

  static bool _initialized = false;

  /// Initialize secrets from secrets.json if exists, otherwise use Google test defaults
  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Default to Google test IDs
    _admobAppIdAndroid = 'ca-app-pub-2940158495601484~6238811494';
    _androidBannerAdUnitId = 'ca-app-pub-2940158495601484/2541804401';

    // Try to load from secrets.json as asset (bundled in app)
    try {
      final content = await root_bundle.rootBundle.loadString('secrets.json');
      final json = jsonDecode(content);
      final admob = json['admob'];
      if (admob != null) {
        _admobAppIdAndroid = admob['appIdAndroid'] ?? _admobAppIdAndroid;
        _androidBannerAdUnitId = admob['bannerAdUnitIdAndroid'] ?? _androidBannerAdUnitId;
      }
    } catch (e) {
      // If not found, keep test defaults
    }

    // Override with environment variables if set (highest priority)
    final envAndroidAppId = const String.fromEnvironment('ADMOB_APP_ID_ANDROID');
    if (envAndroidAppId.isNotEmpty) _admobAppIdAndroid = envAndroidAppId;

    final envAndroidBanner = const String.fromEnvironment('ANDROID_BANNER_AD_UNIT_ID');
    if (envAndroidBanner.isNotEmpty) _androidBannerAdUnitId = envAndroidBanner;
  }

  static String get admobAppId {
    if (Platform.isAndroid) {
      return _admobAppIdAndroid;
    }
    return '';
  }

  // Banner Ad Unit IDs
  static String get androidBannerAdUnitId => _androidBannerAdUnitId;
}