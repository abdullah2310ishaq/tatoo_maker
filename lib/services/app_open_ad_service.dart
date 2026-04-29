import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdService {
  AppOpenAdService._internal({this.minIntervalBetweenShows = Duration.zero});

  static final AppOpenAdService instance = AppOpenAdService._internal(
    // Default interval; caller may override via `configure()`.
    minIntervalBetweenShows: Duration.zero,
  );

  AppOpenAd? _ad;
  bool _isLoading = false;
  bool _isShowing = false;
  bool _temporarilyDisabled = false;
  String? _defaultUnitId;
  DateTime? _loadedAt;
  DateTime? _lastShownAt;
  Completer<bool>? _loadCompleter;

  /// Prevents repeated showing on quick resume cycles.
  Duration minIntervalBetweenShows;
  static const Duration _maxAdAge = Duration(hours: 4);
  static const Duration _loadTimeout = Duration(seconds: 12);
  static const Duration _showFallbackResetDelay = Duration(seconds: 15);

  void configure({Duration? minIntervalBetweenShows, String? defaultUnitId}) {
    if (minIntervalBetweenShows != null) {
      this.minIntervalBetweenShows = minIntervalBetweenShows;
    }
    if (defaultUnitId != null) {
      final normalizedUnitId = defaultUnitId.trim();
      _defaultUnitId = normalizedUnitId.isEmpty ? null : normalizedUnitId;
    }
  }

  bool get isShowing => _isShowing;
  bool get isTemporarilyDisabled => _temporarilyDisabled;

  /// Temporarily disable app-open display for sensitive screens
  /// (for example: paywall/pro screen). Preloading can continue.
  void setTemporarilyDisabled(bool disabled) {
    _temporarilyDisabled = disabled;
    if (kDebugMode) {
      debugPrint('[AppOpenAdService] temporarilyDisabled=$disabled');
    }
  }

  Future<void> preload({String? unitIdOverride}) async {
    await _loadIfNeeded(primaryUnitIdOverride: unitIdOverride);
  }

  /// Ensures an App Open ad is loaded (cached) and returns whether it's available.
  /// This is useful when UI wants to block on "loaded" before calling `showIfAvailable`.
  Future<bool> ensureLoaded({
    String? unitIdOverride,
    Duration timeout = _loadTimeout,
  }) async {
    _dropExpiredIfNeeded();
    if (_ad != null) return true;
    if (_isLoading) {
      final completer = _loadCompleter;
      if (completer == null) return false;
      try {
        return await completer.future.timeout(timeout);
      } catch (_) {
        return _ad != null;
      }
    }

    _loadCompleter = Completer<bool>();
    unawaited(_loadIfNeeded(primaryUnitIdOverride: unitIdOverride));
    try {
      return await _loadCompleter!.future.timeout(timeout);
    } catch (_) {
      return _ad != null;
    } finally {
      // Keep completer around only while a load is in-flight.
      if (!(_isLoading)) {
        _loadCompleter = null;
      }
    }
  }

  Future<void> showIfAvailable({
    String? unitIdOverride,
    String? testUnitIdOverride,
    bool waitForLoad = true,
    bool waitForDismiss = true,
  }) async {
    if (_temporarilyDisabled) {
      if (kDebugMode) {
        debugPrint('[AppOpenAdService] skip show: temporarily disabled');
      }
      return;
    }
    if (_isShowing) {
      if (kDebugMode) {
        debugPrint('[AppOpenAdService] skip show: ad already showing');
      }
      return;
    }

    final now = DateTime.now();
    final last = _lastShownAt;
    if (last != null && now.difference(last) < minIntervalBetweenShows) {
      if (kDebugMode) {
        debugPrint('[AppOpenAdService] skip show: min interval not reached');
      }
      return;
    }

    _dropExpiredIfNeeded();

    // Ensure an ad is loaded; if it wasn't, optionally load and then attempt to show.
    if (_ad == null) {
      if (!waitForLoad) {
        if (kDebugMode) {
          debugPrint('[AppOpenAdService] no cached ad; preload only');
        }
        unawaited(_loadIfNeeded(primaryUnitIdOverride: unitIdOverride));
        return;
      }

      await _loadIfNeeded(primaryUnitIdOverride: unitIdOverride);
    }

    final ad = _ad;
    if (ad == null) {
      if (kDebugMode) {
        debugPrint('[AppOpenAdService] skip show: ad still unavailable');
      }
      return;
    }


    final dismissCompleter = Completer<void>();

    _isShowing = true;
    _lastShownAt = now;

    // Safety watchdog: if SDK misses callbacks, never stay stuck in showing=true.
    Timer(_showFallbackResetDelay, () {
      if (!_isShowing) return;
      _isShowing = false;
      _ad?.dispose();
      _ad = null;
      _loadedAt = null;
      if (kDebugMode) {
        debugPrint('[AppOpenAdService] show watchdog reset triggered');
      }
      if (!dismissCompleter.isCompleted) {
        dismissCompleter.complete();
      }
      unawaited(_loadIfNeeded());
    });

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) {
        if (kDebugMode) {
          debugPrint('[AppOpenAdService] showed app open');
        }
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ad = null;
        _loadedAt = null;
        _isShowing = false;
        if (!dismissCompleter.isCompleted) {
          dismissCompleter.complete();
        }
        unawaited(_loadIfNeeded());
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _ad = null;
        _loadedAt = null;
        _isShowing = false;
        if (kDebugMode) {
          debugPrint('[AppOpenAdService] failed to show: $error');
        }
        if (!dismissCompleter.isCompleted) {
          dismissCompleter.complete();
        }
        unawaited(_loadIfNeeded());
      },
    );

    try {
      if (kDebugMode) {
        debugPrint('[AppOpenAdService] showing app open now');
      }
      // Wait for "show" call to be issued (can complete early).
      await ad.show();
      if (waitForDismiss) {
        // Wait until the ad is dismissed/failed (or watchdog fires).
        await dismissCompleter.future;
      }
    } catch (e) {
      _isShowing = false;
      _ad?.dispose();
      _ad = null;
      _loadedAt = null;
      if (kDebugMode) {
        debugPrint('[AppOpenAdService] show failed: $e');
      }
      if (!dismissCompleter.isCompleted) {
        dismissCompleter.complete();
      }
      unawaited(_loadIfNeeded());
    }
  }

  Future<void> _loadIfNeeded({String? primaryUnitIdOverride}) async {
    _dropExpiredIfNeeded();
    if (_ad != null) return;
    if (_isLoading) return;

    final primaryUnitId = (primaryUnitIdOverride ?? _defaultUnitId ?? '')
        .trim();
    if (primaryUnitId.isEmpty) {
      if (kDebugMode) {
        debugPrint('[AppOpenAdService] skip load: missing app open unit id');
      }
      return;
    }
    String mask(String id) {
      if (id.length <= 10) return id;
      return '${id.substring(0, 18)}…${id.substring(id.length - 8)}';
    }

    Future<LoadAdError?> loadWithUnitId(String unitId) async {
      _isLoading = true;
      _loadCompleter ??= Completer<bool>();
      final completer = Completer<LoadAdError?>();

      try {
        if (kDebugMode) {
          final isGoogleTest = unitId.startsWith(
            'ca-app-pub-3940256099942544/',
          );
          debugPrint(
            '[AppOpenAdService] loading app open (${isGoogleTest ? 'TEST' : 'PROD'}): ${mask(unitId)}',
          );
        }
        await AppOpenAd.load(
          adUnitId: unitId,
          request: const AdRequest(),
          adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              _ad = ad;
              _loadedAt = DateTime.now();
              _isLoading = false;
              if (_loadCompleter != null && !_loadCompleter!.isCompleted) {
                _loadCompleter!.complete(true);
              }
              if (kDebugMode) {
                debugPrint('[AppOpenAdService] loaded app open');
              }
              if (!completer.isCompleted) completer.complete(null);
            },
            onAdFailedToLoad: (error) {
              _ad = null;
              _loadedAt = null;
              _isLoading = false;
              if (_loadCompleter != null && !_loadCompleter!.isCompleted) {
                _loadCompleter!.complete(false);
              }
              if (kDebugMode) {
                debugPrint('[AppOpenAdService] load failed: $error');
              }
              if (!completer.isCompleted) completer.complete(error);
            },
          ),
        );
      } catch (e) {
        _ad = null;
        _loadedAt = null;
        _isLoading = false;
        if (_loadCompleter != null && !_loadCompleter!.isCompleted) {
          _loadCompleter!.complete(false);
        }
        if (kDebugMode) {
          debugPrint('[AppOpenAdService] load threw: $e');
        }
        if (!completer.isCompleted) completer.complete(null);
      }

      try {
        return await completer.future.timeout(_loadTimeout);
      } on TimeoutException {
        _isLoading = false;
        _ad?.dispose();
        _ad = null;
        _loadedAt = null;
        if (_loadCompleter != null && !_loadCompleter!.isCompleted) {
          _loadCompleter!.complete(false);
        }
        if (kDebugMode) {
          debugPrint(
            '[AppOpenAdService] load timeout after ${_loadTimeout.inSeconds}s',
          );
        }
        return null;
      }
    }

    final primaryError = await loadWithUnitId(primaryUnitId);
    final primaryDidFail = primaryError != null || _ad == null;
    if (primaryDidFail && kDebugMode) {
      debugPrint('[AppOpenAdService] primary load failed (no fallback).');
    }

    // Load finished; clear completer for next load cycle.
    _loadCompleter = null;
  }

  Future<void> dispose() async {
    _ad?.dispose();
    _ad = null;
    _loadedAt = null;
  }

  void _dropExpiredIfNeeded() {
    final loadedAt = _loadedAt;
    if (_ad == null || loadedAt == null) return;
    if (DateTime.now().difference(loadedAt) <= _maxAdAge) return;

    try {
      _ad?.dispose();
    } catch (_) {
      // Ignore dispose failures.
    }
    _ad = null;
    _loadedAt = null;
  }
}
