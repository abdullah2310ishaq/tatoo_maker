import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsageLimitProvider extends ChangeNotifier {
  static const int freeGenerationLimit = 4;
  // for premium version make it true abdullah sb

  static const bool forceProForTesting = false;
  static const String _generationCountKey = 'usage_generation_count';
  static const String _proUnlockedKey = 'usage_pro_unlocked';

  int _generationCount = 0;
  bool _proUnlocked = false;
  Future<void>? _loadFuture;

  UsageLimitProvider() {
    _loadFuture = _loadState();
  }

  int get generationCount => _generationCount;
  bool get isProUnlocked => forceProForTesting || _proUnlocked;

  bool get hasReachedFreeLimit =>
      !isProUnlocked && _generationCount >= freeGenerationLimit;

  bool get shouldPromptAfterResultAction =>
      !isProUnlocked && _generationCount >= freeGenerationLimit;

  Future<void> _ensureLoaded() {
    _loadFuture ??= _loadState();
    return _loadFuture!;
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _generationCount = prefs.getInt(_generationCountKey) ?? 0;
      _proUnlocked = prefs.getBool(_proUnlockedKey) ?? false;
    } catch (error) {
      debugPrint('UsageLimitProvider load failed: $error');
      _generationCount = 0;
      _proUnlocked = false;
    }
    notifyListeners();
  }

  Future<void> recordGenerationSuccess() async {
    await _ensureLoaded();
    if (isProUnlocked) return;

    _generationCount += 1;
    await _persistState();
    notifyListeners();
  }

  Future<bool> canStartGeneration() async {
    await _ensureLoaded();
    return isProUnlocked || _generationCount < freeGenerationLimit;
  }

  Future<bool> shouldShowPostActionPaywall() async {
    await _ensureLoaded();
    return !isProUnlocked && _generationCount >= freeGenerationLimit;
  }

  Future<void> unlockPro() async {
    await _ensureLoaded();
    if (isProUnlocked) return;

    _proUnlocked = true;
    await _persistState();
    notifyListeners();
  }

  Future<void> lockPro() async {
    await setProUnlocked(false);
  }

  Future<void> setProUnlocked(bool value) async {
    await _ensureLoaded();
    if (_proUnlocked == value) return;

    _proUnlocked = value;
    await _persistState();
    notifyListeners();
  }

  Future<void> _persistState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setInt(_generationCountKey, _generationCount),
        prefs.setBool(_proUnlockedKey, _proUnlocked),
      ]);
    } catch (error) {
      debugPrint('UsageLimitProvider persist failed: $error');
    }
  }
}
