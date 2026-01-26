import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Run in isolate: apply a grayscale alpha mask to an RGB image and return PNG.
///
/// This function processes images pixel-by-pixel to apply an alpha mask,
/// which is CPU-intensive and should run in an isolate to avoid blocking the UI thread.
///
/// [args] - Map containing:
///   - 'inputImageBytes': Uint8List - The original image bytes
///   - 'maskBytes': Uint8List - The grayscale mask image bytes (red channel used as alpha)
///
/// Returns PNG image bytes with alpha channel applied
Uint8List applyAlphaMaskToImageIsolate(Map<String, dynamic> args) {
  final Uint8List inputImageBytes = args['inputImageBytes'] as Uint8List;
  final Uint8List maskBytes = args['maskBytes'] as Uint8List;

  final inputImage = img.decodeImage(inputImageBytes);
  final alphaMask = img.decodeImage(maskBytes);

  if (inputImage == null || alphaMask == null) {
    throw Exception('Failed to decode input or mask image');
  }

  // Resize mask to match input if needed.
  final mask =
      (alphaMask.width != inputImage.width ||
          alphaMask.height != inputImage.height)
      ? img.copyResize(
          alphaMask,
          width: inputImage.width,
          height: inputImage.height,
        )
      : alphaMask;

  final outputImage = img.Image(
    width: inputImage.width,
    height: inputImage.height,
    format: img.Format.uint8,
    numChannels: 4,
  );

  for (var y = 0; y < inputImage.height; y++) {
    for (var x = 0; x < inputImage.width; x++) {
      final pixel = inputImage.getPixel(x, y);
      final maskPixel = mask.getPixel(x, y);
      final r = pixel.r.toInt();
      final g = pixel.g.toInt();
      final b = pixel.b.toInt();
      final a = maskPixel.r.toInt(); // use red channel as alpha
      outputImage.setPixelRgba(x, y, r, g, b, a);
    }
  }

  return Uint8List.fromList(img.encodePng(outputImage));
}
