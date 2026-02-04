import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../utils/toast.dart';
import 'virtual_try_on/pages/camera_preview_screen.dart';
import 'virtual_try_on/widgets/empty_state_widget.dart';
import 'virtual_try_on/widgets/result_view_widget.dart';
import 'virtual_try_on/widgets/virtual_try_on_header.dart';
import 'virtual_try_on/widgets/action_buttons_widget.dart';

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
  final GlobalKey _previewRepaintKey = GlobalKey();

  Future<void> _requestPermissions() async {
    final l10n = AppLocalizations.of(context)!;
    final cameraStatus = await Permission.camera.status;
    final photosStatus = await Permission.photos.status;

    if (!cameraStatus.isGranted) {
      final cameraResult = await Permission.camera.request();
      if (!cameraResult.isGranted) {
        if (mounted) {
          _showPermissionDialog(l10n.cameraPermissionIsRequiredToTakePhotos);
        }
        return;
      }
    }

    if (!photosStatus.isGranted) {
      await Permission.photos.request();
      // Photos permission is not critical - continue anyway
    }
  }

  void _showPermissionDialog(String message) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.permissionRequired),
        content: Text(message),
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

  void _showPhotoSourceDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.choosePhotoSource),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.capturePhoto),
              onTap: () {
                Navigator.of(context).pop();
                _openCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.chooseFromGallery),
              onTap: () {
                Navigator.of(context).pop();
                _pickFromGallery();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  Future<void> _openCamera() async {
    await _requestPermissions();
    if (!mounted) return;

    final confirmedImage = await Navigator.push<File>(
      context,
      MaterialPageRoute(builder: (context) => const CameraPreviewScreen()),
    );
    if (!mounted) return;

    if (confirmedImage != null) {
      setState(() {
        _bodyPartImage = confirmedImage;
        _processedTryOnBytes = null;
        // Let ResultViewWidget auto-center after layout.
        _tattooPosition = Offset.zero;
        _tattooScale = 1.0;
        _tattooRotation = 0.0;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    await _requestPermissions();
    if (!mounted) return;

    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    if (xFile == null) return;

    final file = File(xFile.path);
    if (!file.existsSync()) return;

    setState(() {
      _bodyPartImage = file;
      _processedTryOnBytes = null;
      // Let ResultViewWidget auto-center after layout.
      _tattooPosition = Offset.zero;
      _tattooScale = 1.0;
      _tattooRotation = 0.0;
    });
  }

  /// Automatically process image: combine body image + tattoo overlay and send to API
  Future<void> _processImageAutomatically(File imageFile) async {
    if (widget.tattooImageBytes == null) {
      debugPrint('VirtualTryOn: No tattoo image to process');
      return;
    }

    final l10n = AppLocalizations.of(context)!;
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

      // Adaptive pixel ratio based on device capabilities
      // Lower on low-end devices to prevent OOM
      final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
      final pixelRatio = devicePixelRatio > 2.0 ? 2.0 : devicePixelRatio;

      final uiImage = await boundary.toImage(pixelRatio: pixelRatio);
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
        AppToast.show(
          context,
          message: l10n.virtualTryOnProcessingFailedTryAgain,
          isSuccess: false,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _saveToGallery() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      if (_processedTryOnBytes == null) {
        if (!mounted) return;
        AppToast.show(
          context,
          message: l10n.noImageToSave,
          isSuccess: false,
          duration: const Duration(seconds: 2),
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
        AppToast.show(
          context,
          message: l10n.imageSavedToGalleryExcited,
          isSuccess: true,
        );
      }
    } catch (e) {
      debugPrint('Error saving image: $e');
      if (mounted) {
        AppToast.show(
          context,
          message: l10n.couldntSaveImageTryAgain,
          isSuccess: false,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _handleTattooTransform(Offset position, double scale, double rotation) {
    setState(() {
      _tattooPosition = position;
      _tattooScale = scale;
      _tattooRotation = rotation;
      // Any change to placement invalidates previous processed result
      _processedTryOnBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

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
              VirtualTryOnHeader(
                isDark: isDark,
                onClose: () => Navigator.of(context).pop(),
              ),
              // Main content area
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    Expanded(
                      child: _bodyPartImage == null
                          ? EmptyStateWidget(isDark: isDark)
                          : ResultViewWidget(
                              bodyPartImage: _bodyPartImage,
                              tattooImageBytes: widget.tattooImageBytes,
                              processedTryOnBytes: _processedTryOnBytes,
                              isProcessing: _isProcessing,
                              tattooPosition: _tattooPosition,
                              tattooScale: _tattooScale,
                              tattooRotation: _tattooRotation,
                              previewRepaintKey: _previewRepaintKey,
                              onTattooTransform: _handleTattooTransform,
                              isDark: isDark,
                            ),
                    ),
                    // Action buttons
                    ActionButtonsWidget(
                      bodyPartImage: _bodyPartImage,
                      isProcessing: _isProcessing,
                      isSaving: _isSaving,
                      processedTryOnBytes: _processedTryOnBytes,
                      onCapturePhoto: _showPhotoSourceDialog,
                      onApply: () async {
                        if (_bodyPartImage == null) {
                          return;
                        }
                        await _processImageAutomatically(_bodyPartImage!);
                      },
                      onSave: _saveToGallery,
                      bottomPadding: bottomPadding,
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
}
