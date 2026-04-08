import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../utils/colors.dart';
import '../widgets/remote_or_asset_image.dart';

/// Second onboarding screen - Custom creation
class RealOnboardingSecondScreen extends StatelessWidget {
  const RealOnboardingSecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: RemoteOrAssetImage(
            assetPath: 'assets/splash/splash_two.png',
            fit: BoxFit.cover,
            errorWidget: Container(color: AppColors.lightBackground),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 124),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.30),
                    Colors.black.withOpacity(0.99),
                    Colors.black.withOpacity(0.95),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.customCreation,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: false,
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
                      AppLocalizations.of(context)!.customCreationDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
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
