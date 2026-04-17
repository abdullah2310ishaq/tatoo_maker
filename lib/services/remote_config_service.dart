import 'dart:developer' as developer;

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import 'remote_config_keys.dart';

class RemoteConfigService extends ChangeNotifier {
  RemoteConfigService._();
  static final RemoteConfigService instance = RemoteConfigService._();

  FirebaseRemoteConfig get _rc => FirebaseRemoteConfig.instance;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  static const String _logTag = 'RemoteConfigService';

  static void _log(String message) {
    final tagged = '[$_logTag] $message';
    developer.log(tagged, name: _logTag);
    // Keep `print` for release visibility in plain logcat streams.
    print(tagged);
    // Keep debugPrint too, so logs are visible in debug console.
    if (kDebugMode) {
      debugPrint(tagged);
    }
  }

  /// Defaults: feature flags + production IDs.
  static const Map<String, dynamic> defaults = <String, dynamic>{
    // Boolean feature flags — default OFF (can be overridden in Firebase).
    RemoteConfigKeys.tattooBirthdayAdsAll: true,
    RemoteConfigKeys.tattooBirthdayBanner: true,
    RemoteConfigKeys.tattooBirthdayNative: true,

    RemoteConfigKeys.tattooIdeaAdsAll: true,
    RemoteConfigKeys.tattooIdeaBanner: true,
    RemoteConfigKeys.tattooIdeaNative: true,
    RemoteConfigKeys.tattooStyleSelectionAdsAll: true,
    RemoteConfigKeys.tattooStyleSelectionBanner: true,
    RemoteConfigKeys.tattooStyleSelectionNative: false,

    // Flower module (default OFF; control via Firebase).
    RemoteConfigKeys.flowerAdsAll: true,
    RemoteConfigKeys.flowerShowInterstitialAfterGeneration: true,

    // Splash screen ad/text toggles (default OFF).
    RemoteConfigKeys.splashAdsAndTextEnabled: true,
    // App Open has priority on splash (interstitial can be enabled via Firebase).
    RemoteConfigKeys.splashShowInterstitial: true,
    RemoteConfigKeys.splashShowAppOpen: true,
    // Paywall after splash for returning (onboarding completed) free users.
    RemoteConfigKeys.splashShowPaywall: true,

    RemoteConfigKeys.firstLanguageOnboardingEnabled: true,
    RemoteConfigKeys.firstLanguageShowNativeAd: true,
  };

  Future<void> initialize() async {
    if (_initialized) {
      _log('initialize skipped: already initialized.');
      return;
    }

    _log('initialize start.');
    _log('setting config settings: fetchTimeout=12s, minimumFetchInterval=0s');

    await _rc.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 12),
        // Always allow immediate refetch so flag updates are not delayed by throttle.
        minimumFetchInterval: Duration.zero,
      ),
    );

    await _rc.setDefaults(defaults);
    _log('defaults applied: $defaults');

    try {
      _log('fetchAndActivate start...');
      final changed = await _rc.fetchAndActivate();
      _log('fetchAndActivate success. changed=$changed');
      _logLastFetchMeta();
    } catch (e, st) {
      _log('fetchAndActivate failed: $e');
      _log('fetchAndActivate stack: $st');
      _logLastFetchMeta();
    }

    _initialized = true;
    _logResolvedFlags();
    _logKeyDetails();
    _log('initialize complete. isInitialized=$_initialized');
    notifyListeners();
  }

  void _logLastFetchMeta() {
    final status = _rc.lastFetchStatus;
    final lastFetchTime = _rc.lastFetchTime;
    _log('lastFetchStatus=$status, lastFetchTime=$lastFetchTime');
  }

  void _logResolvedFlags() {
    _log(
      'resolved flags => '
      'tattooBirthdayAdsAll=$tattooBirthdayAdsAll, '
      'tattooBirthdayShowBanner=$tattooBirthdayShowBanner, '
      'tattooBirthdayShowNative=$tattooBirthdayShowNative, '
      'tattooIdeaAdsAll=$tattooIdeaAdsAll, '
      'tattooIdeaShowBanner=$tattooIdeaShowBanner, '
      'tattooIdeaShowNative=$tattooIdeaShowNative, '
      'tattooStyleSelectionAdsAll=$tattooStyleSelectionAdsAll, '
      'tattooStyleSelectionShowBanner=$tattooStyleSelectionShowBanner, '
      'tattooStyleSelectionShowNative=$tattooStyleSelectionShowNative, '
      'splashAdsAndTextEnabled=$splashAdsAndTextEnabled, '
      'splashShowInterstitial=$splashShowInterstitial, '
      'splashShowAppOpen=$splashShowAppOpen, '
      'splashShowPaywall=$splashShowPaywall, '
      'firstLanguageOnboardingEnabled=$firstLanguageOnboardingEnabled, '
      'firstLanguageShowNativeAd=$firstLanguageShowNativeAd',
    );
  }

  void _logKeyDetails() {
    _logKeyDetail(RemoteConfigKeys.splashAdsAndTextEnabled);
    _logKeyDetail(RemoteConfigKeys.splashShowAppOpen);
    _logKeyDetail(RemoteConfigKeys.splashShowInterstitial);
    _logKeyDetail(RemoteConfigKeys.splashShowPaywall);
    _logKeyDetail(RemoteConfigKeys.firstLanguageOnboardingEnabled);
    _logKeyDetail(RemoteConfigKeys.firstLanguageShowNativeAd);
  }

  void _logKeyDetail(String key) {
    final value = _rc.getValue(key);
    _log(
      'key="$key" => '
      'asBool=${value.asBool()}, '
      'asString="${value.asString()}", '
      'source=${value.source}',
    );
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

  /// Master: `false` ⇒ no ads in flower module.
  bool get flowerAdsAll => _rc.getBool(RemoteConfigKeys.flowerAdsAll);

  /// When `true`, show interstitial after flower generation completes.
  bool get flowerShowInterstitialAfterGeneration =>
      flowerAdsAll &&
      _rc.getBool(RemoteConfigKeys.flowerShowInterstitialAfterGeneration);

  bool get splashAdsAndTextEnabled =>
      _rc.getBool(RemoteConfigKeys.splashAdsAndTextEnabled);

  bool get splashShowInterstitial =>
      splashAdsAndTextEnabled &&
      _rc.getBool(RemoteConfigKeys.splashShowInterstitial);

  bool get splashShowAppOpen =>
      splashAdsAndTextEnabled &&
      _rc.getBool(RemoteConfigKeys.splashShowAppOpen);

  /// When `false`, skip the paywall after splash for returning free users.
  bool get splashShowPaywall => _rc.getBool(RemoteConfigKeys.splashShowPaywall);

  /// When `false`, skip the first language selection onboarding screen and go
  /// directly to the main onboarding flow.
  bool get firstLanguageOnboardingEnabled {
    final value = _rc.getBool(RemoteConfigKeys.firstLanguageOnboardingEnabled);
    _log('getter firstLanguageOnboardingEnabled=$value');
    return value;
  }

  bool get firstLanguageShowNativeAd {
    final value = _rc.getBool(RemoteConfigKeys.firstLanguageShowNativeAd);
    _log('getter firstLanguageShowNativeAd=$value');
    return value;
  }
}
