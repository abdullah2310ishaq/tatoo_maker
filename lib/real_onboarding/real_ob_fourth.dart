import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../utils/colors.dart';

/// Fourth onboarding screen - Try-on preview
class RealOnboardingFourthScreen extends StatelessWidget {
  const RealOnboardingFourthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image - full cover
        Positioned.fill(
          child: Image.asset(
            'assets/splash/splash_four.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: AppColors.lightBackground);
            },
          ),
        ),

        // ✅ BOX OVERLAY (ADDED)
        const Positioned.fill(child: TattooSelectionBox()),

        // Bottom gradient text area
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 124.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.75),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.tryOnAiTattoos,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Amaranth',
                          shadows: const [
                            Shadow(
                              color: Colors.black87,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      AppLocalizations.of(context)!.tryOnAiTattoosSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                        fontFamily: 'Amaranth',
                        height: 1.4,
                        shadows: const [
                          Shadow(
                            color: Colors.black87,
                            offset: Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TattooSelectionBox extends StatelessWidget {
  const TattooSelectionBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: -0.25,
        child: Container(
          width: 230.w,
          height: 280.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Stack(
            clipBehavior: Clip.none, // ✅ IMPORTANT (allow outside)
            children: [
              _dot(Alignment.topLeft, Offset(-8, -8)),
              _dot(Alignment.topRight, Offset(8, -8)),
              _dot(Alignment.bottomLeft, Offset(-8, 8)),
              _dot(Alignment.bottomRight, Offset(8, 8)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(Alignment alignment, Offset offset) {
    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: offset, // ✅ pushes dot outside
        child: Container(
          width: 16.w,
          height: 16.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
