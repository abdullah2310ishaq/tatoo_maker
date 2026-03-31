import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tatoo_maker/history/favorites_page.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import 'package:tatoo_maker/language/language_screen.dart';
import 'package:tatoo_maker/pro_access_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home_shell.dart';
import '../utils/colors.dart';
import 'inkvision_underline.dart';

class AppDrawer extends StatefulWidget {
  final bool isDarkTheme;
  final VoidCallback onThemeToggle;

  const AppDrawer({
    super.key,
    required this.isDarkTheme,
    required this.onThemeToggle,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isProcessing = false;

  void _handleTap(VoidCallback onTap) {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    onTap();

    // Reset after a short delay to prevent multiple taps
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final textColor = isDark ? AppColors.textWhite : AppColors.buttonBackground;
    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final iconColor = isDark ? AppColors.textWhite : AppColors.buttonBackground;

    return Drawer(
      backgroundColor: backgroundColor,
      child: Theme(
        data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
        child: SafeArea(
          child: Column(
            children: [
              // Header with InkVision title and underline
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'AI Tattoo',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tomorrow',
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
                  widget.isDarkTheme ? Icons.dark_mode : Icons.light_mode,
                  color: iconColor,
                ),
                title: Text(
                  widget.isDarkTheme ? l10n.darkTheme : l10n.lightTheme,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Switch(
                  value: widget.isDarkTheme,
                  onChanged: _isProcessing
                      ? null
                      : (_) {
                          _handleTap(() => widget.onThemeToggle());
                        },
                  activeThumbColor: const Color(0xFFFE8B3A),
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
                      isEnabled: !_isProcessing,
                      onTap: () {
                        Navigator.of(context).pop(); // close drawer
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const LanguageSelectionScreen(),
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
                      isEnabled: !_isProcessing,
                      onTap: () {
                        Navigator.of(context).pop(); // close drawer
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FavoritesPage(),
                          ),
                        );
                      },
                    ),
                    // _buildMenuItem(
                    //   context: context,
                    //   icon: Icons.workspace_premium,
                    //   title:
                    //       '${l10n.proAccessTitlePro} ${l10n.proAccessTitleAccess}',
                    //   textColor: textColor,
                    //   iconColor: iconColor,
                    //   isEnabled: !_isProcessing,
                    //   onTap: () {
                    //     Navigator.of(context).pop(); // close drawer
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (context) =>
                    //             const ProAccessScreen(nextScreen: HomeShell()),
                    //       ),
                    //     );
                    //   },
                    // ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.star,
                      title: l10n.rateUs,
                      textColor: textColor,
                      iconColor: iconColor,
                      isEnabled: !_isProcessing,
                      onTap: () {
                        // Close the drawer first
                        Navigator.of(context).pop();
                        // Open the app's Play Store page
                        _openExternalUrl(
                          'https://play.google.com/store/apps/details?id=com.tattoo.generator.ai.tattoo.tattoo.maker.name.tattoo',
                        );
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.privacy_tip,
                      title: l10n.privacyPolicy,
                      textColor: textColor,
                      iconColor: iconColor,
                      isEnabled: !_isProcessing,
                      onTap: () {
                        _openExternalUrl(
                          'https://sites.google.com/view/tattoogeneratoraitattoo/home',
                        );
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.share,
                      title: l10n.shareApp,
                      textColor: textColor,
                      iconColor: iconColor,
                      isEnabled: !_isProcessing,
                      onTap: _shareApp,
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.feedback,
                      title: l10n.feedback,
                      textColor: textColor,
                      iconColor: iconColor,
                      isEnabled: !_isProcessing,
                      onTap: _sendFeedbackEmail,
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.people,
                      title: l10n.communityGuidelines,
                      textColor: textColor,
                      iconColor: iconColor,
                      isEnabled: !_isProcessing,
                      onTap: () {
                        _openExternalUrl(
                          'https://sites.google.com/view/tattoogeneratoraitattoo/community-guidelines',
                        );
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.apps,
                      title: l10n.moreApps,
                      textColor: textColor,
                      iconColor: iconColor,
                      showAdBadge: true,
                      isEnabled: !_isProcessing,
                      onTap: () {
                        _openExternalUrl(
                          'https://play.google.com/store/search?q=pub%3ACodix%20Apps&c=apps',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return;
    }

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Intentionally ignore errors to avoid crashing the app.
    }
  }

  Future<void> _sendFeedbackEmail() async {
    final uri = Uri(scheme: 'mailto', path: 'islam24hoursstudio@gmail.com');

    try {
      await launchUrl(uri);
    } catch (_) {
      // Intentionally ignore errors to avoid crashing the app.
    }
  }

  Future<void> _shareApp() async {
    const appUrl =
        'https://play.google.com/store/apps/details?id=com.tattoo.generator.ai.tattoo.tattoo.maker.name.tattoo';
    try {
      await Share.share(appUrl);
    } catch (_) {
      // Intentionally ignore errors to avoid crashing the app.
    }
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? trailingText,
    required Color textColor,
    required Color iconColor,
    bool showAdBadge = false,
    bool isEnabled = true,
    required VoidCallback onTap,
  }) {
    return ListTile(
      enabled: isEnabled,
      leading: Icon(
        icon,
        color: isEnabled ? iconColor : iconColor.withOpacity(0.5),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isEnabled ? textColor : textColor.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: null,
            ),
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
              style: TextStyle(
                color: AppColors.textGrey.withOpacity(isEnabled ? 1.0 : 0.5),
                fontSize: 14,
              ),
            ),
          if (trailingText != null) const SizedBox(width: 8),
          Icon(
            CupertinoIcons.chevron_right,
            size: 16,
            color: AppColors.textGrey.withOpacity(isEnabled ? 1.0 : 0.5),
          ),
        ],
      ),
      onTap: isEnabled ? () => _handleTap(onTap) : null,
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
