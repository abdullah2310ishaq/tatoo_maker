import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/colors.dart';

class TutorialOverlay extends StatefulWidget {
  final GlobalKey highlightKey;
  final Future<void> Function() onDismiss;
  final Future<bool> Function(String assetPath) checkAssetExists;

  //
  const TutorialOverlay({
    super.key,
    required this.highlightKey,
    required this.onDismiss,
    required this.checkAssetExists,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final RenderBox? overlayBox = context.findRenderObject() as RenderBox?;
    final RenderBox? cardBox =
        widget.highlightKey.currentContext?.findRenderObject() as RenderBox?;

    Offset? cardLocalPosition;
    Size? cardSize;

    if (overlayBox != null &&
        overlayBox.hasSize &&
        cardBox != null &&
        cardBox.hasSize) {
      final Offset cardGlobal = cardBox.localToGlobal(Offset.zero);
      cardLocalPosition = overlayBox.globalToLocal(cardGlobal);
      cardSize = cardBox.size;
    }

    if (cardLocalPosition == null || cardSize == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });

      return GestureDetector(
        onTap: () async => widget.onDismiss(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: isDark
                ? Colors.black.withValues(alpha: 0.9)
                : Colors.black.withValues(alpha: 0.9),
          ),
        ),
      );
    }

    final cardRect = Rect.fromLTWH(
      cardLocalPosition.dx,
      cardLocalPosition.dy,
      cardSize.width,
      cardSize.height,
    );

    return GestureDetector(
      onTap: () async => widget.onDismiss(),
      child: Stack(
        children: [
          ClipPath(
            clipper: TutorialOverlayClipper(cardRect: cardRect),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: TutorialOverlayPainter(
                cardRect: cardRect,
                overlayColor: isDark
                    ? Colors.black.withValues(alpha: 0.7)
                    : Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ),
          Positioned(
            top: cardLocalPosition.dy + cardSize.height - 5.h,
            left: 0,
            right: 0,
            bottom: 100.h,
            child: Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder<bool>(
                    future: widget.checkAssetExists('assets/arrow.svg'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return SvgPicture.asset(
                          'assets/arrow.svg',
                          width: 40.w,
                          height: 40.h,
                          colorFilter: const ColorFilter.mode(
                            AppColors.titleGradientStart,
                            BlendMode.srcIn,
                          ),
                        );
                      }
                      return Icon(
                        Icons.arrow_upward_rounded,
                        size: 60.sp,
                        color: AppColors.titleGradientStart,
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 8.h,
                    ),
                    child: Text(
                      l10n.homeTutorialOverlayText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Amaranth',
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom clipper to exclude the highlighted card area from blur.
class TutorialOverlayClipper extends CustomClipper<Path> {
  final Rect cardRect;

  TutorialOverlayClipper({required this.cardRect});

  @override
  Path getClip(Size size) {
    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cardPath = Path()
      ..addRRect(RRect.fromRectAndRadius(cardRect, const Radius.circular(16)));

    return Path.combine(PathOperation.difference, overlayPath, cardPath);
  }

  @override
  bool shouldReclip(TutorialOverlayClipper oldClipper) {
    return oldClipper.cardRect != cardRect;
  }
}

/// Custom painter that draws the darkened overlay and leaves a "hole" for the card.
class TutorialOverlayPainter extends CustomPainter {
  final Rect cardRect;
  final Color overlayColor;

  TutorialOverlayPainter({required this.cardRect, required this.overlayColor});

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cardPath = Path()
      ..addRRect(RRect.fromRectAndRadius(cardRect, const Radius.circular(16)));

    final combinedPath = Path.combine(
      PathOperation.difference,
      overlayPath,
      cardPath,
    );

    final paint = Paint()..color = overlayColor;
    canvas.drawPath(combinedPath, paint);
  }

  @override
  bool shouldRepaint(TutorialOverlayPainter oldDelegate) {
    return oldDelegate.cardRect != cardRect ||
        oldDelegate.overlayColor != overlayColor;
  }
}
