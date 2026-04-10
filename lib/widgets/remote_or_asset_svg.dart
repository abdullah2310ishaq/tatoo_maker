import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../services/firebase_asset_url_service.dart';
import '../services/remote_asset_cache_service.dart';
import '../utils/colors.dart';

class RemoteOrAssetSvg extends StatefulWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ColorFilter? colorFilter;
  final WidgetBuilder? placeholderBuilder;

  const RemoteOrAssetSvg({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.colorFilter,
    this.placeholderBuilder,
  });

  @override
  State<RemoteOrAssetSvg> createState() => _RemoteOrAssetSvgState();
}

class _RemoteOrAssetSvgState extends State<RemoteOrAssetSvg> {
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
  void didUpdateWidget(covariant RemoteOrAssetSvg oldWidget) {
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
          return SvgPicture.file(
            file,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            colorFilter: widget.colorFilter,
            placeholderBuilder: (context) => _placeholder(context),
          );
        }
        return _placeholder(context);
      },
    );
  }

  Widget _placeholder(BuildContext context) {
    return widget.placeholderBuilder?.call(context) ??
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.textGrey,
          ),
        );
  }
}
