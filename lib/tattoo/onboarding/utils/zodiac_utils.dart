import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../models/onboarding_models.dart';

// Get localized zodiac data for a given zodiac sign key
ZodiacInfo getZodiacData(BuildContext context, String zodiacKey) {
  final l10n = AppLocalizations.of(context)!;

  switch (zodiacKey) {
    case 'Capricorn':
      return ZodiacInfo(
        name: l10n.zodiacCapricornName,
        dateRange: l10n.zodiacCapricornDateRange,
        description: l10n.zodiacCapricornDescription,
        assetPath: 'assets/signs/capricorn.png',
      );
    case 'Aquarius':
      return ZodiacInfo(
        name: l10n.zodiacAquariusName,
        dateRange: l10n.zodiacAquariusDateRange,
        description: l10n.zodiacAquariusDescription,
        assetPath: 'assets/signs/aquarius.png',
      );
    case 'Pisces':
      return ZodiacInfo(
        name: l10n.zodiacPiscesName,
        dateRange: l10n.zodiacPiscesDateRange,
        description: l10n.zodiacPiscesDescription,
        assetPath: 'assets/signs/pisces.png',
      );
    case 'Aries':
      return ZodiacInfo(
        name: l10n.zodiacAriesName,
        dateRange: l10n.zodiacAriesDateRange,
        description: l10n.zodiacAriesDescription,
        assetPath: 'assets/signs/aries.png',
      );
    case 'Taurus':
      return ZodiacInfo(
        name: l10n.zodiacTaurusName,
        dateRange: l10n.zodiacTaurusDateRange,
        description: l10n.zodiacTaurusDescription,
        assetPath: 'assets/signs/taurus.png',
      );
    case 'Gemini':
      return ZodiacInfo(
        name: l10n.zodiacGeminiName,
        dateRange: l10n.zodiacGeminiDateRange,
        description: l10n.zodiacGeminiDescription,
        assetPath: 'assets/signs/gemini.png',
      );
    case 'Cancer':
      return ZodiacInfo(
        name: l10n.zodiacCancerName,
        dateRange: l10n.zodiacCancerDateRange,
        description: l10n.zodiacCancerDescription,
        assetPath: 'assets/signs/cancer.png',
      );
    case 'Leo':
      return ZodiacInfo(
        name: l10n.zodiacLeoName,
        dateRange: l10n.zodiacLeoDateRange,
        description: l10n.zodiacLeoDescription,
        assetPath: 'assets/signs/leo.png',
      );
    case 'Virgo':
      return ZodiacInfo(
        name: l10n.zodiacVirgoName,
        dateRange: l10n.zodiacVirgoDateRange,
        description: l10n.zodiacVirgoDescription,
        assetPath: 'assets/signs/virgo.png',
      );
    case 'Libra':
      return ZodiacInfo(
        name: l10n.zodiacLibraName,
        dateRange: l10n.zodiacLibraDateRange,
        description: l10n.zodiacLibraDescription,
        assetPath: 'assets/signs/libra.png',
      );
    case 'Scorpio':
      return ZodiacInfo(
        name: l10n.zodiacScorpioName,
        dateRange: l10n.zodiacScorpioDateRange,
        description: l10n.zodiacScorpioDescription,
        assetPath: 'assets/signs/scorpio.png',
      );
    case 'Sagittarius':
      return ZodiacInfo(
        name: l10n.zodiacSagittariusName,
        dateRange: l10n.zodiacSagittariusDateRange,
        description: l10n.zodiacSagittariusDescription,
        assetPath: 'assets/signs/sagittarius.png',
      );
    default:
      return ZodiacInfo(
        name: l10n.zodiacCapricornName,
        dateRange: l10n.zodiacCapricornDateRange,
        description: l10n.zodiacCapricornDescription,
        assetPath: 'assets/signs/capricorn.png',
      );
  }
}

// Calculate zodiac sign based on month and day
String getZodiacSign(int month, int day) {
  // Month is 0-indexed (0 = January, 11 = December)
  if ((month == 0 && day >= 20) || (month == 1 && day <= 18)) {
    return 'Aquarius';
  } else if ((month == 1 && day >= 19) || (month == 2 && day <= 20)) {
    return 'Pisces';
  } else if ((month == 2 && day >= 21) || (month == 3 && day <= 19)) {
    return 'Aries';
  } else if ((month == 3 && day >= 20) || (month == 4 && day <= 20)) {
    return 'Taurus';
  } else if ((month == 4 && day >= 21) || (month == 5 && day <= 20)) {
    return 'Gemini';
  } else if ((month == 5 && day >= 21) || (month == 6 && day <= 22)) {
    return 'Cancer';
  } else if ((month == 6 && day >= 23) || (month == 7 && day <= 22)) {
    return 'Leo';
  } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
    return 'Virgo';
  } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
    return 'Libra';
  } else if ((month == 9 && day >= 23) || (month == 10 && day <= 21)) {
    return 'Scorpio';
  } else if ((month == 10 && day >= 22) || (month == 11 && day <= 21)) {
    return 'Sagittarius';
  } else {
    // December 22 - January 19
    return 'Capricorn';
  }
}

// Get tattoo styles list
List<TattooStyleItem> getTattooStyles(BuildContext context, bool isDark) {
  final l10n = AppLocalizations.of(context)!;

  return [
    TattooStyleItem(label: l10n.styleDragon, assetPath: 'assets/dragon.png'),
    TattooStyleItem(label: l10n.styleUnicorn, assetPath: 'assets/unicorn.png'),
    TattooStyleItem(label: l10n.styleFloral, assetPath: 'assets/floral.png'),
    TattooStyleItem(
      label: l10n.styleAbstract,
      assetPath: isDark
          ? 'assets/abstract_dark.png'
          : 'assets/abstract_light.png',
    ),
    TattooStyleItem(
      label: l10n.styleButterfly,
      assetPath: isDark
          ? 'assets/butterfly_dark.png'
          : 'assets/butterfly_light.png',
    ),
    TattooStyleItem(
      label: l10n.styleEagle,
      assetPath: isDark ? 'assets/eagle_dark.png' : 'assets/eagle_light.png',
    ),
    TattooStyleItem(
      label: l10n.styleLion,
      assetPath: isDark ? 'assets/lion_dark.png' : 'assets/lion_light.png',
    ),
    TattooStyleItem(
      label: l10n.styleSpider,
      assetPath: isDark ? 'assets/spider_dark.png' : 'assets/spider_light.png',
    ),
    TattooStyleItem(
      label: l10n.styleWolf,
      assetPath: isDark ? 'assets/wolf_dark.png' : 'assets/wolf_light.png',
    ),
  ];
}
