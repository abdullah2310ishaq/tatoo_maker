import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// API Service for Prodia text-to-image and image-to-image generation
class ProdiaApiService {
  static const String _baseUrl = 'https://inference.prodia.com/v2/job';
  static const String _togetherImageGenUrl =
      'https://api.together.xyz/v1/images/generations';
  static const String _apiToken =
      'eyJhbGciOiJkaXIiLCJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2R0NNIn0.._k05Twd72f3VpXEH.NTMw5WDFlsZQqc67PCWmPZKER_yUMNeUdR63goeffclZVsaEsMSnZu8_8KKNWmBH0KCWS3eeuoIoNxo7rAA6BPdtMXyM9rwHq2n3_L9dai9Abps_0ids6xAsA5Wo_WiGhwuxc_3eM1nWWYc_AmMz5zapabbOe3LwriCIGGpABnlSfw7fa8frQtNPyMFuBYGxUeScbk9H88c01R0-7ZMvIeEh_RfluDOgKeQY7MYAnbJOAAl1vkTKmo770ATG8MHkM5sP2Dno-ifMSpLyvzVfxNkoRXHAQ5mwykoQaCgYZu7y8DUiAZtb6S9JZB12GN8sF7Inj2PWfsAHd1p7bFboFiW1at8dQgLerWPOLY0IBNKChbCkez2wmqZ-bRkPz6nANz5Vez2hQ4UPudY6etNo0eIyXYF_jLO1LLbZ2ywC-4SgIU_SZOME4voli39IkmpWfk1_slFnh1GYI5cpZbmgKtjvRB9fKmVoc2WnkHxO6KXindAgIUMvOAjchQ9jN185p7gync-_gGki6CNNSaZFIikou2bJ946kNhf8Ev3uXcJqt1g.dPB0ImNvlLDFk3mBz9Xm2g';
  static const String _togetherApiToken =
      'tgp_v1_PBiwOrgnqKgNKkewNBb2O4Uu67TGjJCXGPCM99j1eN4';

  final Map<String, String> _headers = {'Authorization': 'Bearer $_apiToken'};

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
      print('ProdiaApiService: Starting Together text-to-image API call...');
      print('ProdiaApiService: Prompt: $prompt');
      print(
        'ProdiaApiService: Dimensions: ${width}x$height (steps ignored for Together schnell)',
      );

      final requestBody = {
        'model': 'black-forest-labs/FLUX.1-schnell',
        'prompt': prompt,
        'disable_safety_checker': false,
      };

