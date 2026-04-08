import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/asset_sync_provider.dart';
import '../services/firebase_asset_url_service.dart';
import '../services/remote_asset_cache_service.dart';
import '../utils/colors.dart';

class RemoteOrAssetImage extends StatelessWidget {
  final String assetPath;
  final BoxFit fit;
  final Widget? errorWidget;

  const RemoteOrAssetImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isSynced = context.watch<AssetSyncProvider>().isSyncDone;
    if (!isSynced) {
      return Image.asset(
        assetPath,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _defaultError();
        },
      );
    }

    return _RemoteCachedFileImage(
      assetPath: assetPath,
      fit: fit,
      errorWidget: errorWidget,
    );
  }

  Widget _defaultError() {
    return Container(
      color: AppColors.cardGradientStart,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported,
        color: AppColors.textGrey,
      ),
    );
  }
}

class _RemoteCachedFileImage extends StatefulWidget {
  final String assetPath;
  final BoxFit fit;
  final Widget? errorWidget;

  const _RemoteCachedFileImage({
    required this.assetPath,
    required this.fit,
    required this.errorWidget,
  });

  @override
  State<_RemoteCachedFileImage> createState() => _RemoteCachedFileImageState();
}

class _RemoteCachedFileImageState extends State<_RemoteCachedFileImage> {
  late final FirebaseAssetUrlService _urlService;
  late final RemoteAssetCacheService _cacheService;
  Future<File>? _futureFile;

  @override
  void initState() {
    super.initState();
    _urlService = FirebaseAssetUrlService();
    _cacheService = RemoteAssetCacheService();
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
    final url = await _urlService.getDownloadUrl(widget.assetPath);
    return _cacheService.getOrDownload(assetPath: widget.assetPath, url: url);
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
              return widget.errorWidget ?? _defaultError();
            },
          );
        }

        if (snapshot.hasError) {
          return widget.errorWidget ?? _defaultError();
        }

        return Container(
          color: AppColors.cardGradientStart,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }

  Widget _defaultError() {
    return Container(
      color: AppColors.cardGradientStart,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported,
        color: AppColors.textGrey,
      ),
    );
  }
}

