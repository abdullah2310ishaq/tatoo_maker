import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_maker/providers/usage_limit_provider.dart';
import 'package:tatoo_maker/services/native_ad_service.dart';
import 'package:tatoo_maker/utils/colors.dart';

/// Medium native for onboarding page 2 — shown below the Continue CTA.
class RealOnboardingBottomNativeAd extends StatelessWidget {
  const RealOnboardingBottomNativeAd({super.key});

  static const String slotKey = 'real_onboarding_page_two';

  static int get nativeBackgroundColor => AppColors.darkBackground.value;

  @override
  Widget build(BuildContext context) {
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    if (isPro) {
      return const SizedBox.shrink();
    }

    final nativeService = context.watch<NativeAdService>();
    final ad = nativeService.adForKey(slotKey);
    if (!nativeService.isLoadedForKey(slotKey) || ad == null) {
      return SizedBox(height: 280.h);
    }

    final radius = BorderRadius.circular(14.r);
    return Material(
      color: AppColors.darkBackground,
      elevation: 0,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: double.infinity,
        height: 280.h,
        child: AdWidget(ad: ad),
      ),
    );
  }
}
