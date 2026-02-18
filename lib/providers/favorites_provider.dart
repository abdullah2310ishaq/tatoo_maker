import 'package:flutter/foundation.dart';
import '../services/history_service.dart';

/// Provider for managing favorites state across the app
class FavoritesProvider extends ChangeNotifier {
  Set<String> _favoriteIds = {};
  List<Map<String, dynamic>> _favoritesList = [];
  bool _isLoading = false;

  Set<String> get favoriteIds => _favoriteIds;
  List<Map<String, dynamic>> get favorites => _favoritesList;
  bool get isLoading => _isLoading;

  /// Check if an entry is favorited
  bool isFavorited(Map<String, dynamic> entry) {
    final entryId = _generateEntryId(entry);
    return _favoriteIds.contains(entryId);
  }

  /// Load favorites from storage
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final favs = await HistoryService.getFavorites();
      _favoritesList = favs;
      _favoriteIds = favs.map((e) => _generateEntryId(e)).toSet();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add entry to favorites
  Future<bool> addToFavorites(Map<String, dynamic> entry) async {
    try {
      await HistoryService.addToFavorites(entry);
      final entryId = _generateEntryId(entry);
      _favoriteIds.add(entryId);
      _favoritesList.add(entry); // Add to local list
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
      return false;
    }
  }

  /// Remove entry from favorites
  Future<bool> removeFromFavorites(Map<String, dynamic> entry) async {
    try {
      await HistoryService.removeFromFavorites(entry);
      final entryId = _generateEntryId(entry);
      _favoriteIds.remove(entryId);

      // Remove from local list based on ID match to be safe
      _favoritesList.removeWhere((e) => _generateEntryId(e) == entryId);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
      return false;
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(Map<String, dynamic> entry) async {
    final entryId = _generateEntryId(entry);
    if (_favoriteIds.contains(entryId)) {
      return await removeFromFavorites(entry);
    } else {
      return await addToFavorites(entry);
    }
  }

  /// Generate entry ID (same logic as HistoryService)
  String _generateEntryId(Map<String, dynamic> entry) {
    final imageBase64 = entry['imageBase64'] as String? ?? '';
    final styleName = entry['styleName'] as String? ?? '';
    final name = entry['name'] as String? ?? '';

    final imagePrefix = imageBase64.isNotEmpty && imageBase64.length > 50
        ? imageBase64.substring(0, 50)
        : imageBase64;
    return '${imagePrefix}_${styleName}_$name';
  }

  /// Refresh favorites list (reload from storage)
  Future<void> refresh() async {
    await loadFavorites();
  }
}
