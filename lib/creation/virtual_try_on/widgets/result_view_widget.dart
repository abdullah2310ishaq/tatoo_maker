import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../../../utils/colors.dart';

class ResultViewWidget extends StatefulWidget {
  final File? bodyPartImage;
  final Uint8List? tattooImageBytes;
  final Uint8List? processedTryOnBytes;
  final bool isProcessing;
  final Offset tattooPosition;
  final double tattooScale;
  final double tattooRotation;
  final GlobalKey previewRepaintKey;
  final Function(Offset, double, double) onTattooTransform;
  final bool isDark;

  const ResultViewWidget({
    super.key,
    required this.bodyPartImage,
    required this.tattooImageBytes,
    required this.processedTryOnBytes,
    required this.isProcessing,
    required this.tattooPosition,
    required this.tattooScale,
    required this.tattooRotation,
    required this.previewRepaintKey,
    required this.onTattooTransform,
    required this.isDark,
  });

  @override
  State<ResultViewWidget> createState() => _ResultViewWidgetState();
}

class _ResultViewWidgetState extends State<ResultViewWidget> {
  final GlobalKey _bodyImageKey = GlobalKey();
  // Pan (single finger): anchor so drag is 1:1 with finger
  Offset? _panStartPosition;
  Offset? _panStartLocal;
  // Scale (two fingers): cumulative from gesture start
  double _scaleStart = 1.0;
  double _rotationStart = 0.0;
  Offset _focalStart = Offset.zero;
  Offset _positionStart = Offset.zero;

  @override
  void didUpdateWidget(ResultViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isProcessing) {
      final l10n = AppLocalizations.of(context)!;
      return Container(
        color: AppColors.gradientBlack.withValues(alpha: 0.5),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.cardGlowStart),
              const SizedBox(height: 16),
              Text(
                l10n.virtualTryOnProcessingTitle,
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 16,
                  fontFamily: 'Amaranth',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.virtualTryOnProcessingSubtitle,
                style: TextStyle(
                  color: AppColors.textWhite.withValues(alpha: 0.7),
                  fontSize: 14,
                  fontFamily: 'Amaranth',
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (widget.processedTryOnBytes != null) {
      // Show processed result - pinch‑zoom & pan
      return InteractiveViewer(
        minScale: 1.0,
        maxScale: 4.0,
        panEnabled: true,
        scaleEnabled: true,
        child: Center(
          child: Image.memory(widget.processedTryOnBytes!, fit: BoxFit.contain),
        ),
      );
    }

    // Use only scale gesture: 1 finger = pan (position), 2+ fingers = scale + rotate
    const double baseTattooSize = 200.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (details) {
        if (details.pointerCount == 1) {
          _panStartPosition = widget.tattooPosition;
          _panStartLocal = details.focalPoint;
        } else if (details.pointerCount >= 2) {
          _scaleStart = widget.tattooScale;
          _rotationStart = widget.tattooRotation;
          _focalStart = details.focalPoint;
          _positionStart = widget.tattooPosition;
        }
      },
      onScaleUpdate: (details) {
        if (details.pointerCount == 1) {
          if (_panStartPosition == null || _panStartLocal == null) return;
          Offset newPosition =
              _panStartPosition! + (details.focalPoint - _panStartLocal!);
          newPosition = _clampPositionToImage(
            context,
            newPosition,
            widget.tattooScale,
            baseTattooSize,
          );
          widget.onTattooTransform(
            newPosition,
            widget.tattooScale,
            widget.tattooRotation,
          );
        } else if (details.pointerCount >= 2) {
          double newScale = (_scaleStart * details.scale).clamp(0.25, 3.0);
          double newRotation = _rotationStart + details.rotation;
          Offset newPosition =
              _positionStart + (details.focalPoint - _focalStart);
          newPosition = _clampPositionToImage(
            context,
            newPosition,
            newScale,
            baseTattooSize,
          );
          widget.onTattooTransform(newPosition, newScale, newRotation);
        }
      },
      onScaleEnd: (_) {
        _panStartPosition = null;
        _panStartLocal = null;
      },
      child: RepaintBoundary(
        key: widget.previewRepaintKey,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Body part image
            Center(
              child: Image.file(
                widget.bodyPartImage!,
                key: _bodyImageKey,
                fit: BoxFit.contain,
              ),
            ),
            if (widget.tattooImageBytes != null)
              Positioned(
                left: widget.tattooPosition.dx,
                top: widget.tattooPosition.dy,
                child: Transform.scale(
                  scale: widget.tattooScale,
                  child: Transform.rotate(
                    angle: widget.tattooRotation,
                    child: Image.memory(
                      widget.tattooImageBytes!,
                      width: baseTattooSize,
                      height: baseTattooSize,
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

  /// Allow full range so tattoo reaches all edges (left, right, top, bottom). No clamping.
  Offset _clampPositionToImage(
    BuildContext context,
    Offset position,
    double scale,
    double baseTattooSize,
  ) {
    // Don't clamp: let position go anywhere so left/right/top/bottom all work.
    return position;
  }
}
