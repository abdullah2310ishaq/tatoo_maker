import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum RewardedAdLoadState { idle, loading, loaded, failed }

/// Very small cache around a single rewarded ad instance.
///
/// Purpose: reduce perceived latency when user taps "Watch Ad".
class RewardedAdService {
  RewardedAdService._();

  static final RewardedAdService instance = RewardedAdService._();

  RewardedAd? _ad;
  RewardedAdLoadState _loadState = RewardedAdLoadState.idle;
  String _loadedUnitId = '';
  String _loadingUnitId = '';
  Completer<void>? _loadCompleter;

  bool get hasAd => _ad != null;

  bool get isLoading => _loadState == RewardedAdLoadState.loading;

  RewardedAdLoadState get loadState => _loadState;

  /// Starts loading if not already ready or loading for this unit id.
  Future<void> preload(String adUnitId) {
    final unitId = adUnitId.trim();
    if (unitId.isEmpty) return Future<void>.value();

    if (_loadState == RewardedAdLoadState.loaded &&
        _ad != null &&
        _loadedUnitId == unitId) {
      return Future<void>.value();
    }

    if (_loadState == RewardedAdLoadState.loading && _loadingUnitId == unitId) {
      return _loadCompleter?.future ?? Future<void>.value();
    }

    return _startLoad(unitId);
  }

  /// Waits for an in-progress preload started by [preload].
  Future<bool> waitForLoad({
    Duration timeout = const Duration(seconds: 12),
  }) async {
    if (hasAd) return true;

    if (_loadState == RewardedAdLoadState.loading && _loadCompleter != null) {
      try {
        await _loadCompleter!.future.timeout(timeout);
      } catch (_) {
        return hasAd;
      }
    }

    return hasAd;
  }

  Future<void> _startLoad(String unitId) {
    _ad?.dispose();
    _ad = null;
    _loadedUnitId = '';
    _loadState = RewardedAdLoadState.loading;
    _loadingUnitId = unitId;
    _loadCompleter = Completer<void>();

    if (kDebugMode) {
      debugPrint('[RewardedAdService] preload start unitId=$unitId');
    }

    RewardedAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _loadedUnitId = unitId;
          _loadState = RewardedAdLoadState.loaded;
          _loadingUnitId = '';
          if (kDebugMode) {
            debugPrint('[RewardedAdService] preload success');
          }
          if (_loadCompleter != null && !_loadCompleter!.isCompleted) {
            _loadCompleter!.complete();
          }
        },
        onAdFailedToLoad: (error) {
          _ad?.dispose();
          _ad = null;
          _loadedUnitId = '';
          _loadState = RewardedAdLoadState.failed;
          _loadingUnitId = '';
          if (kDebugMode) {
            debugPrint(
              '[RewardedAdService] preload failed '
              '(code=${error.code}, domain=${error.domain}): ${error.message}',
            );
          }
          if (_loadCompleter != null && !_loadCompleter!.isCompleted) {
            _loadCompleter!.complete();
          }
        },
      ),
    );

    return _loadCompleter!.future;
  }

  /// Shows a cached ad if available.
  ///
  /// Returns `true` when the user earns the reward.
  Future<bool> showIfAvailable({
    required void Function(RewardItem reward) onUserEarnedReward,
    required void Function() onDismissed,
    required void Function() onFailedToShow,
  }) async {
    final ad = _ad;
    if (ad == null) return false;

    _ad = null;
    _loadedUnitId = '';
    _loadState = RewardedAdLoadState.idle;

    final earnedCompleter = Completer<bool>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (!earnedCompleter.isCompleted) earnedCompleter.complete(false);
        onDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        if (!earnedCompleter.isCompleted) earnedCompleter.complete(false);
        onFailedToShow();
      },
    );

    try {
      ad.show(
        onUserEarnedReward: (_, reward) {
          onUserEarnedReward(reward);
          if (!earnedCompleter.isCompleted) earnedCompleter.complete(true);
        },
      );
    } catch (_) {
      ad.dispose();
      if (!earnedCompleter.isCompleted) earnedCompleter.complete(false);
      onFailedToShow();
    }

    return earnedCompleter.future;
  }
}
