import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAssetUrlService {
  final FirebaseStorage _storage;
  final Map<String, String> _memoryCache = {};

  FirebaseAssetUrlService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  Future<String> getDownloadUrl(String assetPath) async {
    final cached = _memoryCache[assetPath];
    if (cached != null) return cached;

    final url = await _storage.ref(assetPath).getDownloadURL();
    _memoryCache[assetPath] = url;
    return url;
  }
}

