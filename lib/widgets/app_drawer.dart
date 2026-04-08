import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import 'package:tatoo_maker/language/language_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/asset_sync_provider.dart';
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
  bool _showDeveloperTools = false;

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
                    GestureDetector(
                      onLongPress: kDebugMode
                          ? () {
                              setState(() {
                                _showDeveloperTools = !_showDeveloperTools;
                              });
                            }
                          : null,
                      child: Text(
                        'AI Tattoo',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontFamily: 'Tomorrow',
                        ),
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
                    if (kDebugMode && _showDeveloperTools) ...[
                      const Divider(height: 1),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.cloud_upload,
                        title: 'Developer: Sync assets to Firebase',
                        textColor: textColor,
                        iconColor: iconColor,
                        isEnabled: !_isProcessing,
                        onTap: () async {
                          Navigator.of(context).pop();
                          await _showAssetSyncDialog(context);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAssetSyncDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(dialogContext).brightness == Brightness.dark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          title: const Text('Asset sync'),
          content: Consumer<AssetSyncProvider>(
            builder: (context, provider, _) {
              final error = provider.errorMessage;
              return SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.isSyncDone
                          ? 'Status: synced'
                          : 'Status: not synced',
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 12),
                    if (provider.isSyncing) ...[
                      LinearProgressIndicator(value: provider.progress),
                      const SizedBox(height: 8),
                      Text(
                        provider.currentAsset ?? 'Working…',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                    ],
                    if (!provider.isSyncing && error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        error,
                        style: TextStyle(color: AppColors.error),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
            Consumer<AssetSyncProvider>(
              builder: (context, provider, _) {
                return TextButton(
                  onPressed: provider.isSyncing
                      ? null
                      : () async {
                          final result =
                              await provider.syncAllAssets(force: false);
                          if (!dialogContext.mounted || result == null) return;
                          final failedCount = result.failed.length;
                          final message = failedCount == 0
                              ? 'Asset sync completed (${result.uploaded} uploaded, ${result.skipped} skipped).'
                              : 'Asset sync completed with issues (${result.uploaded} uploaded, ${result.skipped} skipped, $failedCount failed).';
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        },
                  child: const Text('Sync'),
                );
              },
            ),
            Consumer<AssetSyncProvider>(
              builder: (context, provider, _) {
                return TextButton(
                  onPressed: provider.isSyncing
                      ? null
                      : () async {
                          final result =
                              await provider.syncAllAssets(force: true);
                          if (!dialogContext.mounted || result == null) return;
                          final failedCount = result.failed.length;
                          final message = failedCount == 0
                              ? 'Asset sync completed (${result.uploaded} uploaded).'
                              : 'Asset sync completed with issues (${result.uploaded} uploaded, $failedCount failed).';
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        },
                  child: const Text('Force re-sync'),
                );
              },
            ),
          ],
        );
      },
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
                  color: AppColors.textWhite,
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
