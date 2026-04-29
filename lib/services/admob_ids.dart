import 'package:flutter/foundation.dart';

import 'ad_mode.dart';

class AdmobIds {
  // Production (Android).
static const String _prodAppOpen = 'ca-app-pub-5408098781737794/4589831949';
  static const String _prodBanner = 'ca-app-pub-5408098781737794/4430049847';
  static const String _prodInterstitial ='ca-app-pub-5408098781737794/5232829779';
  static const String _prodNative = 'ca-app-pub-5408098781737794/3919748102';

  // Google sample units (Android) — debug / `FORCE_TEST_ADS` only.
  static const String _testBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testNative = 'ca-app-pub-3940256099942544/2247696110';
  static const String _testAppOpen = 'ca-app-pub-3940256099942544/9257395921';
  static const String _testInterstitial =
      'ca-app-pub-3940256099942544/1033173712';

  static String _pick({required String prod, required String test}) {
    if (defaultTargetPlatform != TargetPlatform.android) return '';
    return AdMode.useTestAds ? test : prod;
  }

  static String bannerUnitId() => _pick(prod: _prodBanner, test: _testBanner);

  static String nativeUnitId() => _pick(prod: _prodNative, test: _testNative);

  static String appOpenUnitId() =>
      _pick(prod: _prodAppOpen, test: _testAppOpen);

  static String interstitialUnitId() =>
      _pick(prod: _prodInterstitial, test: _testInterstitial);
}
