import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

/// Simple in-memory cache for asset [VideoPlayerController]s.
///
/// Why:
/// - Avoid re-loading/re-initializing the same asset video on rebuilds/theme toggles.
/// - Keep startup smooth by reusing already initialized controllers.
///
/// Note:
/// - Controllers are intentionally kept for the app lifetime (small fixed set of assets).
/// - We also record a small "initialized once" flag in SharedPreferences as requested.
class AssetVideoControllerCache {
  static final Map<String, VideoPlayerController> _controllers = {};
  static final Map<String, Future<void>> _initializations = {};

  static VideoPlayerController controllerFor(String assetPath) {
    return _controllers.putIfAbsent(
      assetPath,
      () => VideoPlayerController.asset(assetPath),
    );
  }

  static Future<void> ensureInitialized(String assetPath) {
    return _initializations.putIfAbsent(assetPath, () async {
      final controller = controllerFor(assetPath);
      if (!controller.value.isInitialized) {
        await controller.initialize();
      }
      await controller.setLooping(true);
      await controller.play();

      // Persist "initialized once" flag (cannot persist the controller itself).
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_prefsKey(assetPath), true);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('AssetVideoControllerCache prefs write failed: $e');
        }
      }
    });
  }

  static String _prefsKey(String assetPath) =>
      'asset_video_initialized:$assetPath';
}
