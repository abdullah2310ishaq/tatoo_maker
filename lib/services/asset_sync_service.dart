import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AssetSyncProgress {
  final int completed;
  final int total;
  final String currentAssetPath;

  const AssetSyncProgress({
    required this.completed,
    required this.total,
    required this.currentAssetPath,
  });

  double get fraction => total == 0 ? 0 : completed / total;
}

class AssetSyncResult {
  final int total;
  final int uploaded;
  final int skipped;
  final List<String> failed;
  final Map<String, String> failureReasons;

  const AssetSyncResult({
    required this.total,
    required this.uploaded,
    required this.skipped,
    required this.failed,
    required this.failureReasons,
  });
}

class AssetSyncService {
  final FirebaseStorage _storage;

  static void _log(String message) {
    if (!kDebugMode) return;
    debugPrint('[AssetSync] $message');
  }

  AssetSyncService({
    FirebaseStorage? storage,
  }) : _storage = storage ?? FirebaseStorage.instance;

  Future<AssetSyncResult> syncAllAssets({
    required bool force,
    void Function(AssetSyncProgress progress)? onProgress,
  }) async {
    _log('syncAllAssets(force=$force) start');
    List<String> assetPaths;
    try {
      // Preferred: compatible across Flutter versions/build modes.
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      assetPaths = manifest
          .listAssets()
          .where((k) => k.startsWith('assets/'))
          .toList(growable: false)
        ..sort();
    } catch (e) {
      // Fallback for older builds where `AssetManifest` APIs behave differently.
      _log('AssetManifest API failed, falling back to AssetManifest.json: $e');
      final manifestJson = await rootBundle.loadString('AssetManifest.json');
      final decoded = jsonDecode(manifestJson);
      if (decoded is! Map<String, dynamic>) {
        throw StateError('AssetManifest.json has unexpected format.');
      }
      assetPaths = decoded.keys
          .where((k) => k.startsWith('assets/'))
          .toList(growable: false)
        ..sort();
    }

    final total = assetPaths.length;
    _log('found $total assets (assets/...)');
    int uploaded = 0;
    int skipped = 0;
    final failed = <String>[];
    final failureReasons = <String, String>{};

    for (int i = 0; i < assetPaths.length; i++) {
      final assetPath = assetPaths[i];
      if (kDebugMode && (i == 0 || i % 25 == 0 || i == total - 1)) {
        _log('progress ${i + 1}/$total: $assetPath');
      }
      onProgress?.call(
        AssetSyncProgress(
          completed: i,
          total: total,
          currentAssetPath: assetPath,
        ),
      );

      try {
        final ref = _storage.ref(assetPath);
        if (!force) {
          final exists = await _objectExists(ref);
          if (exists) {
            skipped += 1;
            continue;
          }
        }

        final byteData = await rootBundle.load(assetPath);
        final bytes = byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        );
        _log('uploading $assetPath (${bytes.length} bytes)');
        await ref.putData(
          bytes,
          SettableMetadata(
            contentType: _guessContentType(assetPath),
            cacheControl: 'public, max-age=31536000',
          ),
        );
        uploaded += 1;
      } on FirebaseException catch (e) {
        failed.add(assetPath);
        failureReasons[assetPath] = '${e.code}: ${e.message ?? ''}'.trim();
        _log('FAILED $assetPath => ${failureReasons[assetPath]}');

        // If we don't have permission, fail fast with a clear message.
        if (e.code == 'permission-denied' || e.code == 'unauthorized') {
          throw StateError(
            'Firebase Storage upload blocked (${e.code}). '
            'Fix Storage Rules (or sign-in) then retry. '
            'Example failing path: $assetPath',
          );
        }
      } catch (e) {
        failed.add(assetPath);
        failureReasons[assetPath] = e.toString();
        _log('FAILED $assetPath => ${failureReasons[assetPath]}');
      } finally {
        onProgress?.call(
          AssetSyncProgress(
            completed: i + 1,
            total: total,
            currentAssetPath: assetPath,
          ),
        );
      }
    }

    _log(
      'done. uploaded=$uploaded skipped=$skipped failed=${failed.length} (force=$force)',
    );
    return AssetSyncResult(
      total: total,
      uploaded: uploaded,
      skipped: skipped,
      failed: failed,
      failureReasons: failureReasons,
    );
  }

  Future<bool> _objectExists(Reference ref) async {
    try {
      await ref.getMetadata();
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') return false;
      _log('getMetadata failed (${ref.fullPath}) => ${e.code}: ${e.message ?? ''}');
      rethrow;
    }
  }

  String? _guessContentType(String assetPath) {
    final lower = assetPath.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.svg')) return 'image/svg+xml';
    if (lower.endsWith('.mp4')) return 'video/mp4';
    if (lower.endsWith('.json')) return 'application/json';
    if (lower.endsWith('.ttf')) return 'font/ttf';
    if (lower.endsWith('.otf')) return 'font/otf';
    return null;
  }
}

