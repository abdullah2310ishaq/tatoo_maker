/// Firebase Remote Config parameter keys.
abstract final class RemoteConfigKeys {
  static const String tattooBirthdayAdsAll = 'tattoo_birthday_ads_all';
  static const String tattooBirthdayBanner = 'tattoo_birthday_banner';
  static const String tattooBirthdayNative = 'tattoo_birthday_native';

  static const String tattooIdeaAdsAll = 'tattoo_idea_ads_all';
  static const String tattooIdeaBanner = 'tattoo_idea_banner';
  static const String tattooIdeaNative = 'tattoo_idea_native';

  static const String tattooStyleSelectionAdsAll =
      'tattoo_style_selection_ads_all';
  static const String tattooStyleSelectionBanner =
      'tattoo_style_selection_banner';
  static const String tattooStyleSelectionNative =
      'tattoo_style_selection_native';

  /// Production Android AdMob unit IDs (`ca-app-pub-.../...`).
  static const String admobAndroidBanner = 'admob_android_banner_unit_id';
  static const String admobAndroidNative = 'admob_android_native_unit_id';
  static const String admobAndroidAppOpen = 'admob_android_app_open_unit_id';
  static const String admobAndroidInterstitial =
      'admob_android_interstitial_unit_id';

  /// Google **test** ad units (Android).
  ///
  /// NOTE: app no longer relies on Remote Config for these in debug/QA;
  /// debug uses hardcoded Google sample IDs via `AdmobIds`.
  static const String admobAndroidBannerTest =
      'admob_android_banner_test_unit_id';
  static const String admobAndroidNativeTest =
      'admob_android_native_test_unit_id';
  static const String admobAndroidAppOpenTest =
      'admob_android_app_open_test_unit_id';
  static const String admobAndroidInterstitialTest =
      'admob_android_interstitial_test_unit_id';

  /// Splash screen ad/text toggles.
  static const String splashAdsAndTextEnabled =
      'splash_ads_and_text_enabled';
  static const String splashShowInterstitial =
      'splash_show_interstitial';
  static const String splashShowAppOpen = 'splash_show_app_open';

  static const String firstLanguageOnboardingEnabled =
      'first_language_onboarding_enabled';

  /// First language onboarding screen: control native ad visibility.
  static const String firstLanguageShowNativeAd =
      'first_language_show_native_ad';
}
