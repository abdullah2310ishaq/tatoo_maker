import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';

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
  bool _isProcessing = false;
  Uint8List? _processedTryOnBytes; // final processed output (captured preview)
  Offset _tattooPosition = const Offset(200, 300);
  double _tattooScale = 1.0;
  double _tattooRotation = 0.0;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  final GlobalKey _previewRepaintKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  // Gesture tracking variables
  double _lastScale = 1.0;
  double _lastRotation = 0.0;

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
    _scrollController.dispose();
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
        _processedTryOnBytes = null;
        _tattooPosition = const Offset(200, 300);
        _tattooScale = 1.0;
        _tattooRotation = 0.0;
      });
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
          _processedTryOnBytes = null;
          _tattooPosition = const Offset(200, 300);
          _tattooScale = 1.0;
          _tattooRotation = 0.0;
        });
      }
    }
  }

  /// Automatically process image: combine body image + tattoo overlay and send to API
  Future<void> _processImageAutomatically(File imageFile) async {
    if (widget.tattooImageBytes == null) {
      debugPrint('VirtualTryOn: No tattoo image to process');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      debugPrint('VirtualTryOn: Capturing on-screen preview as final image...');

      // Capture exactly what user sees in the preview (body + tattoo overlay)
      final boundary =
          _previewRepaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Preview not ready');
      }

      final uiImage = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Failed to encode preview');
      }
      final result = byteData.buffer.asUint8List();

      if (!mounted) return;
      setState(() {
        _processedTryOnBytes = result;
      });

      debugPrint('VirtualTryOn: Preview capture completed');
    } catch (e) {
      debugPrint('VirtualTryOn: Error processing image: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Processing failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
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
      if (_processedTryOnBytes == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No processed image to save'),
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
                          : _buildResultView(isDark),
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
                                if (_processedTryOnBytes == null)
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed:
                                          (_isProcessing ||
                                              _bodyPartImage == null)
                                          ? null
                                          : () async {
                                              if (_bodyPartImage == null) {
                                                return;
                                              }
                                              await _processImageAutomatically(
                                                _bodyPartImage!,
                                              );
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFA6541D,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: _isProcessing
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                          : const Text(
                                              'Apply',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                                fontFamily: 'Amaranth',
                                              ),
                                            ),
                                    ),
                                  ),
                                if (_processedTryOnBytes == null)
                                  const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed:
                                        (_isSaving ||
                                            _isProcessing ||
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

  Widget _buildResultView(bool isDark) {
    if (_isProcessing) {
      return Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.cardGlowStart),
              const SizedBox(height: 16),
              const Text(
                'Processing tattoo on human skin...',
                style: TextStyle(
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
      );
    }

    if (_processedTryOnBytes != null) {
      // Show processed result - pinch‑zoom & pan
      return InteractiveViewer(
        minScale: 1.0,
        maxScale: 4.0,
        panEnabled: true,
        scaleEnabled: true,
        child: Center(
          child: Image.memory(_processedTryOnBytes!, fit: BoxFit.contain),
        ),
      );
    }

    // Show preview with tattoo overlay (before processing)
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
          // Handle pan (translation)
          final newPosition = _tattooPosition + details.focalPointDelta;
          _tattooPosition = newPosition;
          // Any change to placement invalidates previous processed result
          _processedTryOnBytes = null;
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
