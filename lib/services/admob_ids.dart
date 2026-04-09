import 'package:flutter/foundation.dart';

import 'ad_mode.dart';

class AdmobIds {
  // Google sample ad units (Android) — safe for debug / QA.
  static const String _testBanner = 'ca-app-pub-5408098781737794/4430049847';
  static const String _testAppOpen = 'ca-app-pub-5408098781737794/2580813955';
  static const String _testNative = 'ca-app-pub-5408098781737794/3919748102';
  static const String _testInterstitial =
      'ca-app-pub-5408098781737794/5232829779';

  /// Explicit Google test IDs for debug/QA only.
  /// In production, IDs should come from Remote Config (or the production constants below).
  static String bannerTestUnitId() => _testBanner;
  static String appOpenTestUnitId() => _testAppOpen;
  static String nativeTestUnitId() => _testNative;
  static String interstitialTestUnitId() => _testInterstitial;

  static String bannerUnitId() {
    if (defaultTargetPlatform != TargetPlatform.android) return '';
    // Production IDs must come from Remote Config; no fallback here.
    return AdMode.useTestAds ? _testBanner : '';
  }

  static String appOpenUnitId() {
    if (defaultTargetPlatform != TargetPlatform.android) return '';
    // Production IDs must come from Remote Config; no fallback here.
    return AdMode.useTestAds ? _testAppOpen : '';
  }

  static String nativeUnitId() {
    if (defaultTargetPlatform != TargetPlatform.android) return '';
    // Production IDs must come from Remote Config; no fallback here.
    return AdMode.useTestAds ? _testNative : '';
  }

  static String interstitialUnitId() {
    if (defaultTargetPlatform != TargetPlatform.android) return '';
    // Production IDs must come from Remote Config; no fallback here.
    return AdMode.useTestAds ? _testInterstitial : '';
  }
}
