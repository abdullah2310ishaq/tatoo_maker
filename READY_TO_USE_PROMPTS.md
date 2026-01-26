# Ready-to-Use Prompts for ARB File Generation

Copy and paste these prompts one at a time in separate chats to generate each ARB file.

---

## 🇪🇸 Spanish (es) - app_es.arb

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
   - Zodiac sign names: Translate to Spanish names (Capricorn → Capricornio, Aquarius → Acuario, etc.)
   - Month names: Translate to Spanish (January → Enero, February → Febrero, etc.)
   - Style names: Translate appropriately (Dragon → Dragón, Unicorn → Unicornio, etc.)
   - Language names: Use native names

**Output:**
Create the complete ARB file with all translations. The file should be valid JSON and follow the exact same structure as app_en.arb.
```

---

## 🇫🇷 French (fr) - app_fr.arb

```
I need you to create a localized ARB file for French (fr) based on the English ARB file.

**Task:**
- Read the English ARB file: `lib/l10n/app_en.arb`
- Create a new ARB file: `lib/l10n/app_fr.arb`
- Translate ALL string values from English to French
- Keep ALL keys, descriptions (@ keys), and structure EXACTLY the same
- Only translate the string values (the text after the colon)
- Preserve all placeholders like {name}, {currentStep}, etc.
- Maintain JSON formatting and structure
- Keep parameterized strings with placeholders intact

**Language Details:**
- Language Code: fr
- Language Name: French
- Native Name: Français

**Important Rules:**
1. DO NOT translate:
   - Key names (e.g., "skip", "continue_", "tattooCreation")
   - Description keys (e.g., "@skip", "@continue_")
   - Placeholder names in descriptions (e.g., {name}, {currentStep})
   - The "@@locale" value should be "fr"

