import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import 'remote_config_keys.dart';

class RemoteConfigService extends ChangeNotifier {
  RemoteConfigService._();
  static final RemoteConfigService instance = RemoteConfigService._();

  FirebaseRemoteConfig get _rc => FirebaseRemoteConfig.instance;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// Defaults: birthday flags, **production** IDs, and Google **test** IDs (same as [AdmobIds]).
  static const Map<String, dynamic> defaults = <String, dynamic>{
    RemoteConfigKeys.tattooBirthdayAdsAll: true,
    RemoteConfigKeys.tattooBirthdayBanner: true,
    RemoteConfigKeys.tattooBirthdayNative: true,
    // Production (Android)
    RemoteConfigKeys.admobAndroidBanner:
        'ca-app-pub-5408098781737794/4430049847',
    RemoteConfigKeys.admobAndroidNative:
        'ca-app-pub-5408098781737794/3919748102',
    RemoteConfigKeys.admobAndroidAppOpen:
        'ca-app-pub-5408098781737794/4589831949',
    RemoteConfigKeys.admobAndroidInterstitial:
        'ca-app-pub-5408098781737794/5232829779',
    // Google sample test units (Android) — debug / QA
    RemoteConfigKeys.admobAndroidBannerTest:
        'ca-app-pub-3940256099942544/6300978111',
    RemoteConfigKeys.admobAndroidNativeTest:
        'ca-app-pub-3940256099942544/2247696110',
    RemoteConfigKeys.admobAndroidAppOpenTest:
        'ca-app-pub-3940256099942544/3419835294',
    RemoteConfigKeys.admobAndroidInterstitialTest:
        'ca-app-pub-3940256099942544/1044960115',
  };

  Future<void> initialize() async {
    if (_initialized) return;

    await _rc.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 12),
        minimumFetchInterval: kDebugMode
            ? Duration.zero
            : const Duration(hours: 1),
      ),
    );

    await _rc.setDefaults(defaults);

    try {
      await _rc.fetchAndActivate();
    } catch (e, st) {
      debugPrint('[RemoteConfigService] fetchAndActivate failed: $e\n$st');
    }

    _initialized = true;
    notifyListeners();
  }

  /// Master: `false` ⇒ no banner and no native on birthday screen.
  bool get tattooBirthdayAdsAll =>
      _rc.getBool(RemoteConfigKeys.tattooBirthdayAdsAll);

  bool get tattooBirthdayShowBanner =>
      tattooBirthdayAdsAll &&
      _rc.getBool(RemoteConfigKeys.tattooBirthdayBanner);

  bool get tattooBirthdayShowNative =>
      tattooBirthdayAdsAll &&
      _rc.getBool(RemoteConfigKeys.tattooBirthdayNative);

  /// Trimmed AdMob unit id from Remote Config, or empty if missing (caller uses code fallback).
  String _admobString(String key) => _rc.getString(key).trim();

  String get admobAndroidBannerUnitId =>
      _admobString(RemoteConfigKeys.admobAndroidBanner);

  String get admobAndroidNativeUnitId =>
      _admobString(RemoteConfigKeys.admobAndroidNative);

  String get admobAndroidAppOpenUnitId =>
      _admobString(RemoteConfigKeys.admobAndroidAppOpen);

  String get admobAndroidInterstitialUnitId =>
      _admobString(RemoteConfigKeys.admobAndroidInterstitial);

  String get admobAndroidBannerTestUnitId =>
      _admobString(RemoteConfigKeys.admobAndroidBannerTest);

  String get admobAndroidNativeTestUnitId =>
      _admobString(RemoteConfigKeys.admobAndroidNativeTest);

  String get admobAndroidAppOpenTestUnitId =>
      _admobString(RemoteConfigKeys.admobAndroidAppOpenTest);

  String get admobAndroidInterstitialTestUnitId =>
      _admobString(RemoteConfigKeys.admobAndroidInterstitialTest);
}
