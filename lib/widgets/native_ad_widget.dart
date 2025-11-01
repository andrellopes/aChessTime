import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/ad_config.dart';
import '../services/ad_service.dart';
import '../l10n/app_localizations.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({super.key});

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  // Uses centralized configuration
  final String _adUnitId = AdConfig.currentNativeAdUnitId;

  @override
  void initState() {
    super.initState();
    // Only loads ads on supported platforms
    if (AdConfig.isAdSupportedPlatform) {
      _loadAd();
    }
  }

  void _loadAd() {
    // First try to use preloaded ad
    final preloadedAd = AdService.getPreloadedNativeAd();
    if (preloadedAd != null) {
      if (mounted) {
        setState(() {
          _nativeAd = preloadedAd;
          _nativeAdIsLoaded = true;
        });
      }
      return;
    }

    // If no preloaded ad, load a new one
    _nativeAd = NativeAd(
      adUnitId: _adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('Native Ad loaded successfully');
          if (mounted) {
            setState(() {
              _nativeAdIsLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Native ad failed to load: ${error.message}');
          ad.dispose();
          if (mounted) {
            setState(() {
              _nativeAdIsLoaded = false;
            });
          }
        },
        onAdOpened: (ad) {
          debugPrint('Native ad opened');
        },
        onAdClosed: (ad) {
          debugPrint('Native ad closed');
        },
        onAdClicked: (ad) {
          debugPrint('Native ad clicked');
        },
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

    _nativeAd!.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If platform does not support ads, returns empty
    if (!AdConfig.isAdSupportedPlatform) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!, width: 0.5),
      ),
      child: _nativeAdIsLoaded && _nativeAd != null
        ? AdWidget(ad: _nativeAd!)
        : Container(
            alignment: Alignment.center,
            height: 80,
            child: Text(
              AdService.hasPreloadedAd ? AppLocalizations.of(context)!.adReady : AppLocalizations.of(context)!.loadingAd,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
    );
  }
}
