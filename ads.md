

Remote Config booleans (Firebase) — defaults

NOTE: Ad unit IDs are selected in 2 places:
- `lib/services/admob_ids.dart`: uses Google TEST IDs in debug, PROD IDs in profile/release.
- `lib/services/remote_config_service.dart`: provides Remote Config ad unit IDs (both prod + test fields).

Current defaults in code (FOR NOW):

tattoo_birthday_ads_all = true
tattoo_birthday_banner = true
tattoo_birthday_native = true

tattoo_idea_ads_all = true
tattoo_idea_banner = true
tattoo_idea_native = true

tattoo_style_selection_ads_all = true
tattoo_style_selection_banner = true
tattoo_style_selection_native = true

splash_ads_and_text_enabled = true
splash_show_interstitial = true
splash_show_app_open = true

first_language_onboarding_enabled = true

Ad unit ID keys (Remote Config):
- Production:
  - admob_android_banner_unit_id
  - admob_android_native_unit_id
  - admob_android_app_open_unit_id
  - admob_android_interstitial_unit_id
- Test (safe for QA clicking):
  - admob_android_banner_test_unit_id
  - admob_android_native_test_unit_id
  - admob_android_app_open_test_unit_id
  - admob_android_interstitial_test_unit_id

QA testing recommendation:
- Prefer giving QA a DEBUG build → it will use Google TEST ad units automatically.
- If you must test a profile/release build, set the Remote Config “*_test_unit_id” values and ensure the app uses those for QA.

How to turn ON (when you want):

1) Birthday screen ads:
- tattoo_birthday_ads_all = true
- tattoo_birthday_banner = true/false
- tattoo_birthday_native = true/false

2) Tattoo idea screen ads:
- tattoo_idea_ads_all = true
- tattoo_idea_banner = true/false
- tattoo_idea_native = true/false

3) Style selection screen ads:
- tattoo_style_selection_ads_all = true
- tattoo_style_selection_banner = true/false
- tattoo_style_selection_native = true/false

4) Splash ads + splash text (only 2nd app open logic still applies):
- splash_ads_and_text_enabled = true
- splash_show_app_open = true/false
- splash_show_interstitial = true/false

5) Show the first language onboarding screen:
- first_language_onboarding_enabled = true