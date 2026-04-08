import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
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

  const AssetSyncResult({
    required this.total,
    required this.uploaded,
    required this.skipped,
    required this.failed,
  });
}

class AssetSyncService {
  final FirebaseStorage _storage;

  AssetSyncService({
    FirebaseStorage? storage,
  }) : _storage = storage ?? FirebaseStorage.instance;

  Future<AssetSyncResult> syncAllAssets({
    required bool force,
    void Function(AssetSyncProgress progress)? onProgress,
  }) async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    final manifest = jsonDecode(manifestJson);
    if (manifest is! Map<String, dynamic>) {
      throw StateError('AssetManifest.json has unexpected format.');
    }

    final assetPaths = manifest.keys
        .where((k) => k.startsWith('assets/'))
        .toList(growable: false)
      ..sort();

    final total = assetPaths.length;
    int uploaded = 0;
    int skipped = 0;
    final failed = <String>[];

    for (int i = 0; i < assetPaths.length; i++) {
      final assetPath = assetPaths[i];
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
        await ref.putData(
          bytes,
          SettableMetadata(
            contentType: _guessContentType(assetPath),
            cacheControl: 'public, max-age=31536000',
          ),
        );
        uploaded += 1;
      } catch (_) {
        failed.add(assetPath);
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

    return AssetSyncResult(
      total: total,
      uploaded: uploaded,
      skipped: skipped,
      failed: failed,
    );
  }

  Future<bool> _objectExists(Reference ref) async {
    try {
      await ref.getMetadata();
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') return false;
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

