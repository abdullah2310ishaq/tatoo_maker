import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';

/// Production-grade, self-contained camera preview screen.
/// Owns camera controller lifecycle, handles all camera operations safely.
class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({super.key});

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isInitializing = false;
  File? _capturedImage;
  String? _errorMessage;
  bool _isPermissionError = false;

  @override
  void initState() {
    super.initState();
    _lockOrientation();
    _setSystemUIOverlay();
    _initializeCamera();
  }

  void _lockOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _resetSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  void _unlockOrientation() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  Future<void> _initializeCamera() async {
    if (_isInitializing) return;

    setState(() {
      _isInitializing = true;
      _errorMessage = null;
      _isPermissionError = false;
    });

    try {
      // Check camera permission first
      final cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          if (mounted) {
            setState(() {
              _errorMessage = AppLocalizations.of(context)!
                  .cameraPermissionIsRequiredToTakePhotos;
              _isPermissionError = true;
              _isInitializing = false;
            });
          }
          return;
        }
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        if (mounted) {
          setState(() {
            _errorMessage =
                AppLocalizations.of(context)!.noCamerasAvailableOnThisDevice;
            _isInitializing = false;
          });
        }
        return;
      }

      // Create and initialize controller
      _controller = CameraController(
        _cameras![0], // Use first available camera (usually back camera)
        ResolutionPreset.high,
        enableAudio: false, // No audio needed for photos
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isInitializing = false;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      if (mounted) {
        setState(() {
          _errorMessage =
              AppLocalizations.of(context)!.failedToInitializeCameraTryAgain;
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_controller == null ||
        !_isInitialized ||
        !_controller!.value.isInitialized) {
      _showError(AppLocalizations.of(context)!.cameraNotReadyPleaseWait);
      return;
    }

    try {
      final XFile image = await _controller!.takePicture();
      if (!mounted) return;

      setState(() {
        _capturedImage = File(image.path);
      });
    } catch (e) {
      debugPrint('Photo capture error: $e');
      if (mounted) {
        _showError(AppLocalizations.of(context)!.couldntCapturePhotoTryAgain);
      }
    }
  }

  Future<void> _retakePhoto() async {
    if (_controller == null || !_isInitialized) return;

    try {
      // Reset camera state for next capture
      await _controller!.setFocusMode(FocusMode.auto);
      await _controller!.setExposureMode(ExposureMode.auto);
    } catch (e) {
      debugPrint('Camera reset error: $e');
      // Continue anyway - not critical
    }

    if (mounted) {
      setState(() {
        _capturedImage = null;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  void _handlePermissionDenied() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cameraPermissionRequired),
        content: Text(l10n.cameraAccessNeededEnableInSettings),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text(l10n.openSettings),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _unlockOrientation();
    _resetSystemUIOverlay();
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildCameraPreview() {
    if (!_isInitialized ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    final previewSize = _controller!.value.previewSize!;

    // Industry-standard: Fill screen and crop excess (no stretching)
    // Use FittedBox with BoxFit.cover for reliable full-screen preview
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: previewSize.height,
        height: previewSize.width,
        child: CameraPreview(_controller!),
      ),
    );
  }

  Widget _buildErrorState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 64.sp, color: Colors.white70),
            SizedBox(height: 16.h),
            Text(
              _errorMessage ?? l10n.cameraError,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: _initializeCamera,
              child: Text(l10n.retry),
            ),
            if (_isPermissionError) ...[
              SizedBox(height: 12.h),
              TextButton(
                onPressed: _handlePermissionDenied,
                child: Text(l10n.openSettings),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          // Camera preview or captured image
          Positioned.fill(
            child: _capturedImage != null
                ? Image.file(_capturedImage!, fit: BoxFit.cover)
                : _errorMessage != null
                ? _buildErrorState()
                : _isInitializing
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : _buildCameraPreview(),
          ),

          // Close button (safe-area aware)
          Positioned(
            top: padding.top + 8.h,
            left: 16.w,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 32.sp),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Bottom buttons (safe-area aware)
          Positioned(
            bottom: padding.bottom + 32.h,
            left: 0,
            right: 0,
            child: _capturedImage != null
                ? _buildConfirmationButtons()
                : _buildCaptureButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureButton() {
    return Center(
      child: GestureDetector(
        onTap: _capturePhoto,
        child: Container(
          width: 70.w,
          height: 70.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 4.w),
          ),
          child: Icon(Icons.camera, color: Colors.black, size: 40.sp),
        ),
      ),
    );
  }

  Widget _buildConfirmationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Retake button
        GestureDetector(
          onTap: _retakePhoto,
          child: Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withValues(alpha: 0.8),
              border: Border.all(color: Colors.white, width: 3.w),
            ),
            child: Icon(Icons.close, color: Colors.white, size: 30.sp),
          ),
        ),
        SizedBox(width: 40.w),
        // Confirm button
        GestureDetector(
          onTap: () {
            if (_capturedImage != null) {
              Navigator.pop(context, _capturedImage);
            }
          },
          child: Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withValues(alpha: 0.8),
              border: Border.all(color: Colors.white, width: 3.w),
            ),
            child: Icon(Icons.check, color: Colors.white, size: 30.sp),
          ),
        ),
      ],
    );
  }
}
