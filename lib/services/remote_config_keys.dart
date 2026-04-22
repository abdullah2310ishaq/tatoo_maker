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

  /// Flower module ads.
  static const String flowerAdsAll = 'flower_ads_all';
  static const String flowerShowInterstitialAfterGeneration =
      'flower_show_interstitial_after_generation';

  /// Splash screen ad/text toggles.
  static const String splashAdsAndTextEnabled = 'splash_ads_and_text_enabled';
  static const String splashShowInterstitial = 'splash_show_interstitial';
  static const String splashShowAppOpen = 'splash_show_app_open';

  static const String splashShowPaywall = 'splash_show_paywall';

  static const String firstLanguageOnboardingEnabled =
      'first_language_onboarding_enabled';

  /// First language onboarding screen: control native ad visibility.
  static const String firstLanguageShowNativeAd =
      'first_language_show_native_ad';

  /// Pro / paywall: show or hide the trial toggle card.
  static const String proAccessShowTrialToggle = 'pro_access_show_trial_toggle';
}
