

### 2. `lib/creation/home_page.dart`
- **Lines 46-78**: Style labels in `_styles` getter:
  - `'Dragon'` (line 46)
  - `'Unicorn'` (line 47)
  - `'Floral'` (line 48)
  - `'Abstract'` (line 50)
  - `'Butterfly'` (line 56)
  - `'Eagle'` (line 62)
  - `'Lion'` (line 66)
  - `'Spider'` (line 70)
  - `'Wolf'` (line 76)
  
  **Note:** These are used as keys in the `_stylePrompts` map. They should use localized style names from `getTattooStyles()` instead.

### 3. `lib/flower/widgets/generate_button.dart`
- **Line 34**: `'Generate'` - Button label




## 🟡 Medium Priority - Internal/Technical Strings

### 6. `lib/creation/virtual_try_on.dart`
- **Line 128**: `'Preview not ready'` - Exception message (may be acceptable as internal error)
- **Line 139**: `'Failed to encode preview'` - Exception message (may be acceptable as internal error)

### 7. `lib/utils/image_processing_isolates.dart`
- **Line 22**: `'Failed to decode input or mask image'` - Exception message (internal error, may not need localization)

### 8. `lib/flower/widgets/flower_keyboard.dart`
- **Line 18**: `'BACKSPACE'` - Keyboard key identifier (technical, may not need localization)

---

## 📝 Summary

### Total Non-Localized User-Facing Strings: **~25**

**Breakdown:**
- **Button Labels**: 1 (`Generate`)
- **Style Labels**: 9 (Dragon, Unicorn, Floral, Abstract, Butterfly, Eagle, Lion, Spider, Wolf)
- **Language Names**: 11 (English, Spanish, French, German, Italian, Portuguese, Russian, Chinese, Japanese, Korean, Arabic) × 2 files = 22 instances
- **App Metadata**: 1 (`InkVision - Tattoo Maker`)

### Recommendations:

1. **Style Labels in `home_page.dart`**: These should use the localized style names from `getTattooStyles(context, isDark)` instead of hardcoded strings.

2. **Language Names**: The `name` fields in language selection screens should use localized language names. Consider creating a helper function similar to `_getCurrentLanguageName()` in `app_drawer.dart`.

3. **Generate Button**: Should use `AppLocalizations.of(context)!.generate` or similar.

4. **Exception Messages**: Consider whether these need localization or if they're developer-only messages.

---

## ✅ Already Localized (For Reference)

The following files are already properly localized:
- `lib/widgets/exit_confirmation_dialog.dart` ✅
- `lib/widgets/app_drawer.dart` ✅
- `lib/home_shell.dart` ✅
- `lib/tattoo/onboarding/widgets/onboarding_header.dart` ✅
- `lib/tattoo/onboarding/widgets/onboarding_next_button.dart` ✅
- `lib/tattoo/onboarding/utils/zodiac_utils.dart` ✅
- All onboarding pages ✅
- All creation/result screens ✅
- Virtual try-on widgets ✅

---

**Generated:** $(date)
**Scan Date:** 2026-01-26
