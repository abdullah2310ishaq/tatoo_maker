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
  NativeAd? _loadingAd;
  bool _isLoading = false;
  bool _isLoaded = false;
  Completer<bool>? _loadCompleter;
  int? _lastBackgroundColor;
  bool? _lastIsDark;
  final List<NativeAd> _pendingDispose = <NativeAd>[];

  NativeAd? get ad => _ad;
  bool get isLoaded => _isLoaded && _ad != null;

  Future<void> preload({int? backgroundColor, bool? isDark}) async {
    await ensureLoaded(backgroundColor: backgroundColor, isDark: isDark);
  }

  Future<bool> ensureLoaded({
    Duration timeout = const Duration(seconds: 12),
    int? backgroundColor,
    bool? isDark,
  }) async {
    if (isLoaded &&
        _lastBackgroundColor == backgroundColor &&
        _lastIsDark == isDark) {
      return true;
    }
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
      _lastBackgroundColor = null;
      _lastIsDark = null;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _loadCompleter = Completer<bool>();

    _lastBackgroundColor = backgroundColor;
    _lastIsDark = isDark;

    final ad = NativeAd(
      adUnitId: unitId,
      request: const AdRequest(),
      factoryId: factoryIdListTileLanguage,
      customOptions: <String, Object>{
        if (backgroundColor != null) 'bgColor': backgroundColor,
        if (isDark != null) 'isDark': isDark,
      },
      listener: NativeAdListener(
        onAdLoaded: (loadedAd) {
          // Ignore stale callbacks from an older load attempt.
          if (!identical(loadedAd, _loadingAd)) {
            try {
              loadedAd.dispose();
            } catch (_) {}
            return;
          }

          final previousAd = _ad;
          _ad = loadedAd as NativeAd;
          _loadingAd = null;
          _isLoaded = true;
          _isLoading = false;
          if (_loadCompleter != null && !_loadCompleter!.isCompleted) {
            _loadCompleter!.complete(true);
          }
          _loadCompleter = null;
          notifyListeners();

          // Dispose the previous ad slightly later to avoid "ad may be disposed"
          // logs when the platform view is still detaching.
          if (previousAd != null) {
            _pendingDispose.add(previousAd);
            Timer(const Duration(milliseconds: 800), () {
              if (!_pendingDispose.contains(previousAd)) return;
              _pendingDispose.remove(previousAd);
              try {
                previousAd.dispose();
              } catch (_) {}
            });
          }
        },
        onAdFailedToLoad: (failedAd, error) {
          if (kDebugMode) {
            debugPrint('[NativeAdService] failed to load: $error');
          }
          failedAd.dispose();
          if (identical(failedAd, _loadingAd)) {
            _loadingAd = null;
          }
          // Keep showing the previous cached ad if we have one.
          _isLoaded = _ad != null;
          _isLoading = false;
          if (_loadCompleter != null && !_loadCompleter!.isCompleted) {
            _loadCompleter!.complete(false);
          }
          _loadCompleter = null;
          notifyListeners();
        },
      ),
    );

    // Keep the currently displayed ad until the new one is loaded.
    _loadingAd?.dispose();
    _loadingAd = ad;
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
    _lastBackgroundColor = null;
    _lastIsDark = null;
    notifyListeners();
    unawaited(preload());
  }

  void _disposeAd() {
    try {
      _loadingAd?.dispose();
    } catch (_) {
      // Ignore dispose failures.
    }
    _loadingAd = null;

    // Dispose any queued ads now.
    for (final ad in List<NativeAd>.from(_pendingDispose)) {
      try {
        ad.dispose();
      } catch (_) {}
    }
    _pendingDispose.clear();

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

