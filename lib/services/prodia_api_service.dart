import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';

/// API Service for Prodia text-to-image and image-to-image generation
class ProdiaApiService {
  static const String _baseUrl = 'https://inference.prodia.com/v2/job';
  static const String _apiToken =
      'eyJhbGciOiJkaXIiLCJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2R0NNIn0.._k05Twd72f3VpXEH.NTMw5WDFlsZQqc67PCWmPZKER_yUMNeUdR63goeffclZVsaEsMSnZu8_8KKNWmBH0KCWS3eeuoIoNxo7rAA6BPdtMXyM9rwHq2n3_L9dai9Abps_0ids6xAsA5Wo_WiGhwuxc_3eM1nWWYc_AmMz5zapabbOe3LwriCIGGpABnlSfw7fa8frQtNPyMFuBYGxUeScbk9H88c01R0-7ZMvIeEh_RfluDOgKeQY7MYAnbJOAAl1vkTKmo770ATG8MHkM5sP2Dno-ifMSpLyvzVfxNkoRXHAQ5mwykoQaCgYZu7y8DUiAZtb6S9JZB12GN8sF7Inj2PWfsAHd1p7bFboFiW1at8dQgLerWPOLY0IBNKChbCkez2wmqZ-bRkPz6nANz5Vez2hQ4UPudY6etNo0eIyXYF_jLO1LLbZ2ywC-4SgIU_SZOME4voli39IkmpWfk1_slFnh1GYI5cpZbmgKtjvRB9fKmVoc2WnkHxO6KXindAgIUMvOAjchQ9jN185p7gync-_gGki6CNNSaZFIikou2bJ946kNhf8Ev3uXcJqt1g.dPB0ImNvlLDFk3mBz9Xm2g';

  late final Dio _dio;

  ProdiaApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {
          'Authorization': 'Bearer $_apiToken',
          'Accept': 'image/jpeg',
          'Content-Type': 'application/json',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
  }

  /// Text to Image using Flux Fast Schnell
  ///
  /// [prompt] - The text prompt for image generation
  /// [width] - Image width (default: 1024)
  /// [height] - Image height (default: 1024)
  /// [steps] - Number of steps (default: 4)
  ///
  /// Returns the generated image as Uint8List bytes
  Future<Uint8List> textToImage({
    required String prompt,
    int width = 1024,
    int height = 1024,
    int steps = 4,
  }) async {
    try {
      final job = {
        'type': 'inference.flux-fast.schnell.txt2img.v2',
        'config': {
          'prompt': prompt,
          'width': width,
          'height': height,
          'steps': steps,
        },
      };

      final response = await _dio.post(
        '',
        data: job,
        options: Options(
          headers: {'Accept': 'image/jpeg', 'Content-Type': 'application/json'},
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'API Error: ${response.statusCode} - ${response.statusMessage}',
        );
      }

      final requestId = response.headers.value('x-request-id');
      print('Request ID: $requestId');
      print('Status: ${response.statusCode}');

      return Uint8List.fromList(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.response?.statusCode} - ${e.message}');
      }
      rethrow;
    }
  }

  /// Image to Image using Flux 2 Klein
  ///
  /// [imageFile] - The input image file
  /// [prompt] - The text prompt for image transformation
  /// [steps] - Number of steps (default: 4)
  /// [guidanceScale] - Guidance scale (default: 1)
  ///
  /// Returns the generated image as Uint8List bytes
  Future<Uint8List> imageToImage({
    required File imageFile,
    required String prompt,
    int steps = 4,
    double guidanceScale = 1,
  }) async {
    try {
      // Generate a unique image ID (you can use UUID or timestamp)
      final imageId = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imageName = imageFile.path.split('/').last;

      // Create FormData for multipart/form-data
      // Note: The job needs to be sent as a JSON string with filename and content-type
      final jobJson = jsonEncode({
        'type': 'inference.flux-2.klein.img2img.v1',
        'config': {
          'prompt': prompt,
          'steps': steps,
          'guidance_scale': guidanceScale,
          'images': [imageId],
        },
      });

      final formData = FormData.fromMap({
        'input': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageName,
        ),
        'job': MultipartFile.fromString(jobJson, filename: 'job.json'),
      });

      final response = await _dio.post(
        '',
        data: formData,
        options: Options(
          headers: {'Accept': 'image/jpeg'},
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'API Error: ${response.statusCode} - ${response.statusMessage}',
        );
      }

      final requestId = response.headers.value('x-request-id');
      print('Request ID: $requestId');
      print('Status: ${response.statusCode}');

      return Uint8List.fromList(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.response?.statusCode} - ${e.message}');
      }
      rethrow;
    }
  }
}
