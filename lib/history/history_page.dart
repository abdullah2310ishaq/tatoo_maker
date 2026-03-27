import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../creation/result_screen.dart';
import '../flower/flower_result_screen.dart';
import '../l10n/app_localizations.dart';
import '../services/history_service.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../providers/favorites_provider.dart';
import '../utils/toast.dart';
import 'package:provider/provider.dart';
import 'history_tile.dart';

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

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final creation = await HistoryService.getCreationHistory();
    final tattoo = await HistoryService.getTattooHistory();
    final flower = await HistoryService.getFlowerHistory();

    // Load favorites from provider to ensure sync (optional here but good practice)
    final favoritesProvider = Provider.of<FavoritesProvider>(
      context,
      listen: false,
    );
    await favoritesProvider.loadFavorites();

    if (mounted) {
      setState(() {
        _creation = creation;
        _tattoo = tattoo;
        _flower = flower;
        _loading = false;
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
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105.w,
            child: _SectionCard(
              title: l10n.creation,
              isDark: isDark,
              onTap: () => _openListPage(context, 0, l10n.creation),
            ),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 105.w,
            child: _SectionCard(
              title: l10n.tattoo,
              isDark: isDark,
              onTap: () => _openListPage(context, 1, l10n.tattoo),
            ),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 105.w,
            child: _SectionCard(
              title: l10n.flower,
              isDark: isDark,
              onTap: () => _openListPage(context, 2, l10n.flower),
            ),
          ),
        ],
      ),
    );
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
                HistoryListPage(title: title, items: list, type: typeStr),
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
        return HistoryTile(
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
  final bool isDark;
  final VoidCallback onTap;

  const _SectionCard({
    required this.title,
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
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/folder.svg', width: 24.w, height: 24.w),
              SizedBox(height: 8.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textWhite : AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryListPage extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final String type;

  const HistoryListPage({
    super.key,
    required this.title,
    required this.items,
    required this.type,
  });

  @override
  State<HistoryListPage> createState() => _HistoryListPageState();
}

class _HistoryListPageState extends State<HistoryListPage> {
  late List<Map<String, dynamic>> _items;
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

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
        // Clear selection if items changed significantly or just clear to be safe
        if (_isSelectionMode) {
          // We might want to keep selection if possible, but for simplicity let's re-validate or clear
          // For now, let's just remove IDs that are no longer in the list
          final currentIds = favs.map(HistoryService.generateEntryId).toSet();
          _selectedIds.removeWhere((id) => !currentIds.contains(id));
        }
      }
    }
  }

  void _removeEntryLocally(Map<String, dynamic> entry) {
    if (!mounted) return;
    setState(() {
      _items.remove(entry);
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

  void _selectAll() {
    setState(() {
      if (_selectedIds.length == _items.length) {
        _selectedIds.clear();
      } else {
        _selectedIds.addAll(_items.map(HistoryService.generateEntryId));
      }
    });
  }

  Future<void> _deleteSelected() async {
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
              child: Text(l10n.delete, style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final entriesToDelete = _items
        .where((e) => _selectedIds.contains(HistoryService.generateEntryId(e)))
        .toList();

    // If deleting favorites, update provider
    if (widget.type == 'favorites') {
      final favoritesProvider = Provider.of<FavoritesProvider>(
        context,
        listen: false,
      );
      for (final entry in entriesToDelete) {
        await favoritesProvider.removeFromFavorites(entry);
      }
    }

    await HistoryService.deleteEntries(widget.type, entriesToDelete);

    if (!mounted) return;

    AppToast.show(
      context,
      message: AppLocalizations.of(context)!.tattooDeleted,
      isSuccess: true,
    );

    setState(() {
      _items.removeWhere(
        (e) => _selectedIds.contains(HistoryService.generateEntryId(e)),
      );
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
                            : widget.title,
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
                    if (_items.isNotEmpty) ...[
                      if (_isSelectionMode) ...[
                        TextButton(
                          onPressed: _selectAll,
                          child: Text(
                            _selectedIds.length == _items.length
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
                              : _deleteSelected,
                        ),
                      ] else ...[
                        TextButton(
                          onPressed: _toggleSelectionMode,
                          child: Text(
                            l10n.historySelect,
                            style: TextStyle(
                              color: AppColors.navBarActive,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ],
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
                          final entryId = HistoryService.generateEntryId(entry);
                          return HistoryTile(
                            entry: entry,
                            type: widget.type,
                            isDark: isDark,
                            isSelectionMode: _isSelectionMode,
                            isSelected: _selectedIds.contains(entryId),
                            onSelectionChanged: (_) =>
                                _toggleSelection(entryId),
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
