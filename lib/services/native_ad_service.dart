import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'admob_ids.dart';

/// Simple singleton cache for one NativeAd instance.
///
/// Goal: preload once at app start and reuse across screens without each screen
/// reloading on every entry.
///
/// Note: Google Mobile Ads native ads are not guaranteed to be reusable forever.
/// If an ad fails to show or gets disposed, we drop it and allow a reload.
class NativeAdService extends ChangeNotifier {
  NativeAdService._();

  static final NativeAdService instance = NativeAdService._();

  static const String factoryIdListTileLanguage = 'listTileLanguage';

  NativeAd? _ad;
  bool _isLoading = false;
  bool _isLoaded = false;
  Completer<bool>? _loadCompleter;

  NativeAd? get ad => _ad;
  bool get isLoaded => _isLoaded && _ad != null;

  Future<void> preload() async {
    await ensureLoaded();
  }

  Future<bool> ensureLoaded({Duration timeout = const Duration(seconds: 12)}) async {
    if (isLoaded) return true;
    if (_isLoading) {
      final completer = _loadCompleter;
      if (completer == null) return false;
      try {
        return await completer.future.timeout(timeout);
      } catch (_) {
        return isLoaded;
      }
    }

    final unitId = AdmobIds.nativeUnitId().trim();
    if (unitId.isEmpty) {
      _disposeAd();
      _isLoaded = false;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _loadCompleter = Completer<bool>();

    final ad = NativeAd(
      adUnitId: unitId,
      request: const AdRequest(),
      factoryId: factoryIdListTileLanguage,
      listener: NativeAdListener(
        onAdLoaded: (loadedAd) {
          _ad = loadedAd as NativeAd;
          _isLoaded = true;
          _isLoading = false;
          if (_loadCompleter != null && !_loadCompleter!.isCompleted) {
            _loadCompleter!.complete(true);
          }
          _loadCompleter = null;
          notifyListeners();
        },
        onAdFailedToLoad: (failedAd, error) {
          if (kDebugMode) {
            debugPrint('[NativeAdService] failed to load: $error');
          }
          failedAd.dispose();
          _ad = null;
          _isLoaded = false;
          _isLoading = false;
          if (_loadCompleter != null && !_loadCompleter!.isCompleted) {
            _loadCompleter!.complete(false);
          }
          _loadCompleter = null;
          notifyListeners();
        },
      ),
    );

    // Replace any previous cached ad.
    _disposeAd();
    _ad = ad;
    ad.load();

    try {
      return await _loadCompleter!.future.timeout(timeout);
    } catch (_) {
      return isLoaded;
    }
  }

  /// Call when you know the cached ad must not be reused anymore.
  void invalidateAndReload() {
    _disposeAd();
    _isLoaded = false;
    notifyListeners();
    unawaited(preload());
  }

  void _disposeAd() {
    try {
      _ad?.dispose();
    } catch (_) {
      // Ignore dispose failures.
    }
    _ad = null;
  }

  @override
  void dispose() {
    _disposeAd();
    super.dispose();
  }
}

