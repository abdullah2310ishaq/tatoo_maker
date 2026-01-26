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
        // Calculate new values with smooth interpolation
        double newScale = _lastScale * details.scale;
        double newRotation = _lastRotation + details.rotation;

        // Calculate position change relative to focal point for smooth panning
        // Apply sensitivity reduction (0.1 = 90% less sensitive for more controlled movement)
        final delta = (details.focalPoint - _lastFocalPoint) * 0.1;
        Offset newPosition = _lastPosition + delta;

        // Clamp scale to reasonable bounds
        newScale = newScale.clamp(0.5, 3.0);

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
              child: Image.file(widget.bodyPartImage!, fit: BoxFit.contain),
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
