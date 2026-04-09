import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'admob_ids.dart';

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
  DateTime? _loadedAt;
  DateTime? _lastShownAt;

  /// Prevents repeated showing on quick resume cycles.
  Duration minIntervalBetweenShows;
  static const Duration _maxAdAge = Duration(hours: 4);
  static const Duration _loadTimeout = Duration(seconds: 12);
  static const Duration _showFallbackResetDelay = Duration(seconds: 15);

  void configure({Duration? minIntervalBetweenShows}) {
    if (minIntervalBetweenShows != null) {
      this.minIntervalBetweenShows = minIntervalBetweenShows;
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

  Future<void> preload() async {
    await _loadIfNeeded();
  }

  /// When [waitForLoad] is false, this will NEVER wait on network loading.
  /// This is ideal for "resume from cache" where you want the ad to appear ASAP,
  /// and otherwise just preload for next time.
  Future<void> showIfAvailable({
    String? unitIdOverride,
    String? testUnitIdOverride,
    bool waitForLoad = true,
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
        unawaited(
          _loadIfNeeded(
            primaryUnitIdOverride: unitIdOverride,
            testUnitIdOverride: testUnitIdOverride,
          ),
        );
        return;
      }

      await _loadIfNeeded(
        primaryUnitIdOverride: unitIdOverride,
        testUnitIdOverride: testUnitIdOverride,
      );
    }

    final ad = _ad;
    if (ad == null) {
      if (kDebugMode) {
        debugPrint('[AppOpenAdService] skip show: ad still unavailable');
      }
      return;
    }

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
        unawaited(_loadIfNeeded());
      },
    );

    try {
      if (kDebugMode) {
        debugPrint('[AppOpenAdService] showing app open now');
      }
      await ad.show();
    } catch (e) {
      _isShowing = false;
      _ad?.dispose();
      _ad = null;
      _loadedAt = null;
      if (kDebugMode) {
        debugPrint('[AppOpenAdService] show failed: $e');
      }
      unawaited(_loadIfNeeded());
    }
  }

  Future<void> _loadIfNeeded({
    String? primaryUnitIdOverride,
    String? testUnitIdOverride,
  }) async {
    _dropExpiredIfNeeded();
    if (_ad != null) return;
    if (_isLoading) return;

    final primaryUnitId =
        (primaryUnitIdOverride ?? AdmobIds.appOpenUnitId()).trim();
    if (primaryUnitId.isEmpty) return;

    final testUnitId = (testUnitIdOverride ?? AdmobIds.appOpenTestUnitId()).trim();
    String mask(String id) {
      if (id.length <= 10) return id;
      return '${id.substring(0, 18)}…${id.substring(id.length - 8)}';
    }

    Future<LoadAdError?> loadWithUnitId(String unitId) async {
      _isLoading = true;
      final completer = Completer<LoadAdError?>();

      try {
        if (kDebugMode) {
          final isGoogleTest = unitId.startsWith('ca-app-pub-3940256099942544/');
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
              if (kDebugMode) {
                debugPrint('[AppOpenAdService] loaded app open');
              }
              if (!completer.isCompleted) completer.complete(null);
            },
            onAdFailedToLoad: (error) {
              _ad = null;
              _loadedAt = null;
              _isLoading = false;
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

    // Hard fallback: if primary fails (for any reason), retry with Google test unit.
    // This keeps App Open working even before Firebase RC is configured correctly.
    if (primaryDidFail &&
        testUnitId.isNotEmpty &&
        testUnitId != primaryUnitId) {
      if (kDebugMode) {
        debugPrint(
          '[AppOpenAdService] retrying with test unit after primary failure',
        );
      }
      final retryError = await loadWithUnitId(testUnitId);
      if (kDebugMode && retryError != null) {
        debugPrint('[AppOpenAdService] retry failed: $retryError');
      }
    }
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

