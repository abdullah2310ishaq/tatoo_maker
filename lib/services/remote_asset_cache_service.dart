import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class RemoteAssetCacheService {
  static const String _cacheFolderName = 'remote_assets_v1';

  Future<File> getOrDownload({
    required String assetPath,
    required String url,
  }) async {
    final cacheDir = await _cacheDir();
    final file = File('${cacheDir.path}/${_safeFileName(assetPath)}');
    if (await file.exists()) return file;

    final response = await http.get(Uri.parse(url));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException('Failed to download ($assetPath): ${response.statusCode}');
    }

    await file.parent.create(recursive: true);
    await file.writeAsBytes(response.bodyBytes, flush: true);
    return file;
  }

  Future<void> clearCache() async {
    try {
      final dir = await _cacheDir();
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (_) {
      // Best-effort cache clear.
    }
  }

  Future<Directory> _cacheDir() async {
    final base = await getTemporaryDirectory();
    return Directory('${base.path}/$_cacheFolderName');
  }

  String _safeFileName(String assetPath) {
    final normalized = assetPath.replaceAll('\\', '/');
    final encoded = normalized.replaceAll('/', '__');
    return encoded;
  }
}

