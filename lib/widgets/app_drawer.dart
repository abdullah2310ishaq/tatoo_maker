import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import 'package:tatoo_maker/language/language_screen.dart';
import '../utils/colors.dart';
import 'inkvision_underline.dart';

class AppDrawer extends StatelessWidget {
  final bool isDarkTheme;
  final VoidCallback onThemeToggle;

  const AppDrawer({
    super.key,
    required this.isDarkTheme,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final textColor = isDark ? AppColors.textWhite : AppColors.buttonBackground;
    final backgroundColor = isDark
        ? AppColors.drawerDarkBackground
        : AppColors.lightBackground;
    final iconColor = isDark ? AppColors.textWhite : AppColors.buttonBackground;

    return Drawer(
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // Header with InkVision title and underline
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'InkVision',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Amaranth',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const InkVisionUnderline(width: 120, height: 3),
                ],
              ),
            ),
            const Divider(height: 1),
            // Theme Toggle
            ListTile(
              leading: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: iconColor,
              ),
              title: Text(
                isDark ? l10n.darkTheme : l10n.lightTheme,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              ),
              trailing: Switch(
                value: isDark,
                onChanged: (_) => onThemeToggle(),
                activeColor: const Color(0xFFFE8B3A),
                activeTrackColor: const Color(0xFFFE8B3A).withOpacity(0.5),
              ),
            ),
            const Divider(height: 1),
            // Menu Items
            Expanded(
              child: ListView(
                children: [
                  _buildMenuItem(
                    context: context,
                    icon: Icons.language,
                    title: l10n.languages,
                    trailingText: _getCurrentLanguageName(context),
                    textColor: textColor,
                    iconColor: iconColor,
                    onTap: () {
                      Navigator.of(context).pop(); // close drawer
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LanguageSelectionScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.favorite,
                    title: l10n.favorites,
                    textColor: textColor,
                    iconColor: iconColor,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.star,
                    title: l10n.rateUs,
                    textColor: textColor,
                    iconColor: iconColor,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.privacy_tip,
                    title: l10n.privacyPolicy,
                    textColor: textColor,
                    iconColor: iconColor,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.share,
                    title: l10n.shareApp,
                    textColor: textColor,
                    iconColor: iconColor,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.feedback,
                    title: l10n.feedback,
                    textColor: textColor,
                    iconColor: iconColor,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.people,
                    title: l10n.communityGuidelines,
                    textColor: textColor,
                    iconColor: iconColor,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.apps,
                    title: l10n.moreApps,
                    textColor: textColor,
                    iconColor: iconColor,
                    showAdBadge: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? trailingText,
    required Color textColor,
    required Color iconColor,
    bool showAdBadge = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          if (showAdBadge) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFE8B3A),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                AppLocalizations.of(context)!.ad,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(color: AppColors.textGrey, fontSize: 14),
            ),
          if (trailingText != null) const SizedBox(width: 8),
          Icon(
            CupertinoIcons.chevron_right,
            size: 16,
            color: AppColors.textGrey,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  /// Get the current language name based on the locale
  String _getCurrentLanguageName(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;

    switch (locale.languageCode) {
      case 'en':
        return l10n.languageEnglish;
      case 'es':
        return l10n.languageSpanish;
      case 'fr':
        return l10n.languageFrench;
      case 'de':
        return l10n.languageGerman;
      case 'it':
        return l10n.languageItalian;
      case 'pt':
        return l10n.languagePortuguese;
      case 'ru':
        return l10n.languageRussian;
      case 'zh':
        return l10n.languageChinese;
      case 'ja':
        return l10n.languageJapanese;
      case 'ko':
        return l10n.languageKorean;
      case 'ar':
        return l10n.languageArabic;
      default:
        return l10n.languageEnglish;
    }
  }
}
