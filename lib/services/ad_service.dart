import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/ad_config.dart';

class AdService {
  static NativeAd? _preloadedNativeAd;
  static bool _isPreloadedAdLoaded = false;

  /// Initialize and preload ads when app starts
  static Future<void> init() async {
    if (!AdConfig.isAdSupportedPlatform) return;

    // Preload native ad for menu screens
    await _preloadNativeAd();
  }

  static Future<void> _preloadNativeAd() async {
    final adUnitId = AdConfig.currentNativeAdUnitId;

    _preloadedNativeAd = NativeAd(
      adUnitId: adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('Preloaded Native Ad loaded successfully');
          _isPreloadedAdLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Preloaded Native ad failed to load: ${error.message}');
          ad.dispose();
          _isPreloadedAdLoaded = false;
          // Try to reload after some time
          Future.delayed(const Duration(seconds: 30), _preloadNativeAd);
        },
        onAdOpened: (ad) => debugPrint('Preloaded Native ad opened'),
        onAdClosed: (ad) => debugPrint('Preloaded Native ad closed'),
        onAdClicked: (ad) => debugPrint('Preloaded Native ad clicked'),
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: Colors.white,
        cornerRadius: 12.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: Colors.blue,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black87,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 14.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black54,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 12.0,
        ),
      ),
    );

    await _preloadedNativeAd!.load();
  }

  /// Get the preloaded native ad, or null if not loaded
  static NativeAd? getPreloadedNativeAd() {
    if (_isPreloadedAdLoaded && _preloadedNativeAd != null) {
      final ad = _preloadedNativeAd;
      _preloadedNativeAd = null; // Consume the ad
      _isPreloadedAdLoaded = false;
      // Start loading a new one
      _preloadNativeAd();
      return ad;
    }
    return null;
  }

  /// Check if preloaded ad is available
  static bool get hasPreloadedAd => _isPreloadedAdLoaded && _preloadedNativeAd != null;
}