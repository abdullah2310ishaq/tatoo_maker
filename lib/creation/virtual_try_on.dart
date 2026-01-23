import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_selfie_segmentation/google_mlkit_selfie_segmentation.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../services/prodia_api_service.dart';

class VirtualTryOnScreen extends StatefulWidget {
  final Uint8List? tattooImageBytes;
  final String styleName;

  const VirtualTryOnScreen({
    super.key,
    this.tattooImageBytes,
    required this.styleName,
  });

  @override
  State<VirtualTryOnScreen> createState() => _VirtualTryOnScreenState();
}

class _VirtualTryOnScreenState extends State<VirtualTryOnScreen> {
  File? _bodyPartImage;
  bool _isSaving = false;
  bool _isAnalyzing = false;
  bool _isApplying = false;
  bool _isPlacementDirty = false;
  Uint8List? _processedTryOnBytes; // final processed (img2img) output
  Offset _tattooPosition = const Offset(200, 300);
  double _tattooScale = 1.0;
  double _tattooRotation = 0.0;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  final GlobalKey _previewRepaintKey = GlobalKey();
  final ProdiaApiService _apiService = ProdiaApiService();

  // Gesture tracking variables
  double _lastScale = 1.0;
  double _lastRotation = 0.0;

  // ML Kit Selfie Segmentation
  final SelfieSegmenter _selfieSegmenter = SelfieSegmenter(
    mode: SegmenterMode.stream,
    enableRawSizeMask: true,
  );
  SegmentationMask? _skinMask;
  List<double> _maskConfidences = const [];
  int _maskWidth = 0;
  int _maskHeight = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
        );
        await _cameraController!.initialize();
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await [Permission.camera, Permission.photos].request();
  }

  Future<void> _openCamera() async {
    await _requestPermissions();

    if (!_isCameraInitialized || _cameraController == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Camera not available')));
      return;
    }

    // Navigate to camera preview - returns confirmed image or null
    final confirmedImage = await Navigator.push<File>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CameraPreviewScreen(cameraController: _cameraController!),
      ),
    );
    if (!mounted) return;

    if (confirmedImage != null) {
      setState(() {
        _bodyPartImage = confirmedImage;
        _isAnalyzing = true;
        _isPlacementDirty = true;
        _processedTryOnBytes = null;
        _maskConfidences = const [];
        _maskWidth = 0;
        _maskHeight = 0;
      });
      await _processImageForSkinDetection(confirmedImage);
    }
  }

  Future<void> _pickImageFromGallery() async {
    await _requestPermissions();

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;

    if (image != null) {
      // Show preview screen with tick/cross buttons
      final confirmedImage = await Navigator.push<File>(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(imageFile: File(image.path)),
        ),
      );
      if (!mounted) return;

      if (confirmedImage != null) {
        setState(() {
          _bodyPartImage = confirmedImage;
          _isAnalyzing = true;
          _isPlacementDirty = true;
          _processedTryOnBytes = null;
          _maskConfidences = const [];
          _maskWidth = 0;
          _maskHeight = 0;
        });
        await _processImageForSkinDetection(confirmedImage);
      }
    }
  }

  /// Process image using ML Kit Selfie Segmentation to detect human skin
  Future<void> _processImageForSkinDetection(File imageFile) async {
    try {
      debugPrint('VirtualTryOn: Processing image for skin detection...');

      final inputImage = InputImage.fromFilePath(imageFile.path);

      // Process with ML Kit
      final mask = await _selfieSegmenter.processImage(inputImage);

      if (mask != null) {
        debugPrint('VirtualTryOn: Skin mask detected successfully');
        debugPrint(
          'VirtualTryOn: Mask dimensions: ${mask.width}x${mask.height}',
        );

        setState(() {
          _skinMask = mask;
          _maskWidth = mask.width;
          _maskHeight = mask.height;
          _maskConfidences = mask.confidences;
        });

        // Automatically place tattoo on detected skin area
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _autoPlaceTattooOnSkin();
          }
        });
      } else {
        debugPrint('VirtualTryOn: No skin detected in image');
        setState(() {
          _skinMask = null;
          _maskWidth = 0;
          _maskHeight = 0;
          _maskConfidences = const [];
        });
      }
    } catch (e) {
      debugPrint('VirtualTryOn: Error processing skin detection: $e');
      setState(() {
        _skinMask = null;
        _maskWidth = 0;
        _maskHeight = 0;
        _maskConfidences = const [];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  /// Check if a position is on human skin
  bool _isPositionOnSkin(Offset position) {
    if (_maskWidth == 0 || _maskHeight == 0 || _maskConfidences.isEmpty) {
      // If no mask, allow placement (fallback)
      return true;
    }

    // Get image dimensions from the displayed image
    final imageSize = MediaQuery.of(context).size;

    // Calculate scale factors - mask dimensions
    final maskWidth = _maskWidth.toDouble();
    final maskHeight = _maskHeight.toDouble();
    final imageAspectRatio = maskWidth / maskHeight;
    final screenAspectRatio = imageSize.width / imageSize.height;

    double displayWidth, displayHeight, offsetX, offsetY;

    if (imageAspectRatio > screenAspectRatio) {
      // Image is wider - fit to width
      displayWidth = imageSize.width;
      displayHeight = imageSize.width / imageAspectRatio;
      offsetX = 0;
      offsetY = (imageSize.height - displayHeight) / 2;
    } else {
      // Image is taller - fit to height
      displayHeight = imageSize.height;
      displayWidth = imageSize.height * imageAspectRatio;
      offsetX = (imageSize.width - displayWidth) / 2;
      offsetY = 0;
    }

    // Convert screen position to mask coordinates
    final maskX = ((position.dx - offsetX) / displayWidth * maskWidth).toInt();
    final maskY = ((position.dy - offsetY) / displayHeight * maskHeight)
        .toInt();

    // Check bounds
    if (maskX < 0 ||
        maskX >= maskWidth.toInt() ||
        maskY < 0 ||
        maskY >= maskHeight.toInt()) {
      return false;
    }

    // Treat "person foreground" as allowed zone.
    final idx = (maskY * _maskWidth) + maskX;
    if (idx < 0 || idx >= _maskConfidences.length) return false;
    return _maskConfidences[idx] >= 0.5;
  }

  /// Automatically place tattoo on detected skin area (center of image where skin is detected)
  void _autoPlaceTattooOnSkin() {
    if (_skinMask == null || _bodyPartImage == null || !mounted) {
      // No skin detected, use default position
      return;
    }

    final imageSize = MediaQuery.of(context).size;
    final maskWidth = _skinMask!.width.toDouble();
    final maskHeight = _skinMask!.height.toDouble();
    final imageAspectRatio = maskWidth / maskHeight;
    final screenAspectRatio = imageSize.width / imageSize.height;

    double displayWidth, displayHeight, offsetX, offsetY;

    if (imageAspectRatio > screenAspectRatio) {
      displayWidth = imageSize.width;
      displayHeight = imageSize.width / imageAspectRatio;
      offsetX = 0;
      offsetY = (imageSize.height - displayHeight) / 2;
    } else {
      displayHeight = imageSize.height;
      displayWidth = imageSize.height * imageAspectRatio;
      offsetX = (imageSize.width - displayWidth) / 2;
      offsetY = 0;
    }

    // Place tattoo at center of detected skin area (center of image)
    // Convert mask center to screen coordinates
    final maskCenterX = maskWidth / 2;
    final maskCenterY = maskHeight / 2;

    final screenX = (maskCenterX / maskWidth * displayWidth) + offsetX;
    final screenY = (maskCenterY / maskHeight * displayHeight) + offsetY;

    // Position tattoo center at this point (tattoo is 200x200, so offset by 100)
    final bestSkinPosition = Offset(screenX - 100, screenY - 100);

    setState(() {
      _tattooPosition = bestSkinPosition;
      _tattooScale = 1.0;
      _tattooRotation = 0.0;
    });

    debugPrint(
      'VirtualTryOn: Auto-placed tattoo at skin center (${screenX.toStringAsFixed(1)}, ${screenY.toStringAsFixed(1)})',
    );
  }

  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.buttonBackground
            : AppColors.lightBackground,
        title: Text(
          'Select Image Source',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textWhite
                : AppColors.textPrimary,
            fontFamily: 'Amaranth',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _openCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveToGallery() async {
    try {
      if (_bodyPartImage == null) return;
      if (_isAnalyzing) return;
      if (_isPlacementDirty || _processedTryOnBytes == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please tap Apply first'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      setState(() => _isSaving = true);

      await Gal.putImageBytes(
        _processedTryOnBytes!,
        name:
            '${widget.styleName}_tryon_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved to gallery!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving image: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // NOTE: We save the on-screen preview via RepaintBoundary, so the output matches exactly.

  Future<Uint8List> _capturePreviewBytes() async {
    final boundary =
        _previewRepaintKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) {
      throw Exception('Preview not ready');
    }

    final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Failed to encode preview');
    }
    return byteData.buffer.asUint8List();
  }

  Future<void> _applyTryOnProcessing() async {
    if (_bodyPartImage == null) return;
    if (_isAnalyzing || _isSaving || _isApplying) return;
    if (!_isPlacementDirty) return;

    // Validate tattoo center is on person/skin region.
    final tattooCenter = Offset(
      _tattooPosition.dx + 100 * _tattooScale,
      _tattooPosition.dy + 100 * _tattooScale,
    );
    if (!_isPositionOnSkin(tattooCenter)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please keep the tattoo on the skin area only'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isApplying = true;
    });

    try {
      final previewBytes = await _capturePreviewBytes();
      final tempDir = await Directory.systemTemp.createTemp('tryon_');
      final tempFile = File(
        '${tempDir.path}/tryon_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await tempFile.writeAsBytes(previewBytes);

      final result = await _apiService.imageToImage(
        imageFile: tempFile,
        prompt:
            'Make the tattoo look like a real tattoo on human skin, natural ink, realistic shading, blended with skin texture, high quality, preserve composition',
        steps: 4,
        guidanceScale: 1,
      );

      if (!mounted) return;
      setState(() {
        _processedTryOnBytes = result;
        _isPlacementDirty = false;
      });
    } catch (e) {
      debugPrint('VirtualTryOn: Apply processing failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Processing failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isApplying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Container(
          decoration: isDark
              ? ThemeManager.darkModeBackgroundGradient
              : ThemeManager.lightModeBackground,
          child: Stack(
            children: [
              // Header with close button
              Positioned(
                top: 16,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: isDark
                            ? AppColors.textWhite
                            : AppColors.textPrimary,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(
                      'Virtual Try-On',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textWhite
                            : AppColors.textPrimary,
                        fontFamily: 'Amaranth',
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the close button
                  ],
                ),
              ),
              // Main content area
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    Expanded(
                      child: _bodyPartImage == null
                          ? _buildEmptyState(isDark)
                          : _buildTattooPreview(isDark),
                    ),
                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          if (_bodyPartImage == null)
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _showImageSourceDialog,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFA6541D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Capture Photo',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontFamily: 'Amaranth',
                                  ),
                                ),
                              ),
                            )
                          else
                            Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed:
                                        (_isSaving ||
                                            _isAnalyzing ||
                                            _isApplying ||
                                            !_isPlacementDirty)
                                        ? null
                                        : _applyTryOnProcessing,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFA6541D),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child:
                                        (_isSaving ||
                                            _isAnalyzing ||
                                            _isApplying)
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : Text(
                                            _isPlacementDirty
                                                ? 'Apply'
                                                : 'Applied',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontFamily: 'Amaranth',
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed:
                                        (_isSaving ||
                                            _isAnalyzing ||
                                            _isApplying ||
                                            _isPlacementDirty ||
                                            _processedTryOnBytes == null)
                                        ? null
                                        : _saveToGallery,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFA6541D),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: _isSaving
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : const Text(
                                            'Download',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontFamily: 'Amaranth',
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, size: 80, color: AppColors.textGrey),
          const SizedBox(height: 24),
          Text(
            'Capture a photo of your hand\nor body part to try on the tattoo',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.textWhite : AppColors.textPrimary,
              fontFamily: 'Amaranth',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTattooPreview(bool isDark) {
    return GestureDetector(
      onScaleStart: (details) {
        _lastScale = _tattooScale;
        _lastRotation = _tattooRotation;
      },
      onScaleUpdate: (details) {
        setState(() {
          // Handle scale
          if (details.scale != 1.0) {
            _tattooScale = _lastScale * details.scale;
          }
          // Handle rotation
          if (details.rotation != 0.0) {
            _tattooRotation = _lastRotation + details.rotation;
          }
          // Handle pan (translation) - restrict to skin areas only
          final newPosition = _tattooPosition + details.focalPointDelta;

          // Check if new position is on skin (center of tattoo)
          final tattooCenter = Offset(
            newPosition.dx + 100 * _tattooScale, // Approximate tattoo center
            newPosition.dy + 100 * _tattooScale,
          );

          if (_isPositionOnSkin(tattooCenter)) {
            _tattooPosition = newPosition;
            _isPlacementDirty = true;
            _processedTryOnBytes = null;
          }
          // If not on skin, don't update position (tattoo stays in place)
        });
      },
      child: RepaintBoundary(
        key: _previewRepaintKey,
        child: Stack(
          children: [
            // Body part image
            Center(child: Image.file(_bodyPartImage!, fit: BoxFit.contain)),
            // Tattoo overlay (draggable)
            if (widget.tattooImageBytes != null)
              Positioned(
                left: _tattooPosition.dx,
                top: _tattooPosition.dy,
                child: Transform.scale(
                  scale: _tattooScale,
                  child: Transform.rotate(
                    angle: _tattooRotation,
                    child: Image.memory(
                      widget.tattooImageBytes!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            // Loading overlay after capture (skin detection / applying / saving)
            if (_isAnalyzing || _isApplying || _isSaving)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: AppColors.cardGlowStart,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isAnalyzing
                            ? 'Detecting skin...'
                            : _isApplying
                            ? 'Applying tattoo...'
                            : 'Saving to gallery...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Amaranth',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This may take a few moments',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: 'Amaranth',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for rendering skin mask overlay
// (Removed) _SkinMaskPainter was unused.

// Camera Preview Screen
class CameraPreviewScreen extends StatefulWidget {
  final CameraController cameraController;

  const CameraPreviewScreen({super.key, required this.cameraController});

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  File? _capturedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Show captured image preview or camera preview
          if (_capturedImage != null)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.file(_capturedImage!, fit: BoxFit.cover),
            )
          else
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(widget.cameraController),
            ),
          // Close button (top left)
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Bottom buttons: Tick/Cross if captured, Capture button if not
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: _capturedImage != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Cross button - retake
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _capturedImage = null;
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.withValues(alpha: 0.8),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Tick button - confirm
                      GestureDetector(
                        onTap: () {
                          if (_capturedImage != null) {
                            Navigator.pop(context, _capturedImage);
                          }
                        },

                        
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.withValues(alpha: 0.8),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: GestureDetector(
                      onTap: _capturePhoto,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: const Icon(
                          Icons.camera,
                          color: Colors.black,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _capturePhoto() async {
    try {
      final XFile image = await widget.cameraController.takePicture();
      if (mounted) {
        setState(() {
          _capturedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error capturing photo: $e')));
      }
    }
  }
}

/// Preview screen for gallery-selected images with tick/cross buttons
class ImagePreviewScreen extends StatelessWidget {
  final File imageFile;

  const ImagePreviewScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image preview
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.file(imageFile, fit: BoxFit.cover),
          ),
          // Close button (top left)
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Bottom buttons: Cross and Tick
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cross button - cancel
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withValues(alpha: 0.8),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                // Tick button - confirm
                GestureDetector(
                  onTap: () => Navigator.pop(context, imageFile),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withValues(alpha: 0.8),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
