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
import '../utils/style_localization.dart';
import '../utils/toast.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    // Ensure favorites are loaded when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoritesProvider>(context, listen: false).loadFavorites();
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      _selectedIds.clear();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _selectAll(List<Map<String, dynamic>> items) {
    setState(() {
      if (_selectedIds.length == items.length) {
        _selectedIds.clear();
      } else {
        _selectedIds
          ..clear()
          ..addAll(items.map(HistoryService.generateEntryId));
      }
    });
  }

  Future<void> _deleteSelected(List<Map<String, dynamic>> items) async {
    if (_selectedIds.isEmpty) return;

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(l10n.deleteConfirmationTitle),
          content: Text(
            '${l10n.deleteConfirmationContent} (${_selectedIds.length})',
          ),
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
              child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final favoritesProvider = Provider.of<FavoritesProvider>(
      context,
      listen: false,
    );

    final entriesToDelete = items
        .where((e) => _selectedIds.contains(HistoryService.generateEntryId(e)))
        .toList();

    for (final entry in entriesToDelete) {
      await favoritesProvider.removeFromFavorites(entry);
    }

    if (!mounted) return;

    AppToast.show(
      context,
      message: l10n.tattooDeleted,
      isSuccess: true,
    );

    setState(() {
      _selectedIds.clear();
      _isSelectionMode = false;
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
                    if (_isSelectionMode)
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: isDark
                              ? AppColors.textWhite
                              : AppColors.textPrimary,
                          size: 24.sp,
                        ),
                        onPressed: _toggleSelectionMode,
                      )
                    else
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
                    Expanded(
                      child: Text(
                        _isSelectionMode
                            ? l10n.historySelected(_selectedIds.length)
                            : l10n.favorites,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textWhite
                            : AppColors.textPrimary,
                        fontFamily: 'Amaranth',
                      ),
                    ),
                    ),
                    Consumer<FavoritesProvider>(
                      builder: (context, favoritesProvider, _) {
                        final items = favoritesProvider.favorites;
                        if (items.isEmpty) return const SizedBox.shrink();

                        if (_isSelectionMode) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () => _selectAll(items),
                                child: Text(
                                  _selectedIds.length == items.length
                                      ? l10n.historyDeselectAll
                                      : l10n.historySelectAll,
                                  style: TextStyle(
                                    color: AppColors.navBarActive,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 24.sp,
                                ),
                                onPressed: _selectedIds.isEmpty
                                    ? null
                                    : () => _deleteSelected(items),
                              ),
                            ],
                          );
                        }

                        return TextButton(
                          onPressed: _toggleSelectionMode,
                          child: Text(
                            l10n.historySelect,
                            style: TextStyle(
                              color: AppColors.navBarActive,
                              fontSize: 16.sp,
                            ),
                          ),
                        );
                      },
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

                    return GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 1,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final entry = items[index];
                        final entryId = HistoryService.generateEntryId(entry);
                        return _FavoriteGridItem(
                          entry: entry,
                          isDark: isDark,
                          isSelectionMode: _isSelectionMode,
                          isSelected: _selectedIds.contains(entryId),
                          onTap: () {
                            if (_isSelectionMode) {
                              _toggleSelection(entryId);
                              return;
                            }
                            _openResult(context, entry, l10n);
                          },
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

class _FavoriteGridItem extends StatelessWidget {
  final Map<String, dynamic> entry;
  final bool isDark;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;

  const _FavoriteGridItem({
    required this.entry,
    required this.isDark,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bytes = HistoryService.imageBytesFromEntry(entry);
    final hasName = entry['name'] != null && (entry['name'] as String).isNotEmpty;
    final hasStyleName =
        entry['styleName'] != null && (entry['styleName'] as String).isNotEmpty;
    final type = (hasName && !hasStyleName) ? 'flower' : 'tattoo';
    final label = type == 'flower'
        ? (entry['name'] as String? ?? '')
        : getLocalizedStyleName(l10n, entry['styleName'] as String?);

    return Material(
      color: isDark ? const Color(0xFF151411) : AppColors.lightCardBackground,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: bytes == null
                          ? Container(
                              color: AppColors.textGrey.withValues(alpha: 0.2),
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppColors.textGrey,
                                size: 28.sp,
                              ),
                            )
                          : Image.memory(bytes, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    label.isEmpty ? '—' : label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textWhite : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (isSelectionMode)
              PositionedDirectional(
                top: 10.h,
                end: 10.w,
                child: Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFE8B3A)
                        : Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFE8B3A)
                          : AppColors.textGrey.withValues(alpha: 0.6),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 14.sp,
                    color: isSelected ? Colors.white : Colors.transparent,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
