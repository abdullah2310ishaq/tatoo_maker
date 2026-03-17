import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';

class RealOnboardingThirdScreen extends StatelessWidget {
  const RealOnboardingThirdScreen({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    // Dark theme style with shared gradient background
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Container(
        decoration: ThemeManager.darkModeBackgroundGradient,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              children: [
                SizedBox(height: 95.h),
                // Moon Owl pill label
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF404040),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.moonOwl,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Tomorrow',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Big owl image centered
                Image.asset(
                  'assets/splash/owl.png',
                  height: 340.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 15.h),
                // Title and subtitle
                Text(
                  AppLocalizations.of(context)!.moonOwlTitle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Amaranth',
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  AppLocalizations.of(context)!.moonOwlSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    height: 1.4,
                    fontFamily: 'Amaranth',
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA6541D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.continue_,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Amaranth',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 44.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
