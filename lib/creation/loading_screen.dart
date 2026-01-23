import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import 'result_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String?
  selectedStyleAsset; // Asset path for the selected style (e.g., 'assets/unicorn.png')
  final String? styleName; // Name of the selected style (e.g., 'Unicorn')

  const LoadingScreen({
    super.key,
    this.selectedStyleAsset,
    this.styleName,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );

    // Navigate to result screen after 3 seconds
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              styleName: widget.styleName ?? 'Tattoo',
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final assetPath = widget.selectedStyleAsset ?? 'assets/unicorn.png';

    return SafeArea(
      child: Container(
        decoration: isDark
            ? ThemeManager.darkModeBackgroundGradient
            : ThemeManager.lightModeBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Centered unicorn/selected style asset
            Expanded(
              flex: 3,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.buttonBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.image_not_supported,
                          color: AppColors.textGrey,
                          size: 48,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // Text with underline and progress bar
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // "Generating your tattoo.." text
                  Text(
                    'Generating your tattoo..',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                      fontFamily: 'Amaranth',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Animated progress bar with moving effect (sized to match text)
                  SizedBox(
                    width:
                        178, // Approximate width of "Generating your tattoo.." text
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            // Calculate position for moving bar (left to right and back)
                            final barWidth = 80.0;
                            final maxPosition = constraints.maxWidth - barWidth;
                            final position =
                                _progressAnimation.value * maxPosition;

                            return Container(
                              height: 2,
                              decoration: BoxDecoration(
                                color: AppColors.textGrey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(1),
                              ),
                              child: Stack(
                                children: [
                                  // Moving orange bar
                                  Positioned(
                                    left: position,
                                    child: Container(
                                      width: barWidth,
                                      height: 2,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.cardGlowStart.withOpacity(
                                              0.0,
                                            ),
                                            AppColors.cardGlowStart,
                                            AppColors.cardGlowStart.withOpacity(
                                              0.0,
                                            ),
                                          ],
                                          stops: const [0.0, 0.5, 1.0],
                                        ),
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
