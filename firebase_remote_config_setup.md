# Firebase Remote Config (Easy Setup)

This project reads feature flags + AdMob unit IDs from **Firebase Remote Config** via `RemoteConfigService`.

## Where to add these keys

- Firebase Console → **Remote Config** → **Parameters** → **Add parameter**
- Add the keys below
- Click **Publish changes**

## Recommended default behavior (in code)

In `lib/services/remote_config_service.dart` we keep these defaults:

- **Splash ads/text**: **OFF by default**
- **First language onboarding screen**: **OFF by default** (skip it unless enabled)

You can override anytime from Firebase Remote Config.

## Boolean Feature Flags (Remote Config)

### Splash (ads + text)

- **`splash_ads_and_text_enabled`**: master switch for *both* ads + “may perform an ad” text on splash
  - `true` = splash may show ads/text (2nd open only logic still applies)
  - `false` = no splash ads and no splash text

- **`splash_show_app_open`**: show App Open ad during splash sequence (only if master is true)
  - `true` / `false`

- **`splash_show_interstitial`**: show interstitial during splash sequence (only if master is true)
  - `true` / `false`

### Onboarding (language screen)

- **`first_language_onboarding_enabled`**
  - `true` = show `FirstLanguageScreen`
  - `false` = skip language screen and go directly to `RealOnboardingFlow`

### Onboarding ads (existing flags)

Birthday step:

- **`tattoo_birthday_ads_all`**
- **`tattoo_birthday_banner`**
- **`tattoo_birthday_native`**

Style selection step:

- **`tattoo_style_selection_ads_all`**
- **`tattoo_style_selection_banner`**
- **`tattoo_style_selection_native`**

## AdMob Unit IDs (Remote Config)

These keys should contain the **exact AdMob unit id string** (`ca-app-pub-.../...`).

Production:

- **`admob_android_app_open_unit_id`**
- **`admob_android_interstitial_unit_id`**
- **`admob_android_banner_unit_id`**
- **`admob_android_native_unit_id`**

Test (optional; used for QA/debug setups):

- **`admob_android_app_open_test_unit_id`**
- **`admob_android_interstitial_test_unit_id`**
- **`admob_android_banner_test_unit_id`**
- **`admob_android_native_test_unit_id`**

## Example values (your production IDs)

- App Open: `ca-app-pub-5408098781737794/4589831949`
- Interstitial: `ca-app-pub-5408098781737794/5232829779`
- Banner: `ca-app-pub-5408098781737794/4430049847`
- Native: `ca-app-pub-5408098781737794/3919748102`

## Quick troubleshooting

- If you get `LoadAdError(code: 3) Ad unit doesn't match format`:
  - Most commonly **the wrong unit id is saved under the wrong key** (e.g. interstitial id stored in app-open key).
  - Re-check the 4 production ID keys above and republish Remote Config.