      print('ProdiaApiService: Sending request to Together API...');
      final response = await http.post(
        Uri.parse(_togetherImageGenUrl),
        headers: {
          'Authorization': 'Bearer $_togetherApiToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print(
        'ProdiaApiService: Together response status: ${response.statusCode}',
      );
      if (response.statusCode != 200) {
        print('ProdiaApiService: Together error body: ${response.body}');
        throw Exception(
          'Together API Error: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = decoded['data'];
      if (data is! List || data.isEmpty) {
        throw Exception('Together API Error: No image data returned');
      }

      final first = data.first;
      if (first is! Map<String, dynamic>) {
        throw Exception('Together API Error: Invalid image payload');
      }

      final imageUrl = first['url'] as String?;
      if (imageUrl == null || imageUrl.isEmpty) {
        throw Exception('Together API Error: Missing image URL');
      }

      print('ProdiaApiService: Downloading image from URL...');
      final imageResponse = await http.get(Uri.parse(imageUrl));
      if (imageResponse.statusCode != 200 || imageResponse.bodyBytes.isEmpty) {
        throw Exception(
          'Together API Error: Failed to download generated image',
        );
      }

      print(
        'ProdiaApiService: Together text-to-image successful, bytes=${imageResponse.bodyBytes.length}',
      );
      return imageResponse.bodyBytes;
    } catch (e) {
      print('ProdiaApiService: Error in text-to-image: $e');
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
      print('ProdiaApiService: Starting image-to-image API call...');
      print('ProdiaApiService: Image file: ${imageFile.path}');
      print('ProdiaApiService: Prompt: $prompt');
      print('ProdiaApiService: Steps: $steps, Guidance Scale: $guidanceScale');

      // Use actual filename - must match what's uploaded
      final imageName = imageFile.path.split(Platform.pathSeparator).last;
      print('ProdiaApiService: Image Name: $imageName');

      // Read image file bytes
      final imageBytes = await imageFile.readAsBytes();

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

      // Add headers - match CURL exactly
      request.headers.addAll(_headers);
      request.headers['Accept'] = 'image/jpeg';

      // Add image file - filename must match images array
      request.files.add(
        http.MultipartFile.fromBytes('input', imageBytes, filename: imageName),
      );

      // Create job JSON - images array must contain the exact filename
      final jobJson = jsonEncode({
        'type': 'inference.flux-2.klein.img2img.v1',
        'config': {
          'prompt': prompt,
          'steps': steps,
          'guidance_scale': guidanceScale,
          'images': [imageName], // Use actual filename, not timestamp
        },
      });

      // Add job as a file (as per API documentation)
      request.files.add(
        http.MultipartFile.fromString('job', jobJson, filename: 'job.json'),
      );

      print('ProdiaApiService: Sending request to API...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('ProdiaApiService: Response received');
      print('ProdiaApiService: Status Code: ${response.statusCode}');
      final contentType = response.headers['content-type'] ?? '';
      if (contentType.contains('application/json')) {
        // Log only a safe preview if JSON
        final preview = response.body.length > 200
            ? response.body.substring(0, 200)
            : response.body;
        print('ProdiaApiService: Response Body (JSON preview): $preview');
      } else {
        // Binary image response
        print(
          'ProdiaApiService: Response Body is binary (${response.bodyBytes.length} bytes)',
        );
      }

      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 202) {
        print('ProdiaApiService: Error - Status: ${response.statusCode}');
        print('ProdiaApiService: Error - Body: ${response.body}');
        throw Exception(
          'API Error: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }

      // If response is JSON, it's a job object and we must poll.
      // If it's an image (e.g. image/jpeg), return the bytes directly.
      if (contentType.contains('application/json')) {
        // Parse job response
        final jobResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final jobId = jobResponse['id'] as String?;

        if (jobId == null) {
          throw Exception('No job ID returned from API');
        }

        print('ProdiaApiService: Job ID: $jobId');
        print(
          'ProdiaApiService: Job State: ${jobResponse['state']?['current']}',
        );

        // Poll for job completion
        return await _pollJobStatus(jobId);
      } else {
        // Direct image response
        final requestId = response.headers['x-request-id'];
        print('ProdiaApiService: Request ID: $requestId');
        print(
          'ProdiaApiService: Image size (direct img2img): ${response.bodyBytes.length} bytes',
        );
        print('ProdiaApiService: Image-to-image API call successful!');
        return response.bodyBytes;
      }
    } catch (e) {
      print('ProdiaApiService: Error in image-to-image: $e');
      rethrow;
    }
  }

  /// Poll job status until completion and return the result image
  Future<Uint8List> _pollJobStatus(
    String jobId, {
    bool acceptPng = false,
  }) async {
    const maxAttempts = 60; // Maximum 60 attempts (5 minutes with 5s intervals)
    const pollInterval = Duration(seconds: 5);

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      print(
        'ProdiaApiService: Polling job status (attempt ${attempt + 1}/$maxAttempts)...',
      );

      final response = await http.get(
        Uri.parse('$_baseUrl/$jobId'),
        headers: {..._headers, 'Accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get job status: ${response.statusCode}');
      }

      final jobData = jsonDecode(response.body) as Map<String, dynamic>;
      final state = jobData['state'] as Map<String, dynamic>?;
      final currentState = state?['current'] as String?;

      print('ProdiaApiService: Job state: $currentState');

      if (currentState == 'completed' || currentState == 'succeeded') {
        // Job completed, fetch the result image
        print('ProdiaApiService: Job completed, fetching result image...');
        return await _fetchJobResult(jobId, acceptPng: acceptPng);
      } else if (currentState == 'failed' || currentState == 'error') {
        final message = state?['history']?.last?['message'] ?? 'Job failed';
        throw Exception('Job failed: $message');
      } else if (currentState == 'processing' || currentState == 'created') {
        // Still processing, wait and poll again
        print(
          'ProdiaApiService: Job still processing, waiting ${pollInterval.inSeconds}s...',
        );
        await Future.delayed(pollInterval);
      } else {
        throw Exception('Unknown job state: $currentState');
      }
    }

    throw Exception('Job polling timeout after $maxAttempts attempts');
  }

  /// Fetch the result image from a completed job
  Future<Uint8List> _fetchJobResult(
    String jobId, {
    bool acceptPng = false,
  }) async {
    print('ProdiaApiService: Fetching result image for job $jobId...');

    final response = await http.get(
      Uri.parse('$_baseUrl/$jobId'),
      headers: {..._headers, 'Accept': acceptPng ? 'image/png' : 'image/jpeg'},
    );

    if (response.statusCode != 200) {
      print(
        'ProdiaApiService: Error fetching result - Status: ${response.statusCode}',
      );
      print('ProdiaApiService: Error - Body: ${response.body}');
      throw Exception('Failed to fetch result image: ${response.statusCode}');
    }

    final requestId = response.headers['x-request-id'];
    print('ProdiaApiService: Request ID: $requestId');
    print('ProdiaApiService: Image size: ${response.bodyBytes.length} bytes');
    print('ProdiaApiService: Image-to-image API call successful!');

    return response.bodyBytes;
  }

  /// Remove background from image using Together image edit API.
  ///
  /// [imageFile] - The input image file
  ///
  /// Returns the image bytes after background removal.
  Future<Uint8List> removeBackground({required File imageFile}) async {
    try {
      print('ProdiaApiService: Starting Together background removal...');
      print('ProdiaApiService: Image file: ${imageFile.path}');
      return await _togetherImageEditFromFile(
        imageFile: imageFile,
        model: 'black-forest-labs/FLUX.2-dev',
        prompt:
            'Remove the background completely. Keep only the tattoo design subject with clean edges on a plain white background. No extra elements.',
      );
    } catch (e) {
      print('ProdiaApiService: Error in background removal: $e');
      rethrow;
    }
  }

  /// Mask background using Together image edit API.
  ///
  /// Returns a high-contrast mask-like image as Uint8List bytes.
  Future<Uint8List> maskBackground({required File imageFile}) async {
    try {
      print('ProdiaApiService: Starting Together background mask...');
      print('ProdiaApiService: Image file: ${imageFile.path}');
      return await _togetherImageEditFromFile(
        imageFile: imageFile,
        model: 'black-forest-labs/FLUX.2-flex',
        prompt:
            'Create a clean binary mask of the tattoo subject: subject in white, background in black, high contrast, sharp edges, no gray shades.',
      );
    } catch (e) {
      print('ProdiaApiService: Error in background mask: $e');
      rethrow;
    }
  }

  Future<Uint8List> _togetherImageEditFromFile({
    required File imageFile,
    required String model,
    required String prompt,
  }) async {
    final imageBytes = await imageFile.readAsBytes();
    if (imageBytes.isEmpty) {
      throw Exception('Together API Error: Input image file is empty');
    }

    final lowerPath = imageFile.path.toLowerCase();
    final mimeType = lowerPath.endsWith('.jpg') || lowerPath.endsWith('.jpeg')
        ? 'image/jpeg'
        : 'image/png';
    final imageDataUrl = 'data:$mimeType;base64,${base64Encode(imageBytes)}';

    final requestBody = {
      'model': model,
      'prompt': prompt,
      'disable_safety_checker': true,
      'image_url': imageDataUrl,
    };

    print('ProdiaApiService: Sending Together image edit request...');
    print('ProdiaApiService: Model: $model');
    final response = await http.post(
      Uri.parse(_togetherImageGenUrl),
      headers: {
        'Authorization': 'Bearer $_togetherApiToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    print('ProdiaApiService: Together response status: ${response.statusCode}');
    if (response.statusCode != 200) {
      print('ProdiaApiService: Together error body: ${response.body}');
      throw Exception(
        'Together API Error: ${response.statusCode} - ${response.reasonPhrase}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'];
    if (data is! List || data.isEmpty) {
      throw Exception('Together API Error: No image data returned');
    }

    final first = data.first;
    if (first is! Map<String, dynamic>) {
      throw Exception('Together API Error: Invalid image payload');
    }

    final imageUrl = first['url'] as String?;
    if (imageUrl == null || imageUrl.isEmpty) {
      throw Exception('Together API Error: Missing image URL');
    }

    print('ProdiaApiService: Downloading edited image from URL...');
    final imageResponse = await http.get(Uri.parse(imageUrl));
    if (imageResponse.statusCode != 200 || imageResponse.bodyBytes.isEmpty) {
      throw Exception('Together API Error: Failed to download edited image');
    }

    print(
      'ProdiaApiService: Together image edit successful, bytes=${imageResponse.bodyBytes.length}',
    );
    return imageResponse.bodyBytes;
  }
}
