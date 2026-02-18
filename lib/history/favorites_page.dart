import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../creation/result_screen.dart';
import '../flower/flower_result_screen.dart';
import '../l10n/app_localizations.dart';
import '../providers/favorites_provider.dart';
import '../services/history_service.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import 'history_tile.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    // Ensure favorites are loaded when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoritesProvider>(context, listen: false).loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Container(
        decoration: isDark
            ? ThemeManager.darkModeBackgroundGradient
            : ThemeManager.lightModeBackground,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: isDark
                            ? AppColors.textWhite
                            : AppColors.textPrimary,
                        size: 24.sp,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      l10n.favorites,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textWhite
                            : AppColors.textPrimary,
                        fontFamily: 'Amaranth',
                      ),
                    ),
                  ],
                ),
              ),
              // List
              Expanded(
                child: Consumer<FavoritesProvider>(
                  builder: (context, favoritesProvider, child) {
                    final items = favoritesProvider.favorites;
                    if (favoritesProvider.isLoading && items.isEmpty) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.navBarActive,
                        ),
                      );
                    }

                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          l10n.noHistoryYet, // Or a specific "No favorites yet" string if available, reusing noHistoryYet for now
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.textGrey,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final entry = items[index];
                        return HistoryTile(
                          entry: entry,
                          type: 'favorites',
                          isDark: isDark,
                          onTap: () => _openResult(context, entry, l10n),
                          // No need to manually reload, Consumer handles it
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openResult(
    BuildContext context,
    Map<String, dynamic> entry,
    AppLocalizations l10n,
  ) {
    final bytes = HistoryService.imageBytesFromEntry(entry);
    if (bytes == null) return;

    final hasName =
        entry['name'] != null && (entry['name'] as String).isNotEmpty;
    final hasStyleName =
        entry['styleName'] != null && (entry['styleName'] as String).isNotEmpty;

    // Logic to distinguish flower vs tattoo result
    if (hasName && !hasStyleName) {
      // It's likely a flower result
      final name = entry['name'] as String? ?? '';
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              FlowerResultScreen(name: name, generatedImageBytes: bytes),
        ),
      );
    } else {
      // It's a tattoo result
      final styleName = entry['styleName'] as String? ?? l10n.genericTattoo;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            styleName: styleName,
            promptText: entry['promptText'] as String?,
            generatedImageBytes: bytes,
          ),
        ),
      );
    }
  }
}
