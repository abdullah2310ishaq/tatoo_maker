import 'package:flutter/foundation.dart';

class AdMode {
  /// Force test ads even in profile/release:
  /// `flutter run --dart-define=FORCE_TEST_ADS=true`
  static const bool forceTestAds =
      bool.fromEnvironment('FORCE_TEST_ADS', defaultValue: false);

  static bool get useTestAds => kDebugMode || forceTestAds;
}

