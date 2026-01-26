# Prompt Template for Generating ARB Files

Use this prompt template to generate localized ARB files for each language. **Generate one language at a time.**

---

## 📋 Available Languages

Based on `lib/language/language_screen.dart`, generate ARB files for:

1. **Spanish (es)** - `app_es.arb`
2. **French (fr)** - `app_fr.arb`
3. **German (de)** - `app_de.arb`
4. **Italian (it)** - `app_it.arb`
5. **Portuguese (pt)** - `app_pt.arb`
6. **Russian (ru)** - `app_ru.arb`
7. **Chinese (zh)** - `app_zh.arb`
8. **Japanese (ja)** - `app_ja.arb`
9. **Korean (ko)** - `app_ko.arb`
10. **Arabic (ar)** - `app_ar.arb`

---

## 🎯 Prompt Template (Copy & Use One Language at a Time)

```
I need you to create a localized ARB file for [LANGUAGE_NAME] ([LANGUAGE_CODE]) based on the English ARB file.

**Task:**
- Read the English ARB file: `lib/l10n/app_en.arb`
- Create a new ARB file: `lib/l10n/app_[CODE].arb`
- Translate ALL string values from English to [LANGUAGE_NAME]
- Keep ALL keys, descriptions (@ keys), and structure EXACTLY the same
- Only translate the string values (the text after the colon)
- Preserve all placeholders like {name}, {currentStep}, etc.
- Maintain JSON formatting and structure
- Keep parameterized strings with placeholders intact

**Language Details:**
- Language Code: [CODE]
- Language Name: [LANGUAGE_NAME]
- Native Name: [NATIVE_NAME]

**Important Rules:**
1. DO NOT translate:
   - Key names (e.g., "skip", "continue_", "tattooCreation")
   - Description keys (e.g., "@skip", "@continue_")
   - Placeholder names in descriptions (e.g., {name}, {currentStep})
   - The "@@locale" value should be "[CODE]"

2. DO translate:
   - All string values (the text after the colon)
   - Descriptions should remain in English (they're for developers)

3. For parameterized strings:
   - Keep the placeholder syntax: "{name}", "{currentStep}", etc.
   - Translate the surrounding text
   - Example: "Designing \"{name}\" with beautiful flowers" → "[TRANSLATED_TEXT] \"{name}\" [TRANSLATED_TEXT]"

4. Special considerations:
   - Zodiac sign names: Translate to [LANGUAGE_NAME] names
   - Month names: Translate to [LANGUAGE_NAME] month names
   - Style names (Dragon, Unicorn, etc.): Translate appropriately
   - Language names: Use native names where applicable

**Output:**
Create the complete ARB file with all translations. The file should be valid JSON and follow the exact same structure as app_en.arb.
```

---

## 📝 Example Usage

### For Spanish (es):

```
I need you to create a localized ARB file for Spanish (es) based on the English ARB file.

**Task:**
- Read the English ARB file: `lib/l10n/app_en.arb`
- Create a new ARB file: `lib/l10n/app_es.arb`
- Translate ALL string values from English to Spanish
- Keep ALL keys, descriptions (@ keys), and structure EXACTLY the same
- Only translate the string values (the text after the colon)
- Preserve all placeholders like {name}, {currentStep}, etc.
- Maintain JSON formatting and structure
- Keep parameterized strings with placeholders intact

**Language Details:**
- Language Code: es
- Language Name: Spanish
- Native Name: Español

**Important Rules:**
1. DO NOT translate:
   - Key names (e.g., "skip", "continue_", "tattooCreation")
   - Description keys (e.g., "@skip", "@continue_")
   - Placeholder names in descriptions (e.g., {name}, {currentStep})
   - The "@@locale" value should be "es"

2. DO translate:
   - All string values (the text after the colon)
   - Descriptions should remain in English (they're for developers)

3. For parameterized strings:
   - Keep the placeholder syntax: "{name}", "{currentStep}", etc.
   - Translate the surrounding text
   - Example: "Designing \"{name}\" with beautiful flowers" → "Diseñando \"{name}\" con hermosas flores"

4. Special considerations:
   - Zodiac sign names: Translate to Spanish names (e.g., "Capricorn" → "Capricornio")
   - Month names: Translate to Spanish month names (e.g., "January" → "Enero")
   - Style names (Dragon, Unicorn, etc.): Translate appropriately
   - Language names: Use native names where applicable

**Output:**
Create the complete ARB file with all translations. The file should be valid JSON and follow the exact same structure as app_en.arb.
```

---

## 🔄 Quick Reference: Language Codes & Names

| Code | Language | Native Name | File Name |
|------|----------|-------------|-----------|
| es | Spanish | Español | `app_es.arb` |
| fr | French | Français | `app_fr.arb` |
| de | German | Deutsch | `app_de.arb` |
| it | Italian | Italiano | `app_it.arb` |
| pt | Portuguese | Português | `app_pt.arb` |
| ru | Russian | Русский | `app_ru.arb` |
| zh | Chinese | 中文 | `app_zh.arb` |
| ja | Japanese | 日本語 | `app_ja.arb` |
| ko | Korean | 한국어 | `app_ko.arb` |
| ar | Arabic | العربية | `app_ar.arb` |

---

## ✅ Checklist for Each Language

After generating each ARB file, verify:

- [ ] `"@@locale": "[CODE]"` is correct
- [ ] All keys match `app_en.arb` exactly
- [ ] All placeholders `{name}`, `{currentStep}`, etc. are preserved
- [ ] JSON syntax is valid (no trailing commas, proper quotes)
- [ ] Descriptions (@ keys) remain in English
- [ ] Parameterized strings maintain placeholder syntax
- [ ] File is saved as `lib/l10n/app_[CODE].arb`

---

## 📌 Notes

- **Generate one language at a time** to ensure quality and accuracy
- After creating each ARB file, Flutter will automatically generate the corresponding `app_localizations_[CODE].dart` file when you run `flutter gen-l10n` or `flutter pub get`
- Test each language by changing the app locale to verify translations appear correctly
- Some languages may require RTL (Right-to-Left) support (especially Arabic) - ensure your UI handles this properly

---

**Ready to start?** Copy the prompt template above, replace `[LANGUAGE_NAME]`, `[CODE]`, and `[NATIVE_NAME]` with the values from the table, and paste it in a new chat!
