import 'package:flutter/foundation.dart';

class AdmobIds {
  // Provided in `ads.md`.
  static const String _prodBannerAndroid = 'ca-app-pub-5408098781737794/4430049847';
  static const String _prodBannerIos = 'ca-app-pub-5408098781737794/4430049847';
  static const String _prodAppOpenAndroid = 'ca-app-pub-5408098781737794/4589831949';
  static const String _prodAppOpenIos = 'ca-app-pub-5408098781737794/4589831949';

  // Official AdMob test IDs (safe for development).
  static const String _testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerIos = 'ca-app-pub-3940256099942544/2934735716';
  static const String _testAppOpenAndroid = 'ca-app-pub-3940256099942544/3419835294';
  static const String _testAppOpenIos = 'ca-app-pub-3940256099942544/5662855259';

  static String bannerUnitId() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return kDebugMode ? _testBannerIos : _prodBannerIos;
      case TargetPlatform.android:
        return kDebugMode ? _testBannerAndroid : _prodBannerAndroid;
      default:
        // Ads are not supported on desktop/web in this app.
        return '';
    }
  }

  static String appOpenUnitId() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return kDebugMode ? _testAppOpenIos : _prodAppOpenIos;
      case TargetPlatform.android:
        return kDebugMode ? _testAppOpenAndroid : _prodAppOpenAndroid;
      default:
        return '';
    }
  }
}

