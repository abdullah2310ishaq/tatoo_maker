import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'admob_ids.dart';

class AppOpenAdService {
  AppOpenAd? _ad;
  bool _isLoading = false;
  bool _isShowing = false;
  DateTime? _lastShownAt;

  /// Prevents repeated showing on quick resume cycles.
  final Duration minIntervalBetweenShows;

  AppOpenAdService({this.minIntervalBetweenShows = const Duration(seconds: 45)});

  bool get isShowing => _isShowing;

  Future<void> preload() async {
    await _loadIfNeeded();
  }

  Future<void> showIfAvailable() async {
    if (_isShowing) return;

    final now = DateTime.now();
    final last = _lastShownAt;
    if (last != null && now.difference(last) < minIntervalBetweenShows) {
      return;
    }

    final ad = _ad;
    if (ad == null) {
      await _loadIfNeeded();
      return;
    }

    _isShowing = true;
    _lastShownAt = now;

    ad.fullScreenContentCallback = FullScreenContentCallback(
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
        unawaited(_loadIfNeeded());
      },
    );

    try {
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

  Future<void> _loadIfNeeded() async {
    if (_ad != null) return;
    if (_isLoading) return;

    final unitId = AdmobIds.appOpenUnitId();
    if (unitId.isEmpty) return;

    _isLoading = true;
    try {
      await AppOpenAd.load(
        adUnitId: unitId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _ad = ad;
            _isLoading = false;
          },
          onAdFailedToLoad: (error) {
            _ad = null;
            _isLoading = false;
            if (kDebugMode) {
              debugPrint('[AppOpenAdService] load failed: $error');
            }
          },
        ),
      );
    } catch (e) {
      _ad = null;
      _isLoading = false;
      if (kDebugMode) {
        debugPrint('[AppOpenAdService] load threw: $e');
      }
    }
  }

  Future<void> dispose() async {
    _ad?.dispose();
    _ad = null;
  }
}

