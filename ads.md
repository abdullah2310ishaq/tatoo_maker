

Remote Config (Firebase) — add these keys

## 1) Feature toggles (booleans)
- tattoo_birthday_ads_all = true
- tattoo_birthday_banner = true
- tattoo_birthday_native = true

- tattoo_idea_ads_all = true
- tattoo_idea_banner = true
- tattoo_idea_native = true

- tattoo_style_selection_ads_all = true
- tattoo_style_selection_banner = true
- tattoo_style_selection_native = true

- splash_ads_and_text_enabled = true
- splash_show_app_open = true
- splash_show_interstitial = false

- first_language_onboarding_enabled = true

## 2) Ad unit IDs (strings)
### Production (used by default in profile/release)
- admob_android_banner_unit_id = ca-app-pub-5408098781737794/4430049847
- admob_android_native_unit_id = ca-app-pub-5408098781737794/3919748102
- admob_android_app_open_unit_id = ca-app-pub-5408098781737794/2580813955
- admob_android_interstitial_unit_id = ca-app-pub-5408098781737794/5232829779

### Test (safe for QA clicking)
- admob_android_banner_test_unit_id = ca-app-pub-3940256099942544/6300978111
- admob_android_native_test_unit_id = ca-app-pub-3940256099942544/2247696110
- admob_android_app_open_test_unit_id = ca-app-pub-3940256099942544/9257395921
- admob_android_interstitial_test_unit_id = ca-app-pub-3940256099942544/1033173712

## QA quick note
- Debug build: uses TEST ads automatically.
- Profile/Release QA: run with `--dart-define=FORCE_TEST_ADS=true` to force TEST ads.