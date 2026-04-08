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
  DateTime? _lastShownAt;

  /// Prevents repeated showing on quick resume cycles.
  Duration minIntervalBetweenShows;

  void configure({Duration? minIntervalBetweenShows}) {
    if (minIntervalBetweenShows != null) {
      this.minIntervalBetweenShows = minIntervalBetweenShows;
    }
  }

  bool get isShowing => _isShowing;

  Future<void> preload() async {
    await _loadIfNeeded();
  }

  Future<void> showIfAvailable({String? unitIdOverride, String? testUnitIdOverride}) async {
    if (_isShowing) return;

    final now = DateTime.now();
    final last = _lastShownAt;
    if (last != null && now.difference(last) < minIntervalBetweenShows) {
      return;
    }

    // Ensure an ad is loaded; if it wasn't, load and then attempt to show.
    if (_ad == null) {
      await _loadIfNeeded(
        primaryUnitIdOverride: unitIdOverride,
        testUnitIdOverride: testUnitIdOverride,
      );
    }

    final ad = _ad;
    if (ad == null) return;

    _isShowing = true;
    _lastShownAt = now;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) {
        if (kDebugMode) {
          debugPrint('[AppOpenAdService] showed app open');
        }
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ad = null;
        _isShowing = false;
        unawaited(_loadIfNeeded());
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _ad = null;
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
    if (_ad != null) return;
    if (_isLoading) return;

    final primaryUnitId =
        (primaryUnitIdOverride ?? AdmobIds.appOpenUnitId()).trim();
    if (primaryUnitId.isEmpty) return;

    final testUnitId = (testUnitIdOverride ?? AdmobIds.appOpenTestUnitId()).trim();
    String _mask(String id) {
      if (id.length <= 10) return id;
      return '${id.substring(0, 18)}…${id.substring(id.length - 8)}';
    }

    Future<LoadAdError?> _loadWithUnitId(String unitId) async {
      _isLoading = true;
      final completer = Completer<LoadAdError?>();

      try {
        if (kDebugMode) {
          final isGoogleTest = unitId.startsWith('ca-app-pub-3940256099942544/');
          debugPrint(
            '[AppOpenAdService] loading app open (${isGoogleTest ? 'TEST' : 'PROD'}): ${_mask(unitId)}',
          );
        }
        await AppOpenAd.load(
          adUnitId: unitId,
          request: const AdRequest(),
          adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              _ad = ad;
              _isLoading = false;
              if (kDebugMode) {
                debugPrint('[AppOpenAdService] loaded app open');
              }
              if (!completer.isCompleted) completer.complete(null);
            },
            onAdFailedToLoad: (error) {
              _ad = null;
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
        _isLoading = false;
        if (kDebugMode) {
          debugPrint('[AppOpenAdService] load threw: $e');
        }
        if (!completer.isCompleted) completer.complete(null);
      }

      return completer.future;
    }

    final primaryError = await _loadWithUnitId(primaryUnitId);

    // Hard fallback: if primary fails (for any reason), retry with Google test unit.
    // This keeps App Open working even before Firebase RC is configured correctly.
    if (primaryError != null &&
        testUnitId.isNotEmpty &&
        testUnitId != primaryUnitId) {
      if (kDebugMode) {
        debugPrint(
          '[AppOpenAdService] retrying with test unit after primary failure',
        );
      }
      final retryError = await _loadWithUnitId(testUnitId);
      if (kDebugMode && retryError != null) {
        debugPrint('[AppOpenAdService] retry failed: $retryError');
      }
    }
  }

  Future<void> dispose() async {
    _ad?.dispose();
    _ad = null;
  }
}

