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
    // Boolean feature flags — FOR NOW default ON (can be overridden in Firebase).
    RemoteConfigKeys.tattooBirthdayAdsAll: true,
    RemoteConfigKeys.tattooBirthdayBanner: true,
    RemoteConfigKeys.tattooBirthdayNative: true,
    RemoteConfigKeys.tattooIdeaAdsAll: true,
    RemoteConfigKeys.tattooIdeaBanner: true,
    RemoteConfigKeys.tattooIdeaNative: true,
    RemoteConfigKeys.tattooStyleSelectionAdsAll: true,
    RemoteConfigKeys.tattooStyleSelectionBanner: true,
    RemoteConfigKeys.tattooStyleSelectionNative: true,
    // Production (Android)
    RemoteConfigKeys.admobAndroidBanner:
        'ca-app-pub-5408098781737794/4430049847',
    RemoteConfigKeys.admobAndroidNative:
        'ca-app-pub-5408098781737794/3919748102',
    RemoteConfigKeys.admobAndroidAppOpen:
        'ca-app-pub-5408098781737794/2580813955',
    RemoteConfigKeys.admobAndroidInterstitial:
        'ca-app-pub-5408098781737794/5232829779',
    // Google sample test units (Android) — debug / QA
    RemoteConfigKeys.admobAndroidBannerTest:
        'ca-app-pub-3940256099942544/6300978111',
    RemoteConfigKeys.admobAndroidNativeTest:
        'ca-app-pub-3940256099942544/2247696110',
    RemoteConfigKeys.admobAndroidAppOpenTest:
        // Use the official Google demo App Open unit that works reliably in debug.
        // (Some AdMob sample IDs can fail with "doesn't match format" depending on setup.)
        'ca-app-pub-3940256099942544/9257395921',
    RemoteConfigKeys.admobAndroidInterstitialTest:
        'ca-app-pub-3940256099942544/1033173712',

    // Splash screen ad/text toggles.
    // FOR NOW default ON (can be overridden in Firebase).
    RemoteConfigKeys.splashAdsAndTextEnabled: true,
    // App Open has priority on splash (interstitial can be enabled via Firebase).
    RemoteConfigKeys.splashShowInterstitial: false,
    RemoteConfigKeys.splashShowAppOpen: true,

    RemoteConfigKeys.firstLanguageOnboardingEnabled: true,
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

  /// Master: `false` ⇒ no banner and no native on tattoo idea (step 4) screen.
  bool get tattooIdeaAdsAll => _rc.getBool(RemoteConfigKeys.tattooIdeaAdsAll);

  bool get tattooIdeaShowBanner =>
      tattooIdeaAdsAll && _rc.getBool(RemoteConfigKeys.tattooIdeaBanner);

  bool get tattooIdeaShowNative =>
      tattooIdeaAdsAll && _rc.getBool(RemoteConfigKeys.tattooIdeaNative);

  /// Master: `false` ⇒ no banner and no native on style selection (last) step.
  bool get tattooStyleSelectionAdsAll =>
      _rc.getBool(RemoteConfigKeys.tattooStyleSelectionAdsAll);

  bool get tattooStyleSelectionShowBanner =>
      tattooStyleSelectionAdsAll &&
      _rc.getBool(RemoteConfigKeys.tattooStyleSelectionBanner);

  bool get tattooStyleSelectionShowNative =>
      tattooStyleSelectionAdsAll &&
      _rc.getBool(RemoteConfigKeys.tattooStyleSelectionNative);

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

  bool get splashAdsAndTextEnabled =>
      _rc.getBool(RemoteConfigKeys.splashAdsAndTextEnabled);

  bool get splashShowInterstitial =>
      splashAdsAndTextEnabled &&
      _rc.getBool(RemoteConfigKeys.splashShowInterstitial);

  bool get splashShowAppOpen =>
      splashAdsAndTextEnabled &&
      _rc.getBool(RemoteConfigKeys.splashShowAppOpen);

  /// When `false`, skip the first language selection onboarding screen and go
  /// directly to the main onboarding flow.
  bool get firstLanguageOnboardingEnabled =>
      _rc.getBool(RemoteConfigKeys.firstLanguageOnboardingEnabled);
}
