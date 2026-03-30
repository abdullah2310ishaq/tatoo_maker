import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'utils/colors.dart';

class ProAccessScreen extends StatefulWidget {
  final Widget nextScreen;

  const ProAccessScreen({super.key, required this.nextScreen});

  @override
  State<ProAccessScreen> createState() => _ProAccessScreenState();
}

class _ProAccessScreenState extends State<ProAccessScreen> {
  late final PageController _pageController;
  late final Timer _timer;

  int _index = 0;

  final List<String> _images = const [
    'assets/in_app/in_appone.png',
    'assets/in_app/in_apptwo.png',
    'assets/in_app/in_appthree.png',
    'assets/in_app/in_appfour.png',
    'assets/in_app/in_appfive.png',
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;

      _index = (_index + 1) % _images.length;

      _pageController.animateToPage(
        _index,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => widget.nextScreen));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            // Increase image height by ~10% for stronger background presence.
            final imageHeight = screenHeight * 0.68;

            final bottomReservedHeight = screenHeight * 0.16;
            final headerTopOffset = screenHeight * 0.320;

            // Gradient should start fading exactly where the text starts.
            final fadeStartFraction = headerTopOffset / screenHeight;
            final fadeMidFraction = (fadeStartFraction + 0.18).clamp(
              fadeStartFraction,
              0.75,
            );

            return Stack(
              children: [
                /// TOP IMAGE SLIDER
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _images.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Image.asset(
                          _images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Container(color: AppColors.darkBackground);
                          },
                        );
                      },
                    ),
                  ),
                ),

                /// GRADIENT OVERLAY
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x00000000),
                          Color(0x00000000),
                          Color(0x99000000),
                          Color(0xE6000000),
                          Color(0xFF000000),
                        ],
                        stops: [
                          0.0,
                          fadeStartFraction,
                          fadeMidFraction,
                          0.60,
                          1.0,
                        ],
                      ),
                    ),
                  ),
                ),

                /// CLOSE BUTTON
                Positioned(
                  top: 12.h,
                  left: 14.w,
                  child: IconButton(
                    onPressed: _goNext,
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textWhite,
                      size: 28.sp,
                    ),
                  ),
                ),

                /// MAIN CONTENT
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      20.w,
                      0,
                      20.w,
                      bottomReservedHeight,
                    ),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: headerTopOffset),

                          /// TITLE (single line: Get [PRO] Access)
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Get',
                                  style: TextStyle(
                                    fontSize: 46.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textWhite,
                                    fontFamily: 'Antonio',
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.darkPrimary,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    'PRO',
                                    style: TextStyle(
                                      fontSize: 46.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textWhite,
                                      fontFamily: 'Antonio',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Text(
                                  'Access',
                                  style: TextStyle(
                                    fontSize: 46.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textWhite,
                                    fontFamily: 'Antonio',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 8.h),

                          Text(
                            'Unleash your creativity with PRO',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textWhite,
                              fontFamily: 'Antonio',
                            ),
                          ),

                          SizedBox(height: 22.h),

                          _FeatureRow(text: 'Unlimited tattoo creation'),
                          _FeatureRow(text: 'Fast processing'),
                          _FeatureRow(text: 'Unlock all styles'),
                          _FeatureRow(text: 'Remove watermarks'),

                          SizedBox(height: 18.h),

                          _PlanCard(
                            variant: PlanVariant.freeTrial,
                            leftText: 'Free Trial',
                          ),

                          SizedBox(height: 10.h),

                          _PlanCard(
                            variant: PlanVariant.weekly,
                            leftText: 'WEEKLY',
                            rightText: 'Rs 1960/week',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// BOTTOM CTA
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 1, 20.w, 10.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Auto-renewable, Cancel anytime',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textGrey.withOpacity(0.85),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          width: double.infinity,
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: _goNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'CONTINUE',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textWhite,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.textWhite,
                                  size: 22.sp,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 6.h),

                        Text(
                          'After 3 days free - then yearly subscription for Rs 6,900 will start. Cancel anytime 24 hours before renewal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textGrey.withOpacity(0.85),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

enum PlanVariant { freeTrial, weekly }

class _PlanCard extends StatelessWidget {
  final PlanVariant variant;
  final String leftText;
  final String? rightText;

  const _PlanCard({
    required this.variant,
    required this.leftText,
    this.rightText,
  });

  @override
  Widget build(BuildContext context) {
    final isFree = variant == PlanVariant.freeTrial;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: isFree
            ? AppColors.darkBackground.withOpacity(0.01)
            : AppColors.navBarBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: isFree
            ? Border.all(color: AppColors.darkPrimary, width: 1.5.w)
            : Border.all(color: AppColors.navBarBackground),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              leftText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isFree ? AppColors.darkPrimary : AppColors.textWhite,
              ),
            ),
          ),
          if (rightText != null)
            Flexible(
              child: Text(
                rightText!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGrey.withOpacity(0.95),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;

  const _FeatureRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final rowWidth = constraints.maxWidth * 0.55;

          return SizedBox(
            width: rowWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: AppColors.darkPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 14.sp,
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textWhite,
                      fontFamily: 'Antonio',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
