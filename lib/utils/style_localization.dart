import '../l10n/app_localizations.dart';
import '../models/explore_category.dart';

/// Returns the localized display name for a tattoo style key.
/// History/favorites store the key (e.g. "Dragon" or "exploreItemMinimalistPanda");
/// this returns the current language's label so the title updates when the user
/// changes language.
String getLocalizedStyleName(AppLocalizations l10n, String? styleKey) {
  if (styleKey == null || styleKey.isEmpty) return '';
  switch (styleKey) {
    case 'generic':
      return l10n.genericTattoo;
    case 'Dragon':
      return l10n.styleDragon;
    case 'Unicorn':
      return l10n.styleUnicorn;
    case 'Floral':
      return l10n.styleFloral;
    case 'Abstract':
      return l10n.styleAbstract;
    case 'Butterfly':
      return l10n.styleButterfly;
    case 'Eagle':
      return l10n.styleEagle;
    case 'Lion':
      return l10n.styleLion;
    case 'Spider':
      return l10n.styleSpider;
    case 'Wolf':
      return l10n.styleWolf;
    default:
      // Check explore items – their IDs start with 'exploreItem'.
      final exploreItem = ExploreData.findById(styleKey);
      if (exploreItem != null) return exploreItem.title(l10n);
      // Fallback: return raw key (covers pre-fix history entries).
      return styleKey;
  }
}
