

Remote Config booleans (Firebase) — defaults

NOTE: AdMob unit IDs are currently hard-coded to TEST IDs in `lib/services/admob_ids.dart`.
So on Firebase you only manage these booleans.

Current defaults in code (FOR NOW):

tattoo_birthday_ads_all = true
tattoo_birthday_banner = true
tattoo_birthday_native = true

tattoo_style_selection_ads_all = true
tattoo_style_selection_banner = true
tattoo_style_selection_native = true

splash_ads_and_text_enabled = true
splash_show_interstitial = true
splash_show_app_open = true

first_language_onboarding_enabled = true

How to turn ON (when you want):

1) Birthday screen ads:
- tattoo_birthday_ads_all = true
- tattoo_birthday_banner = true/false
- tattoo_birthday_native = true/false

2) Style selection screen ads:
- tattoo_style_selection_ads_all = true
- tattoo_style_selection_banner = true/false
- tattoo_style_selection_native = true/false

3) Splash ads + splash text (only 2nd app open logic still applies):
- splash_ads_and_text_enabled = true
- splash_show_app_open = true/false
- splash_show_interstitial = true/false

4) Show the first language onboarding screen:
- first_language_onboarding_enabled = true