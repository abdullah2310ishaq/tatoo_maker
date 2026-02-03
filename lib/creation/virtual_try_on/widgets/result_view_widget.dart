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
  // Gesture tracking variables for smooth interaction
  double _lastScale = 1.0;
  double _lastRotation = 0.0;
  Offset _lastFocalPoint = Offset.zero;
  Offset _lastPosition = Offset.zero;
  final GlobalKey _bodyImageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _lastPosition = widget.tattooPosition;
  }

  @override
  void didUpdateWidget(ResultViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tattooPosition != widget.tattooPosition) {
      _lastPosition = widget.tattooPosition;
    }
    if (oldWidget.tattooScale != widget.tattooScale) {
      _lastScale = widget.tattooScale;
    }
    if (oldWidget.tattooRotation != widget.tattooRotation) {
      _lastRotation = widget.tattooRotation;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isProcessing) {
      final l10n = AppLocalizations.of(context)!;
      return Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.cardGlowStart),
              const SizedBox(height: 16),
              Text(
                l10n.virtualTryOnProcessingTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Amaranth',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.virtualTryOnProcessingSubtitle,
                style: const TextStyle(
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

    // Show preview with tattoo overlay (before processing) - smooth gesture handling
    return GestureDetector(
      onScaleStart: (details) {
        _lastScale = widget.tattooScale;
        _lastRotation = widget.tattooRotation;
        _lastFocalPoint = details.focalPoint;
        _lastPosition = widget.tattooPosition;
      },
      onScaleUpdate: (details) {
        // Calculate new values with more direct, less "floaty" response
        
        double newScale = _lastScale * details.scale;
        double newRotation = _lastRotation + details.rotation;

        // Use incremental focal point delta for snappier dragging.
        final Offset focalDelta = details.focalPoint - _lastFocalPoint;
        Offset newPosition = _lastPosition + focalDelta;
        _lastFocalPoint = details.focalPoint;

        // Clamp scale to reasonable bounds
        newScale = newScale.clamp(0.5, 3.0);

        // Clamp tattoo position so it stays within the body image bounds
        final RenderBox? stackBox = context.findRenderObject() as RenderBox?;
        final RenderBox? imageBox =
            _bodyImageKey.currentContext?.findRenderObject() as RenderBox?;

        if (stackBox != null &&
            stackBox.hasSize &&
            imageBox != null &&
            imageBox.hasSize) {
          final Offset imageTopLeftInStack = stackBox.globalToLocal(
            imageBox.localToGlobal(Offset.zero),
          );
          final Size imageSize = imageBox.size;
          final Rect imageRect = imageTopLeftInStack & imageSize;

          // Approximate tattoo size as a square scaled from base size.
          const double baseTattooSize = 200;
          final double tattooSide = baseTattooSize * newScale;
          final Size tattooSize = Size(tattooSide, tattooSide);

          final double minX = imageRect.left;
          final double maxX = imageRect.right - tattooSize.width;
          final double minY = imageRect.top;
          final double maxY = imageRect.bottom - tattooSize.height;

          double clampedDx = newPosition.dx;
          double clampedDy = newPosition.dy;

          if (maxX >= minX) {
            clampedDx = clampedDx.clamp(minX, maxX);
          } else {
            // Tattoo wider than image: keep horizontally centered over image.
            clampedDx = imageRect.left +
                (imageRect.width - tattooSize.width) / 2.0;
          }

          if (maxY >= minY) {
            clampedDy = clampedDy.clamp(minY, maxY);
          } else {
            // Tattoo taller than image: keep vertically centered over image.
            clampedDy = imageRect.top +
                (imageRect.height - tattooSize.height) / 2.0;
          }

          newPosition = Offset(clampedDx, clampedDy);
        }

        // Update immediately for smooth interaction
        widget.onTattooTransform(newPosition, newScale, newRotation);
      },
      onScaleEnd: (details) {
        // Reset tracking on gesture end
        _lastScale = widget.tattooScale;
        _lastRotation = widget.tattooRotation;
        _lastPosition = widget.tattooPosition;
      },
      child: RepaintBoundary(
        key: widget.previewRepaintKey,
        child: Stack(
          children: [
            // Body part image
            Center(
              child: Image.file(
                widget.bodyPartImage!,
                key: _bodyImageKey,
                fit: BoxFit.contain,
              ),
            ),
            // Tattoo overlay (draggable) - smooth gesture handling
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
