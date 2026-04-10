import 'dart:io';

import 'package:flutter/material.dart';

import '../services/firebase_asset_url_service.dart';
import '../services/remote_asset_cache_service.dart';
import '../utils/colors.dart';

class RemoteOrAssetImage extends StatelessWidget {
  final String assetPath;
  final BoxFit fit;

  const RemoteOrAssetImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (_isFontAsset(assetPath)) {
      return Image.asset(
        assetPath,
        fit: fit,
      );
    }

    return _RemoteCachedFileImage(
      assetPath: assetPath,
      fit: fit,
    );
  }

  bool _isFontAsset(String path) => path.startsWith('assets/fonts/');
}

class _RemoteCachedFileImage extends StatefulWidget {
  final String assetPath;
  final BoxFit fit;

  const _RemoteCachedFileImage({
    required this.assetPath,
    required this.fit,
  });

  @override
  State<_RemoteCachedFileImage> createState() => _RemoteCachedFileImageState();
}

class _RemoteCachedFileImageState extends State<_RemoteCachedFileImage> {
  static final FirebaseAssetUrlService _sharedUrlService =
      FirebaseAssetUrlService();
  static final RemoteAssetCacheService _sharedCacheService =
      RemoteAssetCacheService();
  static final Map<String, Future<File>> _fileFutureCache =
      <String, Future<File>>{};

  Future<File>? _futureFile;

  @override
  void initState() {
    super.initState();
    _futureFile = _load();
  }

  @override
  void didUpdateWidget(covariant _RemoteCachedFileImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _futureFile = _load();
    }
  }

  Future<File> _load() async {
    final assetPath = widget.assetPath;
    final cachedFuture = _fileFutureCache[assetPath];
    if (cachedFuture != null) return cachedFuture;

    final future = _loadAndCacheFile(assetPath);
    _fileFutureCache[assetPath] = future;
    return future;
  }

  Future<File> _loadAndCacheFile(String assetPath) async {
    try {
      final url = await _sharedUrlService.getDownloadUrl(assetPath);
      return await _sharedCacheService.getOrDownload(
        assetPath: assetPath,
        url: url,
      );
    } catch (e) {
      // Remove failed futures so a later rebuild can retry.
      _fileFutureCache.remove(assetPath);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _futureFile,
      builder: (context, snapshot) {
        final file = snapshot.data;
        if (file != null) {
          return Image.file(
            file,
            fit: widget.fit,
            errorBuilder: (context, error, stackTrace) {
              return _loadingPlaceholder();
            },
          );
        }

        if (snapshot.hasError) {
          return _loadingPlaceholder();
        }

        return _loadingPlaceholder();
      },
    );
  }

  Widget _loadingPlaceholder() {
    return Container(
      color: AppColors.cardGradientStart,
      alignment: Alignment.center,
      child: const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
