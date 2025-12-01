import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

class AdMobService {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isBannerAdReady = false;
  bool _isInterstitialAdReady = false;

  Future<void> initialize() async {
    try {
      // AdMob doesn't work on web
      if (kIsWeb) {
        if (kDebugMode) {
          debugPrint('AdMob skipped on web platform');
        }
        return;
      }
      await MobileAds.instance.initialize();
      if (kDebugMode) {
        debugPrint('AdMob initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AdMob initialization failed: $e');
      }
      // Continue without AdMob
    }
  }

  BannerAd? get bannerAd => _bannerAd;
  bool get isBannerAdReady => _isBannerAdReady;

  void loadBannerAd({
    required AdSize adSize,
    void Function(Ad)? onAdLoaded,
    void Function(LoadAdError)? onAdFailedToLoad,
  }) {
    _bannerAd = BannerAd(
      adUnitId: AppConfig.admobBannerId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isBannerAdReady = true;
          onAdLoaded?.call(_bannerAd!);
          if (kDebugMode) {
            debugPrint('Banner ad loaded');
          }
        },
        onAdFailedToLoad: (ad, error) {
          _isBannerAdReady = false;
          ad.dispose();
          onAdFailedToLoad?.call(error);
          if (kDebugMode) {
            debugPrint('Banner ad failed to load: $error');
          }
        },
        onAdOpened: (_) {
          if (kDebugMode) {
            debugPrint('Banner ad opened');
          }
        },
        onAdClosed: (_) {
          if (kDebugMode) {
            debugPrint('Banner ad closed');
          }
        },
      ),
    );

    _bannerAd?.load();
  }

  void loadInterstitialAd({
    void Function(InterstitialAd)? onAdLoaded,
    void Function(LoadAdError)? onAdFailedToLoad,
  }) {
    InterstitialAd.load(
      adUnitId: AppConfig.admobInterstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          onAdLoaded?.call(ad);
          if (kDebugMode) {
            debugPrint('Interstitial ad loaded');
          }
        },
        onAdFailedToLoad: (error) {
          _isInterstitialAdReady = false;
          onAdFailedToLoad?.call(error);
          if (kDebugMode) {
            debugPrint('Interstitial ad failed to load: $error');
          }
        },
      ),
    );
  }

  void showInterstitialAd({
    void Function()? onAdDismissed,
    void Function(Ad)? onAdFailedToShow,
  }) {
    if (_interstitialAd != null && _isInterstitialAdReady) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          onAdDismissed?.call();
          // Load next ad
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          onAdFailedToShow?.call(ad);
        },
      );
      _interstitialAd!.show();
    }
  }

  void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerAdReady = false;
  }

  void disposeInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdReady = false;
  }

  void dispose() {
    disposeBannerAd();
    disposeInterstitialAd();
  }
}

