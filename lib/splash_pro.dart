import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'utils/colors.dart';
import 'pro_access_screen.dart';

class SplashProScreen extends StatefulWidget {
  const SplashProScreen({super.key, required this.nextScreen});

  final Widget nextScreen;

  @override
  State<SplashProScreen> createState() => _SplashProScreenState();
}

class _SplashProScreenState extends State<SplashProScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late final AnimationController _controller;

  void _goToPaywall() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ProAccessScreen(
          nextScreen: widget.nextScreen,
          forceTrialEnabled: true,
          lockTrialToggle: false,
          alwaysShowTrialToggle: true,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..forward();

    _timer = Timer(const Duration(seconds: 3), _goToPaywall);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        // Treat Android back as "skip" to paywall for this one-time splash.
        _goToPaywall();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          body: Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 240.w,
                        height: 100.w,
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, _) {
                            final t = Curves.easeInOut.transform(
                              _controller.value.clamp(0.0, 1.0),
                            );

                            // Toggle track colors (OFF -> ON)
                            final offTrack = isDark
                                ? AppColors.navBarBackground.withValues(
                                    alpha: 0.65,
                                  )
                                : AppColors.textGrey.withValues(alpha: 0.35);
                            final onTrack = AppColors.darkPrimary;
                            final trackColor = Color.lerp(
                              offTrack,
                              onTrack,
                              t,
                            )!;

                            // Knob travel
                            final knobLeft = 6.w + (t * (84.w - 6.w));

                            return Stack(
                              children: [
                                // Center toggle
                                Center(
                                  child: Container(
                                    width: 142.w,
                                    height: 66.w,
                                    padding: EdgeInsets.all(6.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(999),
                                      color: trackColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.toastShadow
                                              .withValues(alpha: 0.28),
                                          blurRadius: 14,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: AppColors.darkPrimary.withValues(
                                          alpha: 0.22,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: knobLeft,
                                          top: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 44.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.textWhite,
                                            ),
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

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Trial Enabled!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 50.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkPrimary,
                              fontFamily: 'Antonio',
                              height: 1.0,
                            ),
                          ),
                          SizedBox(height: 20.h),
        
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                left: 8.w,
                child: SafeArea(
                  bottom: false,
                  child: IconButton(
                    onPressed: _goToPaywall,
                    icon: Icon(
                      Icons.close,
                      color: isDark
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
