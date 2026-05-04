import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../widgets/interstitial_ad_loading_dialog.dart';
import 'rewarded_ad_service.dart';


Future<bool> showRewardedAdIfAvailable(
  BuildContext context, {
  required String adUnitId,
}) async {
  final unitId = adUnitId.trim();
  if (unitId.isEmpty) return false;

  if (kDebugMode) {
    debugPrint('[RewardedAdFlow] request show unitId=$unitId');
  }

  final loadingHandle = await showInterstitialAdLoadingDialog(
    context,
    minShowDuration: const Duration(seconds: 2),
    safetyTimeout: const Duration(seconds: 6),
  );

  // Prefer cached rewarded ad (preloaded on splash) to reduce latency.
  if (RewardedAdService.instance.hasAd) {
    if (kDebugMode) {
      debugPrint('[RewardedAdFlow] using cached rewarded ad');
    }
    try {
      await loadingHandle.waitForMinShowDuration();
      await Future<void>.delayed(const Duration(milliseconds: 150));
      final earned = await RewardedAdService.instance.showIfAvailable(
        onUserEarnedReward: (_) {},
        onDismissed: loadingHandle.close,
        onFailedToShow: loadingHandle.close,
      );
      // Preload next one in background for the next action.
      unawaited(RewardedAdService.instance.preload(unitId));
      if (kDebugMode) {
        debugPrint('[RewardedAdFlow] cached rewarded complete earned=$earned');
      }
      return earned;
    } catch (_) {
      loadingHandle.close();
      // Fall back to fresh load below.
    }
  }

  if (kDebugMode) {
    debugPrint('[RewardedAdFlow] loading rewarded ad (fresh)');
  }

  final shownCompleter = Completer<bool>();
  final earnedCompleter = Completer<bool>();
  final dismissedCompleter = Completer<void>();

  RewardedAd.load(
    adUnitId: unitId,
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (ad) async {
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (_) {
            if (!shownCompleter.isCompleted) shownCompleter.complete(true);
          },
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            loadingHandle.close();
            if (!shownCompleter.isCompleted) shownCompleter.complete(true);
            if (!earnedCompleter.isCompleted) earnedCompleter.complete(false);
            if (!dismissedCompleter.isCompleted) dismissedCompleter.complete();
          },
          onAdFailedToShowFullScreenContent: (ad, _) {
            ad.dispose();
            loadingHandle.close();
            if (!shownCompleter.isCompleted) shownCompleter.complete(false);
            if (!earnedCompleter.isCompleted) earnedCompleter.complete(false);
            if (!dismissedCompleter.isCompleted) dismissedCompleter.complete();
          },
        );

        try {
          await loadingHandle.waitForMinShowDuration();
          await Future<void>.delayed(const Duration(milliseconds: 150));
          ad.show(
            onUserEarnedReward: (_, __) {
              if (!earnedCompleter.isCompleted) earnedCompleter.complete(true);
            },
          );
        } catch (_) {
          ad.dispose();
          loadingHandle.close();
          if (!shownCompleter.isCompleted) shownCompleter.complete(false);
          if (!earnedCompleter.isCompleted) earnedCompleter.complete(false);
          if (!dismissedCompleter.isCompleted) dismissedCompleter.complete();
        }
      },
      onAdFailedToLoad: (error) {
        if (kDebugMode) {
          debugPrint(
            '[RewardedAdFlow] rewarded failed to load '
            '(code=${error.code}, domain=${error.domain}): ${error.message}',
          );
        }
        loadingHandle.close();
        if (!shownCompleter.isCompleted) shownCompleter.complete(false);
        if (!earnedCompleter.isCompleted) earnedCompleter.complete(false);
        if (!dismissedCompleter.isCompleted) dismissedCompleter.complete();
      },
    ),
  );

  try {
    final didShow = await shownCompleter.future.timeout(
      const Duration(seconds: 6),
    );
    if (!didShow) return false;
    final earned = await earnedCompleter.future.timeout(
      const Duration(minutes: 2),
    );
    await dismissedCompleter.future.timeout(const Duration(minutes: 2));
    // Preload next ad after a show attempt (best-effort).
    unawaited(RewardedAdService.instance.preload(unitId));
    if (kDebugMode) {
      debugPrint('[RewardedAdFlow] fresh rewarded complete earned=$earned');
    }
    return earned;
  } catch (_) {
    loadingHandle.close();
    return false;
  }
}

