import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../creation/result_screen.dart';
import '../flower/flower_result_screen.dart';
import '../l10n/app_localizations.dart';
import '../services/history_service.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../providers/favorites_provider.dart';
import '../utils/toast.dart';
import 'package:provider/provider.dart';
import '../utils/style_localization.dart';

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
  int _activeTab = 0; // 0=Creation, 1=Tattoo, 2=Flower (for tabIndex==0)

  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _activeTab = widget.openFavorites
        ? 3
        : widget.tabIndex == 1
        ? 1
        : widget.tabIndex == 2
        ? 2
        : 0;
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
    final items = _currentItems;
    final type = _currentType;

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
                    Expanded(
                      child: Text(
                        _isSelectionMode
                            ? l10n.historySelected(_selectedIds.length)
                            : l10n.history,
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
                    if (!_loading && items.isNotEmpty) ...[
                      if (_isSelectionMode) ...[
                        TextButton(
                          onPressed: _selectAllCurrent,
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
              if (!_loading && widget.tabIndex == 0)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: _buildTabs(context, isDark, l10n),
                ),
              if (!_loading && widget.tabIndex == 0) SizedBox(height: 10.h),
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
                      ? (_activeTab == 3
                          ? Consumer<FavoritesProvider>(
                              builder: (context, favoritesProvider, _) {
                                final favItems = favoritesProvider.favorites;
                                return _buildGrid(
                                  context,
                                  isDark,
                                  l10n,
                                  favItems,
                                  'favorites',
                                );
                              },
                            )
                          : _buildGrid(context, isDark, l10n, items, type))
                      : widget.tabIndex == 1
                      ? _buildGrid(context, isDark, l10n, _tattoo, 'tattoo')
                      : _buildGrid(context, isDark, l10n, _flower, 'flower'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _currentItems {
    if (widget.tabIndex == 1) return _tattoo;
    if (widget.tabIndex == 2) return _flower;
    return _activeTab == 0
        ? _creation
        : _activeTab == 1
        ? _tattoo
        : _activeTab == 2
        ? _flower
        : const <Map<String, dynamic>>[];
  }

  String get _currentType {
    if (widget.tabIndex == 1) return 'tattoo';
    if (widget.tabIndex == 2) return 'flower';
    return _activeTab == 0
        ? 'creation'
        : _activeTab == 1
        ? 'tattoo'
        : _activeTab == 2
        ? 'flower'
        : 'favorites';
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

  void _selectAllCurrent() {
    final items = _currentItems;
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

  Future<void> _deleteSelected() async {
    final items = _currentItems;
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
              child: Text(
                l10n.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final entriesToDelete = items
        .where((e) => _selectedIds.contains(HistoryService.generateEntryId(e)))
        .toList();

    if (_currentType == 'favorites') {
      final favoritesProvider = Provider.of<FavoritesProvider>(
        context,
        listen: false,
      );
      for (final entry in entriesToDelete) {
        await favoritesProvider.removeFromFavorites(entry);
      }
    }

    await HistoryService.deleteEntries(_currentType, entriesToDelete);

    if (!mounted) return;
    AppToast.show(context, message: l10n.tattooDeleted, isSuccess: true);

    setState(() {
      _selectedIds.clear();
      _isSelectionMode = false;
    });

    await _load();
  }

  Widget _buildTabs(BuildContext context, bool isDark, AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip(l10n.creation, 0, isDark),
          SizedBox(width: 9.w),
          _chip(l10n.tattoo, 1, isDark),
          SizedBox(width: 9.w),
          _chip(l10n.flower, 2, isDark),
          SizedBox(width: 9.w),
          _chip(l10n.favorites, 3, isDark),
        ],
      ),
    );
  }

  Widget _chip(String label, int tab, bool isDark) {
    final selected = _activeTab == tab;
    return SizedBox(
      width: 106.w,
      height: 38.h,
      child: ChoiceChip(
        label: SizedBox(
          width: double.infinity,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: selected
                  ? Colors.white
                  : (isDark ? AppColors.textGrey : AppColors.textPrimary),
              fontFamily: 'Amaranth',
            ),
          ),
        ),
        selected: selected,
        onSelected: (_) {
          setState(() {
            _activeTab = tab;
            _isSelectionMode = false;
            _selectedIds.clear();
          });
        },
        selectedColor: const Color(0xFFA6541D),
        backgroundColor: isDark
            ? const Color(0xFF151411)
            : AppColors.lightCardBackground,
        side: BorderSide(
          color: selected
              ? const Color(0xFFA6541D)
              : AppColors.textGrey.withValues(alpha: 0.3),
        ),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildGrid(
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
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final entry = items[index];
        final entryId = HistoryService.generateEntryId(entry);
        return _HistoryGridItem(
          entry: entry,
          type: type,
          isDark: isDark,
          isSelectionMode: _isSelectionMode,
          isSelected: _selectedIds.contains(entryId),
          onTap: () {
            if (_isSelectionMode) {
              _toggleSelection(entryId);
              return;
            }
            _openResult(context, entry, type, l10n);
          },
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

class _HistoryGridItem extends StatelessWidget {
  final Map<String, dynamic> entry;
  final bool isDark;
  final String type;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;

  const _HistoryGridItem({
    required this.entry,
    required this.isDark,
    required this.type,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bytes = HistoryService.imageBytesFromEntry(entry);
    final hasName =
        entry['name'] != null && (entry['name'] as String).isNotEmpty;
    final hasStyleName =
        entry['styleName'] != null && (entry['styleName'] as String).isNotEmpty;
    final isFlowerType =
        type == 'flower' || (type == 'favorites' && hasName && !hasStyleName);
    final label = isFlowerType
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
                      color: isDark
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
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
                    : GridView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 1,
                        ),
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final entry = _items[index];
                          final entryId = HistoryService.generateEntryId(entry);
                          return _HistoryGridItem(
                            entry: entry,
                            isDark: isDark,
                            type: widget.type,
                            isSelectionMode: _isSelectionMode,
                            isSelected: _selectedIds.contains(entryId),
                            onTap: () {
                              if (_isSelectionMode) {
                                _toggleSelection(entryId);
                                return;
                              }

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
