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

  // We support multiple "slots" so different screens can hold their own native
  // instance without accidentally mounting the same NativeAd in two AdWidgets
  // at once (which causes: "This AdWidget is already in the widget tree").
  static const String slotDefault = 'default';

  final Map<String, _NativeSlot> _slots = <String, _NativeSlot>{};

  _NativeSlot _slot(String key) =>
      _slots.putIfAbsent(key, () => _NativeSlot());

  // Backwards-compatible "default slot" API (used by Language/FirstLanguage).
  NativeAd? get ad => _slot(slotDefault)._ad;
  bool get isLoaded => _slot(slotDefault).isLoaded;

  NativeAd? adForKey(String key) => _slot(key)._ad;
  bool isLoadedForKey(String key) => _slot(key).isLoaded;

  Future<void> preload({int? backgroundColor, bool? isDark}) async {
    await ensureLoaded(backgroundColor: backgroundColor, isDark: isDark);
  }

  Future<void> preloadForKey({
    required String key,
    int? backgroundColor,
    bool? isDark,
  }) async {
    await ensureLoadedForKey(key: key, backgroundColor: backgroundColor, isDark: isDark);
  }

  Future<bool> ensureLoaded({
    Duration timeout = const Duration(seconds: 12),
    int? backgroundColor,
    bool? isDark,
  }) async {
    return ensureLoadedForKey(
      key: slotDefault,
      timeout: timeout,
      backgroundColor: backgroundColor,
      isDark: isDark,
    );
  }

  Future<bool> ensureLoadedForKey({
    required String key,
    Duration timeout = const Duration(seconds: 12),
    int? backgroundColor,
    bool? isDark,
  }) async {
    final slot = _slot(key);

    if (slot.isLoaded &&
        slot.lastBackgroundColor == backgroundColor &&
        slot.lastIsDark == isDark) {
      return true;
    }
    if (slot.isLoading) {
      final completer = slot.loadCompleter;
      if (completer == null) return false;
      try {
        return await completer.future.timeout(timeout);
      } catch (_) {
        return slot.isLoaded;
      }
    }

    final unitId = AdmobIds.nativeUnitId().trim();
    if (unitId.isEmpty) {
      _disposeSlot(slot);
      slot.isLoadedFlag = false;
      slot.lastBackgroundColor = null;
      slot.lastIsDark = null;
      notifyListeners();
      return false;
    }

    slot.isLoading = true;
    slot.loadCompleter = Completer<bool>();

    slot.lastBackgroundColor = backgroundColor;
    slot.lastIsDark = isDark;

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
          if (!identical(loadedAd, slot.loadingAd)) {
            try {
              loadedAd.dispose();
            } catch (_) {}
            return;
          }

          final previousAd = slot._ad;
          slot._ad = loadedAd as NativeAd;
          slot.loadingAd = null;
          slot.isLoadedFlag = true;
          slot.isLoading = false;
          if (slot.loadCompleter != null && !slot.loadCompleter!.isCompleted) {
            slot.loadCompleter!.complete(true);
          }
          slot.loadCompleter = null;
          notifyListeners();

          // Dispose the previous ad slightly later to avoid "ad may be disposed"
          // logs when the platform view is still detaching.
          if (previousAd != null) {
            slot.pendingDispose.add(previousAd);
            Timer(const Duration(milliseconds: 800), () {
              if (!slot.pendingDispose.contains(previousAd)) return;
              slot.pendingDispose.remove(previousAd);
              try {
                previousAd.dispose();
              } catch (_) {}
            });
          }
        },
        onAdFailedToLoad: (failedAd, error) {
          if (kDebugMode) {
            debugPrint('[NativeAdService][$key] failed to load: $error');
          }
          failedAd.dispose();
          if (identical(failedAd, slot.loadingAd)) {
            slot.loadingAd = null;
          }
          // Keep showing the previous cached ad if we have one.
          slot.isLoadedFlag = slot._ad != null;
          slot.isLoading = false;
          if (slot.loadCompleter != null && !slot.loadCompleter!.isCompleted) {
            slot.loadCompleter!.complete(false);
          }
          slot.loadCompleter = null;
          notifyListeners();
        },
      ),
    );

    // Keep the currently displayed ad until the new one is loaded.
    slot.loadingAd?.dispose();
    slot.loadingAd = ad;
    ad.load();

    try {
      return await slot.loadCompleter!.future.timeout(timeout);
    } catch (_) {
      return slot.isLoaded;
    }
  }

  /// Call when you know the cached ad must not be reused anymore.
  ///
  /// A [NativeAd] that was previously bound to a disposed [AdWidget] cannot be
  /// rendered again reliably (the platform view detaches), so screens that are
  /// re-entered should request a fresh ad with this method.
  void invalidateAndReload({int? backgroundColor, bool? isDark}) {
    invalidateAndReloadForKey(
      key: slotDefault,
      backgroundColor: backgroundColor,
      isDark: isDark,
    );
  }

  void invalidateAndReloadForKey({
    required String key,
    int? backgroundColor,
    bool? isDark,
  }) {
    final slot = _slot(key);
    _disposeSlot(slot);
    slot.isLoadedFlag = false;
    slot.lastBackgroundColor = null;
    slot.lastIsDark = null;
    notifyListeners();
    unawaited(
      preloadForKey(key: key, backgroundColor: backgroundColor, isDark: isDark),
    );
  }

  void _disposeSlot(_NativeSlot slot) {
    try {
      slot.loadingAd?.dispose();
    } catch (_) {
      // Ignore dispose failures.
    }
    slot.loadingAd = null;

    // Dispose any queued ads now.
    for (final ad in List<NativeAd>.from(slot.pendingDispose)) {
      try {
        ad.dispose();
      } catch (_) {}
    }
    slot.pendingDispose.clear();

    try {
      slot._ad?.dispose();
    } catch (_) {
      // Ignore dispose failures.
    }
    slot._ad = null;
  }

  @override
  void dispose() {
    for (final slot in _slots.values) {
      _disposeSlot(slot);
    }
    super.dispose();
  }
}

class _NativeSlot {
  NativeAd? _ad;
  NativeAd? loadingAd;
  bool isLoading = false;
  bool isLoadedFlag = false;
  Completer<bool>? loadCompleter;
  int? lastBackgroundColor;
  bool? lastIsDark;
  final List<NativeAd> pendingDispose = <NativeAd>[];

  bool get isLoaded => isLoadedFlag && _ad != null;
}