2. DO translate:
   - All string values (the text after the colon)
   - Descriptions should remain in English (they're for developers)

3. For parameterized strings:
   - Keep the placeholder syntax: "{name}", "{currentStep}", etc.
   - Translate the surrounding text
   - Example: "Designing \"{name}\" with beautiful flowers" → "Création de \"{name}\" avec de belles fleurs"

4. Special considerations:
   - Zodiac sign names: Translate to French names (Capricorn → Capricorne, Aquarius → Verseau, etc.)
   - Month names: Translate to French (January → Janvier, February → Février, etc.)
   - Style names: Translate appropriately (Dragon → Dragon, Unicorn → Licorne, etc.)
   - Language names: Use native names

**Output:**
Create the complete ARB file with all translations. The file should be valid JSON and follow the exact same structure as app_en.arb.
```

---

## 🇩🇪 German (de) - app_de.arb

```
I need you to create a localized ARB file for German (de) based on the English ARB file.

**Task:**
- Read the English ARB file: `lib/l10n/app_en.arb`
- Create a new ARB file: `lib/l10n/app_de.arb`
- Translate ALL string values from English to German
- Keep ALL keys, descriptions (@ keys), and structure EXACTLY the same
- Only translate the string values (the text after the colon)
- Preserve all placeholders like {name}, {currentStep}, etc.
- Maintain JSON formatting and structure
- Keep parameterized strings with placeholders intact

**Language Details:**
- Language Code: de
- Language Name: German
- Native Name: Deutsch

**Important Rules:**
1. DO NOT translate:
   - Key names (e.g., "skip", "continue_", "tattooCreation")
   - Description keys (e.g., "@skip", "@continue_")
   - Placeholder names in descriptions (e.g., {name}, {currentStep})
   - The "@@locale" value should be "de"

2. DO translate:
   - All string values (the text after the colon)
   - Descriptions should remain in English (they're for developers)

3. For parameterized strings:
   - Keep the placeholder syntax: "{name}", "{currentStep}", etc.
   - Translate the surrounding text
   - Example: "Designing \"{name}\" with beautiful flowers" → "Gestaltung von \"{name}\" mit schönen Blumen"

4. Special considerations:
   - Zodiac sign names: Translate to German names (Capricorn → Steinbock, Aquarius → Wassermann, etc.)
   - Month names: Translate to German (January → Januar, February → Februar, etc.)
   - Style names: Translate appropriately (Dragon → Drache, Unicorn → Einhorn, etc.)
   - Language names: Use native names

**Output:**
Create the complete ARB file with all translations. The file should be valid JSON and follow the exact same structure as app_en.arb.
```

---

## 🇮🇹 Italian (it) - app_it.arb

```
I need you to create a localized ARB file for Italian (it) based on the English ARB file.

**Task:**
- Read the English ARB file: `lib/l10n/app_en.arb`
- Create a new ARB file: `lib/l10n/app_it.arb`
- Translate ALL string values from English to Italian
- Keep ALL keys, descriptions (@ keys), and structure EXACTLY the same
- Only translate the string values (the text after the colon)
- Preserve all placeholders like {name}, {currentStep}, etc.
- Maintain JSON formatting and structure
- Keep parameterized strings with placeholders intact

**Language Details:**
- Language Code: it
- Language Name: Italian
- Native Name: Italiano

**Important Rules:**
1. DO NOT translate:
   - Key names (e.g., "skip", "continue_", "tattooCreation")
   - Description keys (e.g., "@skip", "@continue_")
   - Placeholder names in descriptions (e.g., {name}, {currentStep})
   - The "@@locale" value should be "it"

2. DO translate:
   - All string values (the text after the colon)
   - Descriptions should remain in English (they're for developers)

3. For parameterized strings:
   - Keep the placeholder syntax: "{name}", "{currentStep}", etc.
   - Translate the surrounding text
   - Example: "Designing \"{name}\" with beautiful flowers" → "Progettazione di \"{name}\" con bellissimi fiori"

4. Special considerations:
   - Zodiac sign names: Translate to Italian names (Capricorn → Capricorno, Aquarius → Acquario, etc.)
   - Month names: Translate to Italian (January → Gennaio, February → Febbraio, etc.)
   - Style names: Translate appropriately (Dragon → Drago, Unicorn → Unicorno, etc.)
   - Language names: Use native names

**Output:**
Create the complete ARB file with all translations. The file should be valid JSON and follow the exact same structure as app_en.arb.
```

---

## 🇵🇹 Portuguese (pt) - app_pt.arb

```
I need you to create a localized ARB file for Portuguese (pt) based on the English ARB file.

**Task:**
- Read the English ARB file: `lib/l10n/app_en.arb`
- Create a new ARB file: `lib/l10n/app_pt.arb`
- Translate ALL string values from English to Portuguese
- Keep ALL keys, descriptions (@ keys), and structure EXACTLY the same
- Only translate the string values (the text after the colon)
- Preserve all placeholders like {name}, {currentStep}, etc.
- Maintain JSON formatting and structure
- Keep parameterized strings with placeholders intact

**Language Details:**
- Language Code: pt
- Language Name: Portuguese
- Native Name: Português

**Important Rules:**
1. DO NOT translate:
   - Key names (e.g., "skip", "continue_", "tattooCreation")
   - Description keys (e.g., "@skip", "@continue_")
   - Placeholder names in descriptions (e.g., {name}, {currentStep})
   - The "@@locale" value should be "pt"

2. DO translate:
   - All string values (the text after the colon)
   - Descriptions should remain in English (they're for developers)

3. For parameterized strings:
   - Keep the placeholder syntax: "{name}", "{currentStep}", etc.
   - Translate the surrounding text
   - Example: "Designing \"{name}\" with beautiful flowers" → "Criando \"{name}\" com lindas flores"

4. Special considerations:
   - Zodiac sign names: Translate to Portuguese names (Capricorn → Capricórnio, Aquarius → Aquário, etc.)
   - Month names: Translate to Portuguese (January → Janeiro, February → Fevereiro, etc.)
   - Style names: Translate appropriately (Dragon → Dragão, Unicorn → Unicórnio, etc.)
   - Language names: Use native names

**Output:**
Create the complete ARB file with all translations. The file should be valid JSON and follow the exact same structure as app_en.arb.
```

---

## 🇷🇺 Russian (ru) - app_ru.arb

```
I need you to create a localized ARB file for Russian (ru) based on the English ARB file.

**Task:**
- Read the English ARB file: `lib/l10n/app_en.arb`
- Create a new ARB file: `lib/l10n/app_ru.arb`
- Translate ALL string values from English to Russian
- Keep ALL keys, descriptions (@ keys), and structure EXACTLY the same
- Only translate the string values (the text after the colon)
- Preserve all placeholders like {name}, {currentStep}, etc.
- Maintain JSON formatting and structure
- Keep parameterized strings with placeholders intact

**Language Details:**
- Language Code: ru
- Language Name: Russian
- Native Name: Русский

**Important Rules:**
1. DO NOT translate:
   - Key names (e.g., "skip", "continue_", "tattooCreation")
   - Description keys (e.g., "@skip", "@continue_")
   - Placeholder names in descriptions (e.g., {name}, {currentStep})
   - The "@@locale" value should be "ru"

2. DO translate:
   - All string values (the text after the colon)
   - Descriptions should remain in English (they're for developers)

3. For parameterized strings:
   - Keep the placeholder syntax: "{name}", "{currentStep}", etc.
   - Translate the surrounding text
   - Example: "Designing \"{name}\" with beautiful flowers" → "Создание \"{name}\" с красивыми цветами"

4. Special considerations:
   - Zodiac sign names: Translate to Russian names (Capricorn → Козерог, Aquarius → Водолей, etc.)
   - Month names: Translate to Russian (January → Январь, February → Февраль, etc.)
   - Style names: Translate appropriately (Dragon → Дракон, Unicorn → Единорог, etc.)
   - Language names: Use native names
   - Use Cyrillic script for all Russian text

**Output:**
Create the complete ARB file with all translations. The file should be valid JSON and follow the exact same structure as app_en.arb.
```

---

## 🇨🇳 Chinese (zh) - app_zh.arb

```
I need you to create a localized ARB file for Chinese (zh) based on the English ARB file.

**Task:**
- Read the English ARB file: `lib/l10n/app_en.arb`
- Create a new ARB file: `lib/l10n/app_zh.arb`
- Translate ALL string values from English to Chinese (Simplified)
- Keep ALL keys, descriptions (@ keys), and structure EXACTLY the same
- Only translate the string values (the text after the colon)
- Preserve all placeholders like {name}, {currentStep}, etc.
- Maintain JSON formatting and structure
- Keep parameterized strings with placeholders intact

**Language Details:**
- Language Code: zh
- Language Name: Chinese
- Native Name: 中文

**Important Rules:**
1. DO NOT translate:
   - Key names (e.g., "skip", "continue_", "tattooCreation")
   - Description keys (e.g., "@skip", "@continue_")
   - Placeholder names in descriptions (e.g., {name}, {currentStep})
   - The "@@locale" value should be "zh"

2. DO translate:
   - All string values (the text after the colon)
   - Descriptions should remain in English (they're for developers)

3. For parameterized strings:
   - Keep the placeholder syntax: "{name}", "{currentStep}", etc.
   - Translate the surrounding text
   - Example: "Designing \"{name}\" with beautiful flowers" → "用美丽的花朵设计 \"{name}\""

4. Special considerations:
   - Zodiac sign names: Translate to Chinese names (Capricorn → 摩羯座, Aquarius → 水瓶座, etc.)
   - Month names: Translate to Chinese (January → 一月, February → 二月, etc.)
   - Style names: Translate appropriately (Dragon → 龙, Unicorn → 独角兽, etc.)
   - Language names: Use native names
   - Use Simplified Chinese characters (简体中文)

**Output:**
Create the complete ARB file with all translations. The file should be valid JSON and follow the exact same structure as app_en.arb.
```

---

## 🇯🇵 Japanese (ja) - app_ja.arb

```
I need you to create a localized ARB file for Japanese (ja) based on the English ARB file.

**Task:**
- Read the English ARB file: `lib/l10n/app_en.arb`
- Create a new ARB file: `lib/l10n/app_ja.arb`
- Translate ALL string values from English to Japanese
- Keep ALL keys, descriptions (@ keys), and structure EXACTLY the same
- Only translate the string values (the text after the colon)
- Preserve all placeholders like {name}, {currentStep}, etc.
- Maintain JSON formatting and structure
- Keep parameterized strings with placeholders intact

**Language Details:**
- Language Code: ja
- Language Name: Japanese
- Native Name: 日本語

**Important Rules:**
1. DO NOT translate:
   - Key names (e.g., "skip", "continue_", "tattooCreation")
   - Description keys (e.g., "@skip", "@continue_")
   - Placeholder names in descriptions (e.g., {name}, {currentStep})
   - The "@@locale" value should be "ja"

2. DO translate:
   - All string values (the text after the colon)
   - Descriptions should remain in English (they're for developers)

3. For parameterized strings:
   - Keep the placeholder syntax: "{name}", "{currentStep}", etc.
   - Translate the surrounding text
   - Example: "Designing \"{name}\" with beautiful flowers" → "美しい花で \"{name}\" をデザイン"

4. Special considerations:
   - Zodiac sign names: Translate to Japanese names (Capricorn → 山羊座, Aquarius → 水瓶座, etc.)
   - Month names: Translate to Japanese (January → 1月, February → 2月, etc.)
   - Style names: Translate appropriately (Dragon → ドラゴン, Unicorn → ユニコーン, etc.)
   - Language names: Use native names
   - Use appropriate mix of Hiragana, Katakana, and Kanji

**Output:**
Create the complete ARB file with all translations. The file should be valid JSON and follow the exact same structure as app_en.arb.
```

---

## 🇰🇷 Korean (ko) - app_ko.arb

```
I need you to create a localized ARB file for Korean (ko) based on the English ARB file.

**Task:**
- Read the English ARB file: `lib/l10n/app_en.arb`
- Create a new ARB file: `lib/l10n/app_ko.arb`
- Translate ALL string values from English to Korean
- Keep ALL keys, descriptions (@ keys), and structure EXACTLY the same
- Only translate the string values (the text after the colon)
- Preserve all placeholders like {name}, {currentStep}, etc.
- Maintain JSON formatting and structure
- Keep parameterized strings with placeholders intact

**Language Details:**
- Language Code: ko
- Language Name: Korean
- Native Name: 한국어

**Important Rules:**
1. DO NOT translate:
   - Key names (e.g., "skip", "continue_", "tattooCreation")
   - Description keys (e.g., "@skip", "@continue_")
   - Placeholder names in descriptions (e.g., {name}, {currentStep})
   - The "@@locale" value should be "ko"

2. DO translate:
   - All string values (the text after the colon)
   - Descriptions should remain in English (they're for developers)

3. For parameterized strings:
   - Keep the placeholder syntax: "{name}", "{currentStep}", etc.
   - Translate the surrounding text
   - Example: "Designing \"{name}\" with beautiful flowers" → "아름다운 꽃으로 \"{name}\" 디자인"

4. Special considerations:
   - Zodiac sign names: Translate to Korean names (Capricorn → 염소자리, Aquarius → 물병자리, etc.)
   - Month names: Translate to Korean (January → 1월, February → 2월, etc.)
   - Style names: Translate appropriately (Dragon → 드래곤, Unicorn → 유니콘, etc.)
   - Language names: Use native names
   - Use Hangul (한글) script

**Output:**
Create the complete ARB file with all translations. The file should be valid JSON and follow the exact same structure as app_en.arb.
```

---

## 🇸🇦 Arabic (ar) - app_ar.arb

```
I need you to create a localized ARB file for Arabic (ar) based on the English ARB file.

**Task:**
- Read the English ARB file: `lib/l10n/app_en.arb`
- Create a new ARB file: `lib/l10n/app_ar.arb`
- Translate ALL string values from English to Arabic
- Keep ALL keys, descriptions (@ keys), and structure EXACTLY the same
- Only translate the string values (the text after the colon)
- Preserve all placeholders like {name}, {currentStep}, etc.
- Maintain JSON formatting and structure
- Keep parameterized strings with placeholders intact

**Language Details:**
- Language Code: ar
- Language Name: Arabic
- Native Name: العربية

**Important Rules:**
1. DO NOT translate:
   - Key names (e.g., "skip", "continue_", "tattooCreation")
   - Description keys (e.g., "@skip", "@continue_")
   - Placeholder names in descriptions (e.g., {name}, {currentStep})
   - The "@@locale" value should be "ar"

2. DO translate:
   - All string values (the text after the colon)
   - Descriptions should remain in English (they're for developers)

3. For parameterized strings:
   - Keep the placeholder syntax: "{name}", "{currentStep}", etc.
   - Translate the surrounding text
   - Example: "Designing \"{name}\" with beautiful flowers" → "تصميم \"{name}\" بأزهار جميلة"

4. Special considerations:
   - Zodiac sign names: Translate to Arabic names (Capricorn → الجدي, Aquarius → الدلو, etc.)
   - Month names: Translate to Arabic (January → يناير, February → فبراير, etc.)
   - Style names: Translate appropriately (Dragon → تنين, Unicorn → وحيد القرن, etc.)
   - Language names: Use native names
   - Use Arabic script (العربية)
   - Note: Arabic is RTL (Right-to-Left), ensure proper text direction

**Output:**
Create the complete ARB file with all translations. The file should be valid JSON and follow the exact same structure as app_en.arb.
```

---

## 📌 Usage Instructions

1. **Copy one prompt** from above (start with Spanish, then French, etc.)
2. **Paste it in a new chat** with the AI assistant
3. **Wait for the complete ARB file** to be generated
4. **Save it** as `lib/l10n/app_[CODE].arb` (e.g., `lib/l10n/app_es.arb`)
5. **Verify** the file structure matches `app_en.arb`
6. **Repeat** for the next language

**After creating all ARB files:**
- Run `flutter pub get` or `flutter gen-l10n` to generate the localization files
- Test each language by changing the app locale
- Verify all strings appear correctly translated

---

**Good luck! 🚀**
