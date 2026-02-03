import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

/// Persists and loads history for Creation, Tattoo, and Flower results.
class HistoryService {
  static const String _keyCreation = 'creation_history';
  static const String _keyTattoo = 'tattoo_history';
  static const String _keyFlower = 'flower_history';
  static const String _keyFavorites = 'favorites_history';
  static const int _maxEntries = 50;

  static Future<void> addCreationEntry({
    required String styleName,
    String? promptText,
    required Uint8List imageBytes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final list = _getList(prefs, _keyCreation);
    list.insert(0, {
      'styleName': styleName,
      'promptText': promptText ?? '',
      'imageBase64': base64Encode(imageBytes),
      'ts': DateTime.now().millisecondsSinceEpoch,
    });
    await _saveList(prefs, _keyCreation, list);
  }

  static Future<void> addTattooEntry({
    required String styleName,
    String? promptText,
    String? name,
    required Uint8List imageBytes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final list = _getList(prefs, _keyTattoo);
    list.insert(0, {
      'styleName': styleName,
      'promptText': promptText ?? '',
      'name': name ?? '',
      'imageBase64': base64Encode(imageBytes),
      'ts': DateTime.now().millisecondsSinceEpoch,
    });
    await _saveList(prefs, _keyTattoo, list);
  }

  static Future<void> addFlowerEntry({
    required String name,
    required Uint8List imageBytes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final list = _getList(prefs, _keyFlower);
    list.insert(0, {
      'name': name,
      'imageBase64': base64Encode(imageBytes),
      'ts': DateTime.now().millisecondsSinceEpoch,
    });
    await _saveList(prefs, _keyFlower, list);
  }

  static List<Map<String, dynamic>> _getList(
    SharedPreferences prefs,
    String key,
  ) {
    final raw = prefs.getString(key);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>?;
      return decoded
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [];
    } catch (_) {
      return [];
    }
  }

  static Future<void> _saveList(
    SharedPreferences prefs,
    String key,
    List<Map<String, dynamic>> list,
  ) async {
    final trimmed = list.take(_maxEntries).toList();
    await prefs.setString(key, jsonEncode(trimmed));
  }

  static Future<List<Map<String, dynamic>>> getCreationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return _getList(prefs, _keyCreation);
  }

  static Future<List<Map<String, dynamic>>> getTattooHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return _getList(prefs, _keyTattoo);
  }

  static Future<List<Map<String, dynamic>>> getFlowerHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return _getList(prefs, _keyFlower);
  }

  static Uint8List? imageBytesFromEntry(Map<String, dynamic> entry) {
    final b64 = entry['imageBase64'] as String?;
    if (b64 == null || b64.isEmpty) return null;
    try {
      return base64Decode(b64);
    } catch (_) {
      return null;
    }
  }

  /// Generate a unique ID for an entry (based on imageBase64 + styleName/name)
  /// Uses imageBase64 as primary identifier since it's unique per generated image
  static String _generateEntryId(Map<String, dynamic> entry) {
    final imageBase64 = entry['imageBase64'] as String? ?? '';
    final styleName = entry['styleName'] as String? ?? '';
    final name = entry['name'] as String? ?? '';

    // Use imageBase64 (first 50 chars) + styleName/name for stable ID
    // This ensures same image always gets same ID regardless of timestamp
    final imagePrefix = imageBase64.isNotEmpty && imageBase64.length > 50
        ? imageBase64.substring(0, 50)
        : imageBase64;
    return '${imagePrefix}_${styleName}_$name';
  }

  /// Add entry to favorites
  static Future<void> addToFavorites(Map<String, dynamic> entry) async {
    final prefs = await SharedPreferences.getInstance();
    final list = _getList(prefs, _keyFavorites);
    final entryId = _generateEntryId(entry);

    // Check if already favorited
    if (list.any((e) => _generateEntryId(e) == entryId)) {
      return; // Already favorited
    }

    // Add favorite flag to entry
    final favoriteEntry = Map<String, dynamic>.from(entry);
    favoriteEntry['favoriteId'] = entryId;
    favoriteEntry['favoritedAt'] = DateTime.now().millisecondsSinceEpoch;

    list.insert(0, favoriteEntry);
    await _saveList(prefs, _keyFavorites, list);
  }

  /// Remove entry from favorites
  static Future<void> removeFromFavorites(Map<String, dynamic> entry) async {
    final prefs = await SharedPreferences.getInstance();
    final list = _getList(prefs, _keyFavorites);
    final entryId = _generateEntryId(entry);

    list.removeWhere((e) => _generateEntryId(e) == entryId);
    await _saveList(prefs, _keyFavorites, list);
  }

  /// Check if entry is favorited
  static Future<bool> isFavorited(Map<String, dynamic> entry) async {
    final prefs = await SharedPreferences.getInstance();
    final list = _getList(prefs, _keyFavorites);
    final entryId = _generateEntryId(entry);
    return list.any((e) => _generateEntryId(e) == entryId);
  }

  /// Get all favorites
  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return _getList(prefs, _keyFavorites);
  }
}
