import 'dart:io';
import 'dart:convert';

/// Centralizer of secrets/IDs loaded from secrets.json or fallback to test defaults
/// Environment variables (--dart-define) can still override values.
class Secrets {
  static String _admobAppIdAndroid = '';
  static String _admobAppIdIos = '';
  static String _androidNativeAdUnitId = '';
  static String _iosNativeAdUnitId = '';
  static String _androidBannerAdUnitId = '';
  static String _iosBannerAdUnitId = '';

  static bool _initialized = false;

  /// Initialize secrets from secrets.json if exists, otherwise use Google test defaults
  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Default to Google test IDs
    _admobAppIdAndroid = 'ca-app-pub-3940256099942544~3347511713';
    _admobAppIdIos = 'ca-app-pub-3940256099942544~1458002511';
    _androidNativeAdUnitId = 'ca-app-pub-3940256099942544/2247696110';
    _iosNativeAdUnitId = 'ca-app-pub-3940256099942544/3986624511';
    _androidBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
    _iosBannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716';

    // Try to load from secrets.json
    final secretsFile = File('secrets.json');
    if (await secretsFile.exists()) {
      try {
        final content = await secretsFile.readAsString();
        final json = jsonDecode(content);
        final admob = json['admob'];
        if (admob != null) {
          _admobAppIdAndroid = admob['appIdAndroid'] ?? _admobAppIdAndroid;
          _admobAppIdIos = admob['appIdIos'] ?? _admobAppIdIos;
          _androidNativeAdUnitId = admob['nativeAdUnitIdAndroid'] ?? _androidNativeAdUnitId;
          _iosNativeAdUnitId = admob['nativeAdUnitIdIos'] ?? _iosNativeAdUnitId;
          _androidBannerAdUnitId = admob['bannerAdUnitIdAndroid'] ?? _androidBannerAdUnitId;
          _iosBannerAdUnitId = admob['bannerAdUnitIdIos'] ?? _iosBannerAdUnitId;
        }
      } catch (e) {
        // If JSON is invalid, keep test defaults
      }
    }

    // Override with environment variables if set (highest priority)
    final envAndroidAppId = const String.fromEnvironment('ADMOB_APP_ID_ANDROID');
    if (envAndroidAppId.isNotEmpty) _admobAppIdAndroid = envAndroidAppId;

    final envIosAppId = const String.fromEnvironment('ADMOB_APP_ID_IOS');
    if (envIosAppId.isNotEmpty) _admobAppIdIos = envIosAppId;

    final envAndroidNative = const String.fromEnvironment('ANDROID_NATIVE_AD_UNIT_ID');
    if (envAndroidNative.isNotEmpty) _androidNativeAdUnitId = envAndroidNative;

    final envIosNative = const String.fromEnvironment('IOS_NATIVE_AD_UNIT_ID');
    if (envIosNative.isNotEmpty) _iosNativeAdUnitId = envIosNative;

    final envAndroidBanner = const String.fromEnvironment('ANDROID_BANNER_AD_UNIT_ID');
    if (envAndroidBanner.isNotEmpty) _androidBannerAdUnitId = envAndroidBanner;

    final envIosBanner = const String.fromEnvironment('IOS_BANNER_AD_UNIT_ID');
    if (envIosBanner.isNotEmpty) _iosBannerAdUnitId = envIosBanner;
  }

  static String get admobAppId {
    if (Platform.isAndroid) {
      return _admobAppIdAndroid;
    } else if (Platform.isIOS) {
      return _admobAppIdIos;
    }
    return '';
  }

  // Native Ad Unit IDs
  static String get androidNativeAdUnitId => _androidNativeAdUnitId;

  static String get iosNativeAdUnitId => _iosNativeAdUnitId;

  // Banner Ad Unit IDs
  static String get androidBannerAdUnitId => _androidBannerAdUnitId;

  static String get iosBannerAdUnitId => _iosBannerAdUnitId;
}