import 'package:flutter/foundation.dart';

import 'remote_config_service.dart';

/// AdMob unit IDs for **Android only** (this app does not ship on iOS).
///
/// **Release / profile:** production IDs from Remote Config when initialized, else compile-time prod.
/// **Debug:** always Google sample **test** IDs (Remote Config test overrides disabled for stability).
class AdmobIds {
  // Production — from `admob_ids.md` / AdMob (Android).
  static const String _prodBanner = 'ca-app-pub-5408098781737794/4430049847';
  static const String _prodAppOpen = 'ca-app-pub-5408098781737794/4589831949';
  static const String _prodNative = 'ca-app-pub-5408098781737794/3919748102';
  static const String _prodInterstitial = 'ca-app-pub-5408098781737794/5232829779';

  // Google sample ad units (Android) — use in debug builds only.
  static const String _testBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testAppOpen = 'ca-app-pub-3940256099942544/3419835294';
  static const String _testNative = 'ca-app-pub-3940256099942544/2247696110'; 
  static const String _testInterstitial = 'ca-app-pub-3940256099942544/1033173712';

  static String bannerUnitId() {
    if (defaultTargetPlatform != TargetPlatform.android) return '';
    if (kDebugMode) {
      return _testBanner;
    }
    final o = _rcBanner();
    return o.isNotEmpty ? o : _prodBanner;
  }

  static String appOpenUnitId() {
    if (defaultTargetPlatform != TargetPlatform.android) return '';
    if (kDebugMode) {
      return _testAppOpen;
    }
    final o = _rcAppOpen();
    return o.isNotEmpty ? o : _prodAppOpen;
  }

  static String nativeUnitId() {
    if (defaultTargetPlatform != TargetPlatform.android) return '';
    if (kDebugMode) {
      return _testNative;
    }
    final o = _rcNative();
    return o.isNotEmpty ? o : _prodNative;
  }

  static String interstitialUnitId() {
    if (defaultTargetPlatform != TargetPlatform.android) return '';
    if (kDebugMode) {
      return _testInterstitial;
    }
    final o = _rcInterstitial();
    return o.isNotEmpty ? o : _prodInterstitial;
  }

  static String _rcBanner() {
    if (!RemoteConfigService.instance.isInitialized) return '';
    return RemoteConfigService.instance.admobAndroidBannerUnitId;
  }

  static String _rcNative() {
    if (!RemoteConfigService.instance.isInitialized) return '';
    return RemoteConfigService.instance.admobAndroidNativeUnitId;
  }

  static String _rcAppOpen() {
    if (!RemoteConfigService.instance.isInitialized) return '';
    return RemoteConfigService.instance.admobAndroidAppOpenUnitId;
  }

  static String _rcInterstitial() {
    if (!RemoteConfigService.instance.isInitialized) return '';
    return RemoteConfigService.instance.admobAndroidInterstitialUnitId;
  }

}
