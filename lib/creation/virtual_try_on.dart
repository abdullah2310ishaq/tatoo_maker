import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../home_shell.dart';
import '../providers/usage_limit_provider.dart';
import '../services/admob_ids.dart';
import '../services/app_open_ad_service.dart';
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
  final bool returnToHomeAfterSave;

  const VirtualTryOnScreen({
    super.key,
    this.tattooImageBytes,
    required this.styleName,
    this.returnToHomeAfterSave = true,
  });

  @override
  State<VirtualTryOnScreen> createState() => _VirtualTryOnScreenState();
}

class _VirtualTryOnScreenState extends State<VirtualTryOnScreen> {
  static const String _watermarkLightAssetPath = 'assets/watermark_light.png';
  static const String _watermarkDarkAssetPath = 'assets/watermark_dark.png';
  File? _bodyPartImage;
  bool _isSaving = false;
  bool _isProcessing = false;
  Uint8List? _processedTryOnBytes; // final processed output (captured preview)
  Offset _tattooPosition = const Offset(200, 300);
  double _tattooScale = 1.0;
  double _tattooRotation = 0.0;
  final GlobalKey _previewRepaintKey = GlobalKey();

  void _showAppOpenAfterMediaReturn() {
    if (!mounted) return;
    final isProUnlocked = context.read<UsageLimitProvider>().isProUnlocked;
    if (isProUnlocked) return;

    unawaited(
      AppOpenAdService.instance.showIfAvailable(
        unitIdOverride: AdmobIds.appOpenUnitId(),
        waitForLoad: false,
        waitForDismiss: false,
      ),
    );
  }

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
      _showAppOpenAfterMediaReturn();
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
    _showAppOpenAfterMediaReturn();
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

  Future<Uint8List> _applyWatermarkToPngBytes({
    required Uint8List basePngBytes,
    required bool isDark,
  }) async {
    final codec = await ui.instantiateImageCodec(basePngBytes);
    final baseFrame = await codec.getNextFrame();
    final baseImage = baseFrame.image;

    final watermarkAssetPath =
        isDark ? _watermarkDarkAssetPath : _watermarkLightAssetPath;
    final watermarkData = await rootBundle.load(watermarkAssetPath);
    final watermarkCodec = await ui.instantiateImageCodec(
      watermarkData.buffer.asUint8List(),
    );
    final watermarkFrame = await watermarkCodec.getNextFrame();
    final watermarkImage = watermarkFrame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawImage(baseImage, Offset.zero, Paint());

    // Match ResultScreen watermark style: large overlay across the image (top-center).
    final double targetWidth = baseImage.width * 2.25;
    final double aspect = watermarkImage.height == 0
        ? 1.0
        : (watermarkImage.width / watermarkImage.height);
    final double targetHeight = targetWidth / aspect;

    final double left = (baseImage.width - targetWidth) / 2;
    // Clamp safely even when watermark is larger than the base image.
    final double maxTop = (baseImage.height - targetHeight).toDouble();
    final double preferredTop = (baseImage.height * 0.15).toDouble();
    final double top = maxTop <= 0 ? 0.0 : preferredTop.clamp(0.0, maxTop);
    final dst = Rect.fromLTWH(
      left,
      top,
      targetWidth,
      targetHeight,
    );
    final src = Rect.fromLTWH(
      0,
      0,
      watermarkImage.width.toDouble(),
      watermarkImage.height.toDouble(),
    );

    final paint = Paint()
      ..filterQuality = FilterQuality.high
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.35);
    canvas.drawImageRect(watermarkImage, src, dst, paint);

    final picture = recorder.endRecording();
    final outImage = await picture.toImage(baseImage.width, baseImage.height);
    final outBytes = await outImage.toByteData(format: ui.ImageByteFormat.png);
    if (outBytes == null) {
      // Fallback: return original.
      return basePngBytes;
    }
    return outBytes.buffer.asUint8List();
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

      final isDark = Theme.of(context).brightness == Brightness.dark;
      final isProUnlocked = context.read<UsageLimitProvider>().isProUnlocked;
      final bytesToSave = (!isProUnlocked)
          ? await _applyWatermarkToPngBytes(
              basePngBytes: _processedTryOnBytes!,
              isDark: isDark,
            )
          : _processedTryOnBytes!;

      await Gal.putImageBytes(
        bytesToSave,
        name:
            '${widget.styleName}_tryon_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      if (mounted) {
        AppToast.show(
          context,
          message: l10n.imageSavedToGalleryExcited,
          isSuccess: true,
        );

        // After save, either return home (default) or back to previous screen.
        await Future<void>.delayed(const Duration(milliseconds: 250));
        if (!mounted) return;
        if (widget.returnToHomeAfterSave) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeShell()),
            (route) => false,
          );
        } else {
          Navigator.of(context).pop();
        }
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
