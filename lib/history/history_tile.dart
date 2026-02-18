import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/favorites_provider.dart';
import '../services/history_service.dart';
import '../utils/colors.dart';
import '../utils/style_localization.dart';
import '../utils/toast.dart';

class HistoryTile extends StatefulWidget {
  final Map<String, dynamic> entry;
  final String type;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteChanged;

  /// Called after entry is deleted (remove from list). Favorite toggle does not call this.
  final VoidCallback? onDeleted;

  const HistoryTile({
    super.key,
    required this.entry,
    required this.type,
    required this.isDark,
    required this.onTap,
    this.onFavoriteChanged,
    this.onDeleted,
  });

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
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
