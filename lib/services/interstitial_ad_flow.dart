import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app_open_ad_service.dart';
import '../widgets/interstitial_ad_loading_dialog.dart';

/// Shows the standard interstitial loading modal, then a full-screen interstitial if loaded.
Future<void> showInterstitialAdIfAvailable(
  BuildContext context, {
  required String adUnitId,
}) async {
  final unitId = adUnitId.trim();
  if (unitId.isEmpty) return;

  final appOpen = AppOpenAdService.instance;
  final loadingHandle = await showInterstitialAdLoadingDialog(
    context,
    minShowDuration: const Duration(seconds: 3),
    safetyTimeout: const Duration(seconds: 6),
  );

  final shownCompleter = Completer<bool>();
  final dismissedCompleter = Completer<void>();
  InterstitialAd.load(
    adUnitId: unitId,
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) async {
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (_) {
            appOpen.onInterstitialShowed();
            if (!shownCompleter.isCompleted) {
              shownCompleter.complete(true);
            }
          },
          onAdDismissedFullScreenContent: (ad) {
            appOpen.onInterstitialClosed();
            ad.dispose();
            loadingHandle.close();
            if (!shownCompleter.isCompleted) {
              shownCompleter.complete(true);
            }
            if (!dismissedCompleter.isCompleted) dismissedCompleter.complete();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            appOpen.onInterstitialClosed();
            ad.dispose();
            loadingHandle.close();
            if (!shownCompleter.isCompleted) {
              shownCompleter.complete(false);
            }
            if (!dismissedCompleter.isCompleted) dismissedCompleter.complete();
          },
        );
        try {
          await loadingHandle.waitForMinShowDuration();
          await Future<void>.delayed(const Duration(milliseconds: 150));
          ad.show();
        } catch (_) {
          ad.dispose();
          loadingHandle.close();
          if (!shownCompleter.isCompleted) {
            shownCompleter.complete(false);
          }
          if (!dismissedCompleter.isCompleted) dismissedCompleter.complete();
        }
      },
      onAdFailedToLoad: (_) {
        loadingHandle.close();
        if (!shownCompleter.isCompleted) {
          shownCompleter.complete(false);
        }
        if (!dismissedCompleter.isCompleted) dismissedCompleter.complete();
      },
    ),
  );

  try {
    final didShow = await shownCompleter.future.timeout(
      const Duration(seconds: 6),
    );
    if (didShow) {
      await dismissedCompleter.future.timeout(const Duration(minutes: 2));
    }
  } catch (_) {
    loadingHandle.close();
  }
}
