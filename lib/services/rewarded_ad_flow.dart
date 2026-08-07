import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
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

  final service = RewardedAdService.instance;

  // Ad already preloaded while gate dialog was open.
  if (service.hasAd) {
    if (kDebugMode) {
      debugPrint('[RewardedAdFlow] ad ready — showing immediately');
    }
    return _showReadyAd(context, unitId, service);
  }

  // Preload still running — show loading UI, wait, then show.
  if (service.isLoading) {
    if (kDebugMode) {
      debugPrint('[RewardedAdFlow] preload in progress — waiting');
    }
    return _showWithLoadingDialog(
      context,
      unitId: unitId,
      service: service,
      waitForPreload: true,
    );
  }

  // Preload failed at dialog open — retry with loading UI.
  if (service.loadState == RewardedAdLoadState.failed) {
    if (kDebugMode) {
      debugPrint('[RewardedAdFlow] preload failed — retrying');
    }
    return _showWithLoadingDialog(
      context,
      unitId: unitId,
      service: service,
      retryPreload: true,
    );
  }

  // Fallback: no preload yet, load fresh with loading UI.
  return _showWithLoadingDialog(
    context,
    unitId: unitId,
    service: service,
  );
}

/// Brief pause so the gate dialog can finish closing before a fullscreen ad.
Future<void> _waitForRouteSettled() async {
  await SchedulerBinding.instance.endOfFrame;
  await Future<void>.delayed(const Duration(milliseconds: 200));
}

Future<bool> _showReadyAd(
  BuildContext context,
  String unitId,
  RewardedAdService service,
) async {
  await _waitForRouteSettled();
  if (!context.mounted) return false;

  try {
    final earned = await service.showIfAvailable(
      onUserEarnedReward: (_) {},
      onDismissed: () {},
      onFailedToShow: () {},
    );
    unawaited(service.preload(unitId));
    if (kDebugMode) {
      debugPrint('[RewardedAdFlow] immediate show earned=$earned');
    }
    return earned;
  } catch (_) {
    return false;
  }
}

Future<bool> _showWithLoadingDialog(
  BuildContext context, {
  required String unitId,
  required RewardedAdService service,
  bool waitForPreload = false,
  bool retryPreload = false,
}) async {
  if (!context.mounted) return false;

  final loadingHandle = await showInterstitialAdLoadingDialog(
    context,
    minShowDuration: const Duration(seconds: 2),
    safetyTimeout: const Duration(seconds: 12),
  );

  if (waitForPreload) {
    await service.waitForLoad(timeout: const Duration(seconds: 12));
  }

  if (retryPreload) {
    await service.preload(unitId);
    if (service.isLoading) {
      await service.waitForLoad(timeout: const Duration(seconds: 12));
    }
  }

  if (service.hasAd) {
    if (kDebugMode) {
      debugPrint('[RewardedAdFlow] using cached rewarded ad after wait/retry');
    }
    try {
      await loadingHandle.waitForMinShowDuration();
      await Future<void>.delayed(const Duration(milliseconds: 150));
      final earned = await service.showIfAvailable(
        onUserEarnedReward: (_) {},
        onDismissed: loadingHandle.close,
        onFailedToShow: loadingHandle.close,
      );
      unawaited(service.preload(unitId));
      if (kDebugMode) {
        debugPrint('[RewardedAdFlow] cached rewarded complete earned=$earned');
      }
      return earned;
    } catch (_) {
      loadingHandle.close();
    }
  }

  if (kDebugMode) {
    debugPrint('[RewardedAdFlow] loading rewarded ad (fresh)');
  }

  return _loadAndShowFresh(
    unitId: unitId,
    service: service,
    loadingHandle: loadingHandle,
  );
}

Future<bool> _loadAndShowFresh({
  required String unitId,
  required RewardedAdService service,
  required InterstitialAdLoadingDialogHandle loadingHandle,
}) async {
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
      const Duration(seconds: 12),
    );
    if (!didShow) return false;
    final earned = await earnedCompleter.future.timeout(
      const Duration(minutes: 2),
    );
    await dismissedCompleter.future.timeout(const Duration(minutes: 2));
    unawaited(service.preload(unitId));
    if (kDebugMode) {
      debugPrint('[RewardedAdFlow] fresh rewarded complete earned=$earned');
    }
    return earned;
  } catch (_) {
    loadingHandle.close();
    return false;
  }
}
