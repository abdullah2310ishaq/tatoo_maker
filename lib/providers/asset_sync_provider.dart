import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/asset_sync_service.dart';

class AssetSyncProvider extends ChangeNotifier {
  static const String _prefsSyncDoneKey = 'asset_sync_done';

  final AssetSyncService _service;

  static void _log(String message) {
    if (!kDebugMode) return;
    debugPrint('[AssetSyncProvider] $message');
  }

  bool _isSyncing = false;
  double _progress = 0;
  String? _currentAsset;
  String? _errorMessage;
  bool _isSyncDone = false;

  AssetSyncProvider({
    AssetSyncService? service,
  }) : _service = service ?? AssetSyncService();

  bool get isSyncing => _isSyncing;
  double get progress => _progress;
  String? get currentAsset => _currentAsset;
  String? get errorMessage => _errorMessage;
  bool get isSyncDone => _isSyncDone;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isSyncDone = prefs.getBool(_prefsSyncDoneKey) ?? false;
    } catch (_) {
      _isSyncDone = false;
    }
    notifyListeners();
  }

  Future<AssetSyncResult?> syncAllAssets({bool force = false}) async {
    if (_isSyncing) return null;

    _log('syncAllAssets(force=$force) requested');
    _isSyncing = true;
    _progress = 0;
    _currentAsset = null;
    _errorMessage = null;
    notifyListeners();

    AssetSyncResult? result;
    try {
      result = await _service.syncAllAssets(
        force: force,
        onProgress: (p) {
          _progress = p.fraction;
          _currentAsset = p.currentAssetPath;
          notifyListeners();
        },
      );

      final prefs = await SharedPreferences.getInstance();
      final success = result.failed.isEmpty;
      await prefs.setBool(_prefsSyncDoneKey, success);
      _isSyncDone = success;
      _log(
        'sync finished success=$success uploaded=${result.uploaded} skipped=${result.skipped} failed=${result.failed.length}',
      );
    } catch (e) {
      _errorMessage = e.toString();
      _log('sync failed: $_errorMessage');
    } finally {
      _isSyncing = false;
      _currentAsset = null;
      notifyListeners();
    }

    return result;
  }
}

