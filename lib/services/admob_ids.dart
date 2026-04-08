import 'package:flutter/foundation.dart';

class AdmobIds {
  // Google sample ad units (Android) — safe for debug / QA.
  static const String _testBanner = 'ca-app-pub-3940256099942544/6300978111';
  // Official Google demo unit for App Open (Android).
  // Ref: https://developers.google.com/admob/android/app-open
  static const String _testAppOpen = 'ca-app-pub-3940256099942544/9257395921';
  static const String _testNative = 'ca-app-pub-3940256099942544/2247696110';
  static const String _testInterstitial = 'ca-app-pub-3940256099942544/1033173712';

  // Production ad units (Android) — provided by you.
  static const String _prodBanner = 'ca-app-pub-5408098781737794/4430049847';
  static const String _prodAppOpen = 'ca-app-pub-5408098781737794/2580813955';
  static const String _prodNative = 'ca-app-pub-5408098781737794/3919748102';
  static const String _prodInterstitial = 'ca-app-pub-5408098781737794/5232829779';

  /// Explicit test IDs for runtime fallback when Remote Config misconfigures IDs.
  static String bannerTestUnitId() => _testBanner;
  static String appOpenTestUnitId() => _testAppOpen;
  static String nativeTestUnitId() => _testNative;
  static String interstitialTestUnitId() => _testInterstitial;

  static String bannerUnitId() {
    if (defaultTargetPlatform != TargetPlatform.android) return '';
    return kDebugMode ? _testBanner : _prodBanner;
  }

  static String appOpenUnitId() {
    if (defaultTargetPlatform != TargetPlatform.android) return '';
    return kDebugMode ? _testAppOpen : _prodAppOpen;
  }

  static String nativeUnitId() {
    if (defaultTargetPlatform != TargetPlatform.android) return '';
    return kDebugMode ? _testNative : _prodNative;
  }

  static String interstitialUnitId() {
    if (defaultTargetPlatform != TargetPlatform.android) return '';
    return kDebugMode ? _testInterstitial : _prodInterstitial;
  }

}
