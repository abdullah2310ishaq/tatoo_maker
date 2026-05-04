import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Very small cache around a single rewarded ad instance.
///
/// Purpose: reduce perceived latency when user taps "Watch Ad".
class RewardedAdService {
  RewardedAdService._();

  static final RewardedAdService instance = RewardedAdService._();

  RewardedAd? _ad;
  bool _isLoading = false;
  String _loadedUnitId = '';

  bool get hasAd => _ad != null;

  Future<void> preload(String adUnitId) async {
    final unitId = adUnitId.trim();
    if (unitId.isEmpty) return;
    if (_isLoading) return;
    if (_ad != null && _loadedUnitId == unitId) return;

    _isLoading = true;
    try {
      if (kDebugMode) {
        debugPrint('[RewardedAdService] preload start unitId=$unitId');
      }
      final completer = Completer<void>();
      RewardedAd.load(
        adUnitId: unitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _ad?.dispose();
            _ad = ad;
            _loadedUnitId = unitId;
            if (kDebugMode) {
              debugPrint('[RewardedAdService] preload success');
            }
            completer.complete();
          },
          onAdFailedToLoad: (error) {
            _ad?.dispose();
            _ad = null;
            _loadedUnitId = '';
            if (kDebugMode) {
              debugPrint(
                '[RewardedAdService] preload failed '
                '(code=${error.code}, domain=${error.domain}): ${error.message}',
              );
            }
            completer.complete();
          },
        ),
      );
      await completer.future.timeout(const Duration(seconds: 8));
    } catch (_) {
      // ignore
    } finally {
      _isLoading = false;
    }
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

