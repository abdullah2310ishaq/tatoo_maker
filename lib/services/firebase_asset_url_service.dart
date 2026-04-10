import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAssetUrlService {
  final FirebaseStorage _storage;
  static final Map<String, String> _memoryCache = <String, String>{};
  static final Map<String, Future<String>> _inFlight =
      <String, Future<String>>{};

  FirebaseAssetUrlService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  Future<String> getDownloadUrl(String assetPath) async {
    final cached = _memoryCache[assetPath];
    if (cached != null) return cached;

    final inFlight = _inFlight[assetPath];
    if (inFlight != null) {
      return inFlight;
    }

    final future = _storage.ref(assetPath).getDownloadURL().then((url) {
      _memoryCache[assetPath] = url;
      return url;
    }).whenComplete(() {
      _inFlight.remove(assetPath);
    });

    _inFlight[assetPath] = future;
    return future;
  }
}

