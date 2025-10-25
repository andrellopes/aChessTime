import 'dart:io';

/// Centralizer of secrets/IDs injected by --dart-define
/// Provides test defaults when there are no real values.
class Secrets {
  static String get admobAppId {
    if (Platform.isAndroid) {
      const v = String.fromEnvironment('ADMOB_APP_ID_ANDROID');
      return v.isNotEmpty ? v : 'ca-app-pub-3940256099942544~3347511713';
    } else if (Platform.isIOS) {
      const v = String.fromEnvironment('ADMOB_APP_ID_IOS');
      return v.isNotEmpty ? v : 'ca-app-pub-3940256099942544~1458002511';
    }
    return '';
  }

  // Native Ad Unit IDs
  static String get androidNativeAdUnitId => const String.fromEnvironment(
        'ANDROID_NATIVE_AD_UNIT_ID',
        defaultValue: 'ca-app-pub-3940256099942544/2247696110',
      );

  static String get iosNativeAdUnitId => const String.fromEnvironment(
        'IOS_NATIVE_AD_UNIT_ID',
        defaultValue: 'ca-app-pub-3940256099942544/3986624511',
      );

  // Banner Ad Unit IDs
  static String get androidBannerAdUnitId => const String.fromEnvironment(
        'ANDROID_BANNER_AD_UNIT_ID',
        defaultValue: 'ca-app-pub-3940256099942544/6300978111',
      );

  static String get iosBannerAdUnitId => const String.fromEnvironment(
        'IOS_BANNER_AD_UNIT_ID',
        defaultValue: 'ca-app-pub-3940256099942544/2934735716',
      );
}