/// Firebase Remote Config parameter keys.
abstract final class RemoteConfigKeys {
  static const String tattooBirthdayAdsAll = 'tattoo_birthday_ads_all';
  static const String tattooBirthdayBanner = 'tattoo_birthday_banner';
  static const String tattooBirthdayNative = 'tattoo_birthday_native';

  /// Production Android AdMob unit IDs (`ca-app-pub-.../...`).
  static const String admobAndroidBanner = 'admob_android_banner_unit_id';
  static const String admobAndroidNative = 'admob_android_native_unit_id';
  static const String admobAndroidAppOpen = 'admob_android_app_open_unit_id';
  static const String admobAndroidInterstitial = 'admob_android_interstitial_unit_id';

  /// Google **test** ad units (Android) — used in debug / internal QA via Remote Config.
  static const String admobAndroidBannerTest = 'admob_android_banner_test_unit_id';
  static const String admobAndroidNativeTest = 'admob_android_native_test_unit_id';
  static const String admobAndroidAppOpenTest = 'admob_android_app_open_test_unit_id';
  static const String admobAndroidInterstitialTest =
      'admob_android_interstitial_test_unit_id';
}
