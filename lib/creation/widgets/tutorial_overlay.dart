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
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final safeAreaTop = mediaQuery.padding.top;

    final RenderBox? cardBox =
        widget.highlightKey.currentContext?.findRenderObject() as RenderBox?;
    final Offset? cardScreenPosition = cardBox?.localToGlobal(Offset.zero);
    final Size? cardSize = cardBox?.size;

    if (cardScreenPosition == null || cardSize == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });

      return GestureDetector(
        onTap: () async => widget.onDismiss(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: isDark
                ? Colors.black.withOpacity(0.8)
                : Colors.black.withOpacity(0.7),
          ),
        ),
      );
    }

    final cardPosition = Offset(
      cardScreenPosition.dx,
      cardScreenPosition.dy - safeAreaTop,
    );

    final cardRect = Rect.fromLTWH(
      cardPosition.dx,
      cardPosition.dy - 40.h,
      cardSize.width,
      cardSize.height + 1.h,
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
              size: screenSize,
              painter: TutorialOverlayPainter(
                cardRect: cardRect,
                overlayColor: isDark
                    ? Colors.black.withOpacity(0.7)
                    : Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Positioned(
            top: cardPosition.dy + cardSize.height - 38.h,
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
                          width: 60.w,
                          height: 60.h,
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
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
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
