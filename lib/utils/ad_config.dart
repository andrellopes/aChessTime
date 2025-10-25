import 'dart:io';
import 'package:flutter/foundation.dart';
import '../secrets.dart';

class AdConfig {
  // AdMob Application ID (injected by --dart-define; fallback to test IDs)
  static String get appId => Secrets.admobAppId;
  
  // Native ad block ID for Settings
  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return Secrets.androidNativeAdUnitId;
    } else if (Platform.isIOS) {
      return Secrets.iosNativeAdUnitId;
    } else {
      // default non-mobile: use test ID
      return 'ca-app-pub-3940256099942544/2247696110';
    }
  }
  
  // Banner ad block ID
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return Secrets.androidBannerAdUnitId;
    } else if (Platform.isIOS) {
      return Secrets.iosBannerAdUnitId;
    } else {
      // default non-mobile: use test ID
      return 'ca-app-pub-3940256099942544/6300978111';
    }
  }
  
  // Test IDs for development
  static String get testNativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3986624511';
    } else {
      return 'ca-app-pub-3940256099942544/2247696110';
    }
  }
  
  // Test IDs for banner
  static String get testBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
  }
  
  // Use this flag to switch between test and production
  // In debug mode, always uses test ads
  static bool get useTestAds => kDebugMode;
  
  // Checks if the platform supports ads
  static bool get isAdSupportedPlatform {
    return Platform.isAndroid || Platform.isIOS;
  }
  
  static String get currentNativeAdUnitId {
    return useTestAds ? testNativeAdUnitId : nativeAdUnitId;
  }
  
  static String get currentBannerAdUnitId {
    return useTestAds ? testBannerAdUnitId : bannerAdUnitId;
  }
}
