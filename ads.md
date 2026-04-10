Remote Config keys to create (Firebase)

**Only booleans** — ad unit IDs live in app code: `lib/services/admob_ids.dart`.

- splash_ads_and_text_enabled = true
- splash_show_app_open = true
- splash_show_interstitial = false

- tattoo_birthday_ads_all = true
- tattoo_birthday_banner = true


- tattoo_style_selection_ads_all = true
- tattoo_style_selection_banner = true

- first_language_onboarding_enabled = true
- first_language_show_native_ad = true

What Remote Config controls (ON/OFF only)

- Splash full-screen ads + splash notice text (second-time user only)
- Tattoo: birthday step (banner + native)
- Tattoo: step 04 idea/prompt (banner + native)
- Tattoo: last step style selection (banner + native)
- First language onboarding: native visibility only

Hardcoded in app (not Remote Config)

- All AdMob unit IDs (`AdmobIds`)
- Language selection screen native ad
- Explore top banner (`TopBannerAd`)
- App open when resuming from cache (`main.dart`)
