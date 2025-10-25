import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/ad_config.dart';
import '../l10n/app_localizations.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  // Banner ad ID - using centralized configuration
  String get _bannerAdUnitId {
    return AdConfig.currentBannerAdUnitId; // Uses test or production as configured
  }

  @override
  void initState() {
    super.initState();
    debugPrint('BannerAdWidget initState called');
    debugPrint('Platform supported: ${AdConfig.isAdSupportedPlatform}');
    debugPrint('Using test ads: ${AdConfig.useTestAds}');
    debugPrint('Ad Unit ID: ${AdConfig.currentBannerAdUnitId}');
    
    // Only loads ads on supported platforms
    if (AdConfig.isAdSupportedPlatform) {
      _loadBannerAd();
    } else {
      debugPrint('Platform not supported for ads');
    }
  }

  void _loadBannerAd() {
    debugPrint('Loading banner ad with ID: $_bannerAdUnitId');
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner, // 320x50
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('✅ Banner Ad loaded successfully');
          if (mounted) {
            setState(() {
              _isBannerAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ Banner ad failed to load: ${error.message}');
          debugPrint('Error code: ${error.code}');
          debugPrint('Error domain: ${error.domain}');
          ad.dispose();
          if (mounted) {
            setState(() {
              _isBannerAdLoaded = false;
            });
          }
        },
        onAdOpened: (ad) {
          debugPrint('Banner ad opened');
        },
        onAdClosed: (ad) {
          debugPrint('Banner ad closed');
        },
        onAdClicked: (ad) {
          debugPrint('Banner ad clicked');
        },
      ),
      request: const AdRequest(),
    );

    _bannerAd!.load();
    debugPrint('Banner ad load() called');
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // If platform does not support ads, returns empty
    if (!AdConfig.isAdSupportedPlatform) {
      return const SizedBox.shrink();
    }
    
    if (!_isBannerAdLoaded || _bannerAd == null) {
      return Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!, width: 0.5),
        ),
        child: Center(
          child: Text(
            l10n.loadingAd,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}