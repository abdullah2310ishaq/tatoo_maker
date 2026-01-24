import '../models/onboarding_models.dart';

// Zodiac data
final Map<String, ZodiacInfo> zodiacData = {
  'Capricorn': ZodiacInfo(
    name: 'Capricorn',
    dateRange: 'December 22 – January 19',
    description:
        'Disciplined and ambitious, with a grounded and responsible nature. They value success and prefer building their future through patience and hard work.',
    assetPath: 'assets/signs/capricorn.png',
  ),
  'Aquarius': ZodiacInfo(
    name: 'Aquarius',
    dateRange: 'January 20 – February 18',
    description:
        'Independent and creative, with a free-spirited and original nature. They value freedom and prefer expressing their individuality with unique ideas.',
    assetPath: 'assets/signs/aquarius.png',
  ),
  'Pisces': ZodiacInfo(
    name: 'Pisces',
    dateRange: 'February 19 – March 20',
    description:
        'Gentle and dreamy, with a sensitive and compassionate nature. They value emotions and prefer living through imagination, kindness, and deep understanding.',
    assetPath: 'assets/signs/pisces.png',
  ),
  'Aries': ZodiacInfo(
    name: 'Aries',
    dateRange: 'March 21 – April 19',
    description:
        'Bold and energetic, with a confident and fearless nature. They love taking initiative and prefer leading with passion and determination.',
    assetPath: 'assets/signs/aries.png',
  ),
  'Taurus': ZodiacInfo(
    name: 'Taurus',
    dateRange: 'April 20 – May 20',
    description:
        'Bold and energetic, with a confident and fearless nature. They love taking initiative and prefer leading with passion and determination.',
    assetPath: 'assets/signs/taurus.png',
  ),
  'Gemini': ZodiacInfo(
    name: 'Gemini',
    dateRange: 'May 21 – June 20',
    description:
        'Curious and lively, with a quick-minded and adaptable nature. They enjoy communication and prefer exploring new ideas with excitement.',
    assetPath: 'assets/signs/gemini.png',
  ),
  'Cancer': ZodiacInfo(
    name: 'Cancer',
    dateRange: 'June 21 – July 22',
    description:
        'Sensitive and caring, with a deeply emotional and protective nature. They value close connections and prefer nurturing others with warmth and loyalty.',
    assetPath: 'assets/signs/cancer.png',
  ),
  'Leo': ZodiacInfo(
    name: 'Leo',
    dateRange: 'July 23 – August 22',
    description:
        'Confident and charismatic, with a bold and generous nature. They enjoy being admired and prefer expressing themselves with creativity and pride.',
    assetPath: 'assets/signs/leo.png',
  ),
  'Virgo': ZodiacInfo(
    name: 'Virgo',
    dateRange: 'August 23 – September 22',
    description:
        'Practical and thoughtful, with a detail-focused and hardworking nature. They value discipline and prefer bringing order and care into everything they do.',
    assetPath: 'assets/signs/virgo.png',
  ),
  'Libra': ZodiacInfo(
    name: 'Libra',
    dateRange: 'September 23 – October 22',
    description:
        'Charming and balanced, with a peaceful and fair-minded nature. They value harmony and prefer building connections through kindness and understanding.',
    assetPath: 'assets/signs/libra.png',
  ),
  'Scorpio': ZodiacInfo(
    name: 'Scorpio',
    dateRange: 'October 23 – November 21',
    description:
        'Intense and passionate, with a powerful and mysterious nature. They value loyalty and prefer deep connections built on trust and strength.',
    assetPath: 'assets/signs/scorpio.png',
  ),
  'Sagittarius': ZodiacInfo(
    name: 'Sagittarius',
    dateRange: 'November 22 – December 21',
    description:
        'Adventurous and optimistic, with a free-loving and curious nature. They value exploration and prefer chasing new experiences with excitement and independence.',
    assetPath: 'assets/signs/sagittarius.png',
  ),
};

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
List<TattooStyleItem> getTattooStyles(bool isDark) {
  return [
    const TattooStyleItem(label: 'Dragon', assetPath: 'assets/dragon.png'),
    const TattooStyleItem(label: 'Unicorn', assetPath: 'assets/unicorn.png'),
    const TattooStyleItem(label: 'Floral', assetPath: 'assets/floral.png'),
    TattooStyleItem(
      label: 'Abstract',
      assetPath: isDark
          ? 'assets/abstract_dark.png'
          : 'assets/abstract_light.png',
    ),
    TattooStyleItem(
      label: 'Butterfly',
      assetPath: isDark
          ? 'assets/butterfly_dark.png'
          : 'assets/butterfly_light.png',
    ),
    TattooStyleItem(
      label: 'Eagle',
      assetPath: isDark ? 'assets/eagle_dark.png' : 'assets/eagle_light.png',
    ),
    TattooStyleItem(
      label: 'Lion',
      assetPath: isDark ? 'assets/lion_dark.png' : 'assets/lion_light.png',
    ),
    TattooStyleItem(
      label: 'Spider',
      assetPath: isDark ? 'assets/spider_dark.png' : 'assets/spider_light.png',
    ),
    TattooStyleItem(
      label: 'Wolf',
      assetPath: isDark ? 'assets/wolf_dark.png' : 'assets/wolf_light.png',
    ),
  ];
}
