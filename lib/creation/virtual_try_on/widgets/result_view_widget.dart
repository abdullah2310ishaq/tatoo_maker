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
  bool _didAutoCenter = false;
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
    final oldPath = oldWidget.bodyPartImage?.path;
    final newPath = widget.bodyPartImage?.path;
    if (oldPath != newPath) {
      _didAutoCenter = false;
    }
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);

        // Keep the tattoo generally within the image area, but allow more freedom
        // in both directions by clamping based on the tattoo *center*.
        const double edgeInset = 8.0;
        Offset clampToViewport(Offset position, double scale) {
          final size = baseTattooSize * scale;
          final half = size / 2;

          // Horizontal: allow the center to travel almost full width.
          double minX = -half + edgeInset;
          double maxX = viewportSize.width - half - edgeInset;
          if (minX > maxX) {
            final mid = (minX + maxX) / 2;
            minX = mid;
            maxX = mid;
          }

          // Vertical: allow the center to travel almost full height.
          double minY = -half + edgeInset;
          double maxY = viewportSize.height - half - edgeInset;
          if (minY > maxY) {
            final mid = (minY + maxY) / 2;
            minY = mid;
            maxY = mid;
          }

          return Offset(
            position.dx.clamp(minX, maxX),
            position.dy.clamp(minY, maxY),
          );
        }

        // Auto-center once when a new image is loaded (or when position was reset).
        if (!_didAutoCenter &&
            viewportSize.width > 0 &&
            viewportSize.height > 0 &&
            widget.tattooImageBytes != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _didAutoCenter) return;
            final centered = Offset(
              (viewportSize.width - (baseTattooSize * widget.tattooScale)) / 2,
              (viewportSize.height - (baseTattooSize * widget.tattooScale)) / 2,
            );
            widget.onTattooTransform(
              clampToViewport(centered, widget.tattooScale),
              widget.tattooScale,
              widget.tattooRotation,
            );
            if (mounted) {
              setState(() => _didAutoCenter = true);
            }
          });
        }

        final RenderBox? contentBox = context.findRenderObject() as RenderBox?;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: (details) {
            if (details.pointerCount == 1) {
              _panStartPosition = widget.tattooPosition;
              _panStartLocal = contentBox?.globalToLocal(details.focalPoint) ?? details.focalPoint;
            } else if (details.pointerCount >= 2) {
              _scaleStart = widget.tattooScale;
              _rotationStart = widget.tattooRotation;
              _focalStart = contentBox?.globalToLocal(details.focalPoint) ?? details.focalPoint;
              _positionStart = widget.tattooPosition;
            }
          },
          onScaleUpdate: (details) {
            if (details.pointerCount == 1) {
              if (_panStartPosition == null || _panStartLocal == null) return;
              final localNow = contentBox?.globalToLocal(details.focalPoint) ?? details.focalPoint;
              final newPosition = clampToViewport(
                _panStartPosition! + (localNow - _panStartLocal!),
                widget.tattooScale,
              );
              widget.onTattooTransform(
                newPosition,
                widget.tattooScale,
                widget.tattooRotation,
              );
            } else if (details.pointerCount >= 2) {
              final newScale = (_scaleStart * details.scale).clamp(0.25, 3.0);
              final newRotation = _rotationStart + details.rotation;
              final localNow = contentBox?.globalToLocal(details.focalPoint) ?? details.focalPoint;
              final newPosition = clampToViewport(
                _positionStart + (localNow - _focalStart),
                newScale,
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
            child: SizedBox.expand(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Make the body photo fill the available area for a more
                  // "professional" try-on look (bigger image on screen).
                  Positioned.fill(
                    child: ClipRect(
                      child: Image.file(
                        widget.bodyPartImage!,
                        key: _bodyImageKey,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
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
          ),
        );
      },
    );
  }
}
