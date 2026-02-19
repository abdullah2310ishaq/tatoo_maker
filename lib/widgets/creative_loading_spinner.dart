import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class CreativeLoadingSpinner extends StatefulWidget {
  final double? size;
  const CreativeLoadingSpinner({super.key, this.size});

  @override
  State<CreativeLoadingSpinner> createState() => _CreativeLoadingSpinnerState();
}

class _CreativeLoadingSpinnerState extends State<CreativeLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      // Total duration: rotation is slow, fade cycle sits on top of it.
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = widget.size ?? 200.w;

    final segmentColor = isDark ? Colors.white : const Color(0xFF1C1C1E);
    const accent = Color(0xFFFE8B3A);

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _SegmentSpinnerPainter(
              progress: _controller.value,
              segmentColor: segmentColor,
              accentColor: Colors.transparent,
              isDark: isDark,
            ),
          );
        },
      ),
    );
  }
}

class _SegmentSpinnerPainter extends CustomPainter {
  final double progress;
  final Color segmentColor;
  final Color accentColor;
  final bool isDark;

  const _SegmentSpinnerPainter({
    required this.progress,
    required this.segmentColor,
    required this.accentColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final c = Offset(cx, cy);
    final maxR = size.width / 2;

    const totalSegments = 4;
    const gapDeg = 5.0;
    const sliceDeg = 360.0 / totalSegments; // 45°
    const arcDeg = sliceDeg - gapDeg; // ~32°
    final arcRad = arcDeg * math.pi / 180;

    final radius = maxR - 6;
    final strokeWidth = maxR * 0.22;

    final rotation = progress * 2 * math.pi;

    final sineVal = (math.sin(progress * 2 * math.pi) + 1) / 2; // 0→1→0
    final opacityA = sineVal; // even segments
    final opacityB = 1.0 - sineVal; // odd segments

    // ── Draw ──────────────────────────────────────────────────────────────
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: c, radius: radius);

    for (int i = 0; i < totalSegments; i++) {
      final opacity = i.isEven ? opacityA : opacityB;
      if (opacity <= 0.01) continue;

      final baseAngle = (i * sliceDeg) * math.pi / 180;
      final startAngle = baseAngle + rotation - math.pi / 2;

      paint.color = segmentColor.withOpacity(opacity);
      canvas.drawArc(rect, startAngle, arcRad, false, paint);

      // Tiny accent dot at leading tip
      if (opacity > 0.4) {
        final dotAngle = startAngle + arcRad;
        canvas.drawCircle(
          Offset(
            cx + radius * math.cos(dotAngle),
            cy + radius * math.sin(dotAngle),
          ),
          strokeWidth * 0.18,
          Paint()..color = accentColor.withOpacity(opacity * 0.85),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SegmentSpinnerPainter old) =>
      old.progress != progress ||
      old.segmentColor != segmentColor ||
      old.isDark != isDark;
}
