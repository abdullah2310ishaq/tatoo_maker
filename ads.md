Remote Config keys to create (Firebase)

Booleans
- splash_ads_and_text_enabled = true
- splash_show_app_open = true
- splash_show_interstitial = false

- tattoo_birthday_ads_all = true
- tattoo_birthday_banner = true
- tattoo_birthday_native = true

- tattoo_idea_ads_all = true
- tattoo_idea_banner = true
- tattoo_idea_native = true

- tattoo_style_selection_ads_all = true
- tattoo_style_selection_banner = true
- tattoo_style_selection_native = false

- first_language_onboarding_enabled = true
- first_language_show_native_ad = true

Strings (production ad unit IDs used by Remote Config controlled screens)
- admob_android_banner_unit_id = ca-app-pub-5408098781737794/4430049847
- admob_android_native_unit_id = ca-app-pub-5408098781737794/3919748102
- admob_android_app_open_unit_id = ca-app-pub-5408098781737794/2580813955
- admob_android_interstitial_unit_id = ca-app-pub-5408098781737794/5232829779

What is Remote Config controlled (ON/OFF + IDs from RC)
- Splash full-screen ads + splash notice text (second-time user only)
- Tattoo module: Birthday step (banner + native)
- Tattoo module: Step 04 idea/prompt screen (banner + native)
- Tattoo module: Last step style selection (banner only)
- First language onboarding screen: native ad visibility only (ID is hardcoded)

What stays hardcoded (NOT Remote Config)
- LanguageSelectionScreen native ad (non-PRO)
- Explore category top banner (TopBannerAd) (non-PRO)
- App Open on resume from cache (whole app) uses hardcoded app-open unit id (non-PRO)