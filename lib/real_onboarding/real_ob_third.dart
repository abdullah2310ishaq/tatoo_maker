import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../utils/colors.dart';

class RealOnboardingThirdScreen extends StatelessWidget {
  const RealOnboardingThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Light theme only for onboarding
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ---------- TOP FLORAL ASSET ---------- (light theme only)
                Image.asset(
                  'assets/splash/third_one_light.png',
                  height: 225.h,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: 2.h),

                // ---------- TITLE ----------
                Text(
                  AppLocalizations.of(context)!.tattooMaker,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Amaranth',
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 24.h),

                // ---------- KEYBOARD ASSET ---------- (light theme only)
                Image.asset(
                  'assets/splash/third_two_light.png',
                  height: 120.h,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: 28.h),

                // ---------- FEATURE TITLE ----------
                Text(
                  AppLocalizations.of(context)!.flowerCreation,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amaranth',
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 8.h),

                // ---------- DESCRIPTION ----------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Text(
                    AppLocalizations.of(context)!.flowerCreationDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      height: 1.4,
                      fontFamily: 'Amaranth',
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
