import 'package:flutter/material.dart';
import '../utils/colors.dart';

class InkVisionUnderline extends StatelessWidget {
  final double width;
  final double height;

  const InkVisionUnderline({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _InkVisionUnderlinePainter(
          startColor: AppColors.titleGradientStart,
          endColor: AppColors.titleGradientStart,
        ),
      ),
    );
  }
}

class _InkVisionUnderlinePainter extends CustomPainter {
  final Color startColor;
  final Color endColor;

  const _InkVisionUnderlinePainter({
    required this.startColor,
    required this.endColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Lens-like shape: thin edges, thick center.
    final minThickness = size.height * 0.25;
    final maxThickness = size.height * 0.9;
    final midY = size.height / 2;

    final shader = RadialGradient(
      center: const Alignment(0.0, -0.25), // ~37% from top visually
      radius: 0.95,
      colors: [startColor, endColor],
    ).createShader(Offset.zero & size);

    final paint = Paint()
      ..shader = shader
      ..style = PaintingStyle.fill;

    final leftX = 0.0;
    final rightX = size.width;
    final centerX = size.width / 2;

    final path = Path()
      ..moveTo(leftX, midY)
      ..quadraticBezierTo(centerX, midY - (maxThickness / 2), rightX, midY)
      ..quadraticBezierTo(centerX, midY + (maxThickness / 2), leftX, midY)
      ..close();

    // Clip a tiny bit to keep edges thin.
    final clipRect = Rect.fromLTWH(
      0,
      (size.height - maxThickness) / 2,
      size.width,
      maxThickness,
    );
    canvas.save();
    canvas.clipRect(clipRect);
    canvas.drawPath(path, paint);
    canvas.restore();

    // Ensure ends are visibly thin (small caps).
    final capPaint = Paint()
      ..color = endColor.withOpacity(0.9)
      ..style = PaintingStyle.fill;
    final capRadius = minThickness / 2;
    canvas.drawCircle(Offset(leftX + capRadius, midY), capRadius, capPaint);
    canvas.drawCircle(Offset(rightX - capRadius, midY), capRadius, capPaint);
  }

  @override
  bool shouldRepaint(covariant _InkVisionUnderlinePainter oldDelegate) {
    return oldDelegate.startColor != startColor ||
        oldDelegate.endColor != endColor;
  }
}
