import 'package:flutter/foundation.dart';

import 'ad_mode.dart';

class AdmobIds {
  // Production (Android).
  static const String _prodAndroidAppOpen =
      'ca-app-pub-5408098781737794/4589831949';
  static const String _prodAndroidBanner =
      'ca-app-pub-5408098781737794/4430049847';
  static const String _prodAndroidInterstitial =
      'ca-app-pub-5408098781737794/5232829779';
  // NOTE: Add your production rewarded unit here when available.
  static const String _prodAndroidRewarded = '';
  static const String _prodAndroidNative =
      'ca-app-pub-5408098781737794/3919748102';

  // Google sample units — debug / `FORCE_TEST_ADS` only.
  static const String _testAndroidBanner =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testAndroidCollapsibleBanner =
      'ca-app-pub-3940256099942544/2014213617';
  static const String _testAndroidNative =
      'ca-app-pub-3940256099942544/2247696110';
  static const String _testAndroidAppOpen =
      'ca-app-pub-3940256099942544/9257395921';
  static const String _testAndroidInterstitial =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testAndroidRewarded =
      'ca-app-pub-3940256099942544/5224354917';

  static bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get _isIos => defaultTargetPlatform == TargetPlatform.iOS;

  static String _pick({
    required String androidProd,
    required String androidTest,
  }) {
    if (!_isAndroid && !_isIos) return '';
    return AdMode.useTestAds ? androidTest : androidProd;
  }

  static String bannerUnitId() =>
      _pick(androidProd: _prodAndroidBanner, androidTest: _testAndroidBanner);

  static String collapsibleBannerUnitId() => _pick(
    androidProd: _prodAndroidBanner,
    androidTest: _testAndroidCollapsibleBanner,
  );

  static String nativeUnitId() =>
      _pick(androidProd: _prodAndroidNative, androidTest: _testAndroidNative);

  static String appOpenUnitId() =>
      _pick(androidProd: _prodAndroidAppOpen, androidTest: _testAndroidAppOpen);

  static String interstitialUnitId() => _pick(
    androidProd: _prodAndroidInterstitial,
    androidTest: _testAndroidInterstitial,
  );

  static String rewardedUnitId() => _pick(
    androidProd: _prodAndroidRewarded,
    androidTest: _testAndroidRewarded,
  );
}
