import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../creation/result_screen.dart';
import '../flower/flower_result_screen.dart';
import '../l10n/app_localizations.dart';
import '../services/history_service.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../utils/toast.dart';
import '../utils/style_localization.dart';
import '../providers/favorites_provider.dart';
import 'package:provider/provider.dart';

/// [tabIndex] 0 = show 3 options (Creation, Tattoo, Flower); 1 = Tattoo only; 2 = Flower only.
class HistoryPage extends StatefulWidget {
  final int tabIndex;
  final bool openFavorites;

  const HistoryPage({
    super.key,
    required this.tabIndex,
    this.openFavorites = false,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _creation = [];
  List<Map<String, dynamic>> _tattoo = [];
  List<Map<String, dynamic>> _flower = [];
  List<Map<String, dynamic>> _favorites = [];
  bool _loading = true;
  bool _openedFavoritesOnce = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final creation = await HistoryService.getCreationHistory();
    final tattoo = await HistoryService.getTattooHistory();
    final flower = await HistoryService.getFlowerHistory();

    // Load favorites from provider
    final favoritesProvider = Provider.of<FavoritesProvider>(
      context,
      listen: false,
    );
    await favoritesProvider.loadFavorites();
    final favorites = await HistoryService.getFavorites();

    if (mounted) {
      setState(() {
        _creation = creation;
        _tattoo = tattoo;
        _flower = flower;
        _favorites = favorites;
        _loading = false;
      });
    }

    if (mounted && widget.openFavorites && !_openedFavoritesOnce) {
      _openedFavoritesOnce = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context)!;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        _openFavoritesPage(context, isDark, l10n);
      });
    }
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
                      l10n.history,
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
              if (_loading)
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.navBarActive,
                    ),
                  ),
                )
              else
                Expanded(
                  child: widget.tabIndex == 0
                      ? _buildFourOptions(context, isDark, l10n)
                      : widget.tabIndex == 1
                      ? _buildList(context, isDark, l10n, _tattoo, 'tattoo')
                      : _buildList(context, isDark, l10n, _flower, 'flower'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFourOptions(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionCard(
            title: l10n.creation,
            count: _creation.length,
            isDark: isDark,
            onTap: () => _openListPage(context, 0, l10n.creation),
          ),
          SizedBox(height: 12.h),
          _SectionCard(
            title: l10n.tattoo,
            count: _tattoo.length,
            isDark: isDark,
            onTap: () => _openListPage(context, 1, l10n.tattoo),
          ),
          SizedBox(height: 12.h),
          _SectionCard(
            title: l10n.flower,
            count: _flower.length,
            isDark: isDark,
            onTap: () => _openListPage(context, 2, l10n.flower),
          ),
          SizedBox(height: 12.h),
          _SectionCard(
            title: l10n.favorites,
            count: _favorites.length,
            isDark: isDark,
            onTap: () => _openFavoritesPage(context, isDark, l10n),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  void _openFavoritesPage(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => _HistoryListPage(
              title: l10n.favorites,
              items: _favorites,
              type: 'favorites',
            ),
          ),
        )
        .then((_) {
          // When returning from favorites list, reload all history sections
          // so counts and favorites stay in sync.
          if (mounted) _load();
        });
  }

  void _openListPage(BuildContext context, int type, String title) {
    final list = type == 0
        ? _creation
        : type == 1
        ? _tattoo
        : _flower;
    final typeStr = type == 0
        ? 'creation'
        : type == 1
        ? 'tattoo'
        : 'flower';
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) =>
                _HistoryListPage(title: title, items: list, type: typeStr),
          ),
        )
        .then((_) {
          // When returning from any list page, reload data so counts and
          // favorites status are up to date on the main history screen.
          if (mounted) _load();
        });
  }

  Widget _buildList(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
    List<Map<String, dynamic>> items,
    String type,
  ) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          l10n.noHistoryYet,
          style: TextStyle(fontSize: 16.sp, color: AppColors.textGrey),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _HistoryTile(
          entry: items[index],
          type: type,
          isDark: isDark,
          onTap: () => _openResult(context, items[index], type, l10n),
          // Always reload history data when a favorite is toggled so counts
          // and the favorites section stay in sync across the whole app.
          onFavoriteChanged: () => _load(),
        );
      },
    );
  }

  void _openResult(
    BuildContext context,
    Map<String, dynamic> entry,
    String type,
    AppLocalizations l10n,
  ) {
    final bytes = HistoryService.imageBytesFromEntry(entry);
    if (bytes == null) return;

    // Determine actual type from entry (for favorites)
    final hasName =
        entry['name'] != null && (entry['name'] as String).isNotEmpty;
    final hasStyleName =
        entry['styleName'] != null && (entry['styleName'] as String).isNotEmpty;

    if (type == 'flower' || (type == 'favorites' && hasName && !hasStyleName)) {
      final name = entry['name'] as String? ?? '';
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              FlowerResultScreen(name: name, generatedImageBytes: bytes),
        ),
      );
    } else {
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

class _SectionCard extends StatelessWidget {
  final String title;
  final int count;
  final bool isDark;
  final VoidCallback onTap;

  const _SectionCard({
    required this.title,
    required this.count,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? const Color(0xFF151411) : AppColors.lightCardBackground,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Row(
            children: [
              SvgPicture.asset('assets/folder.svg', width: 24.w, height: 24.w),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textWhite : AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '$count',
                style: TextStyle(fontSize: 14.sp, color: AppColors.textGrey),
              ),
              SizedBox(width: 8.w),
              Icon(Icons.chevron_right, color: AppColors.textGrey, size: 24.sp),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryListPage extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final String type;

  const _HistoryListPage({
    required this.title,
    required this.items,
    required this.type,
  });

  @override
  State<_HistoryListPage> createState() => _HistoryListPageState();
}

class _HistoryListPageState extends State<_HistoryListPage> {
  late List<Map<String, dynamic>> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.items;
  }

  Future<void> _reloadFavorites() async {
    if (widget.type == 'favorites') {
      final favs = await HistoryService.getFavorites();
      if (mounted) {
        setState(() => _items = favs);
      }
    }
  }

  void _removeEntryLocally(Map<String, dynamic> entry) {
    if (!mounted) return;
    setState(() {
      _items.remove(entry);
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
                      widget.title,
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
              Expanded(
                child: _items.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noHistoryYet,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.textGrey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final entry = _items[index];
                          return _HistoryTile(
                            entry: entry,
                            type: widget.type,
                            isDark: isDark,
                            onFavoriteChanged: widget.type == 'favorites'
                                ? _reloadFavorites
                                : null,
                            onDeleted: widget.type == 'favorites'
                                ? null
                                : () => _removeEntryLocally(entry),
                            onTap: () {
                              final bytes = HistoryService.imageBytesFromEntry(
                                entry,
                              );
                              if (bytes == null) return;

                              final hasName =
                                  entry['name'] != null &&
                                  (entry['name'] as String).isNotEmpty;
                              final hasStyleName =
                                  entry['styleName'] != null &&
                                  (entry['styleName'] as String).isNotEmpty;

                              if (widget.type == 'flower' ||
                                  (widget.type == 'favorites' &&
                                      hasName &&
                                      !hasStyleName)) {
                                final name = entry['name'] as String? ?? '';
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FlowerResultScreen(
                                      name: name,
                                      generatedImageBytes: bytes,
                                    ),
                                  ),
                                );
                              } else {
                                final styleName =
                                    entry['styleName'] as String? ??
                                    l10n.genericTattoo;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ResultScreen(
                                      styleName: styleName,
                                      promptText:
                                          entry['promptText'] as String?,
                                      generatedImageBytes: bytes,
                                    ),
                                  ),
                                );
                              }
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
}

class _HistoryTile extends StatefulWidget {
  final Map<String, dynamic> entry;
  final String type;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteChanged;

  /// Called after entry is deleted (remove from list). Favorite toggle does not call this.
  final VoidCallback? onDeleted;

  const _HistoryTile({
    required this.entry,
    required this.type,
    required this.isDark,
    required this.onTap,
    this.onFavoriteChanged,
    this.onDeleted,
  });

  @override
  State<_HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<_HistoryTile> {
  Future<void> _deleteEntry(BuildContext context) async {
    final favoritesProvider = Provider.of<FavoritesProvider>(
      context,
      listen: false,
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(l10n.deleteConfirmationTitle),
          content: Text(l10n.deleteConfirmationContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                l10n.cancel,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.delete, style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    // For favorites list, also update the global favorites provider so icons
    // across the app stay in sync.
    if (widget.type == 'favorites') {
      await favoritesProvider.removeFromFavorites(widget.entry);
    }

    try {
      await HistoryService.deleteEntry(widget.type, widget.entry);
      if (!mounted) return;

      widget.onDeleted?.call();
      widget.onFavoriteChanged?.call();
    } catch (e) {
      debugPrint('Error deleting entry: $e');
      if (mounted) {
        AppToast.show(
          context,
          message: 'Error deleting entry',
          isSuccess: false,
        );
      }
    }
  }

  Future<void> _toggleFavorite(BuildContext context) async {
    final favoritesProvider = Provider.of<FavoritesProvider>(
      context,
      listen: false,
    );
    final wasFavorited = favoritesProvider.isFavorited(widget.entry);

    final success = await favoritesProvider.toggleFavorite(widget.entry);
    if (!mounted || !success) return;

    final l10n = AppLocalizations.of(context)!;
    AppToast.show(
      context,
      message: wasFavorited ? l10n.favoritesRemoved : l10n.favoritesAdded,
      isSuccess: true,
    );
    widget.onFavoriteChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final bytes = HistoryService.imageBytesFromEntry(widget.entry);
    final label = widget.type == 'flower'
        ? (widget.entry['name'] as String? ?? '')
        : getLocalizedStyleName(l10n, widget.entry['styleName'] as String?);
    final isFavorited = favoritesProvider.isFavorited(widget.entry);
    final isLoadingFavorite = favoritesProvider.isLoading;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: widget.isDark
            ? const Color(0xFF151411)
            : AppColors.lightCardBackground,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: widget.onTap,
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                if (bytes != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.memory(
                      bytes,
                      width: 64.w,
                      height: 64.w,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      color: AppColors.textGrey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppColors.textGrey,
                    ),
                  ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    label.isEmpty ? '—' : label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: widget.isDark
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Favorite button
                IconButton(
                  icon: isLoadingFavorite
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: widget.isDark
                                ? AppColors.textWhite
                                : AppColors.textPrimary,
                          ),
                        )
                      : Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited
                              ? Colors.red
                              : (widget.isDark
                                    ? AppColors.textGrey
                                    : AppColors.textGrey),
                          size: 24.sp,
                        ),
                  onPressed: () => _toggleFavorite(context),
                ),
                // Delete button
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppColors.textGrey,
                    size: 22.sp,
                  ),
                  onPressed: () => _deleteEntry(context),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textGrey,
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
