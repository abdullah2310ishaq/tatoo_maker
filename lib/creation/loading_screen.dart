import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../utils/image_processing_isolates.dart';
import '../services/prodia_api_service.dart';
import '../services/history_service.dart';
import '../l10n/app_localizations.dart';
import 'result_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String?
  selectedStyleAsset; // Asset path for the selected style (e.g., 'assets/unicorn.png')
  final String? styleName; // Name of the selected style (e.g., 'Unicorn')
  final String? promptText; // The text prompt for image generation
  final String? name; // User's name for tattoo generation

  const LoadingScreen({
    super.key,
    this.selectedStyleAsset,
    this.styleName,
    this.promptText,
    this.name,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  Timer? _navigationTimer;
  Uint8List? _generatedImageBytes;
  final ProdiaApiService _apiService = ProdiaApiService();

  @override
  void initState() {
    super.initState();
    print('LoadingScreen: Initializing...');
    print('LoadingScreen: Name: ${widget.name}');
    print('LoadingScreen: Style Name: ${widget.styleName}');
    print('LoadingScreen: Prompt Text: ${widget.promptText}');

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );

    // Start API call
    _generateImage();
  }

  Future<void> _generateImage() async {
    // Construct prompt from name, style, and tattoo idea
    final name = widget.name?.trim() ?? '';
    final style = widget.styleName?.trim() ?? '';
    final idea = widget.promptText?.trim() ?? '';

    if (name.isEmpty && idea.isEmpty) {
      print(
        'LoadingScreen: No name or prompt text provided, using placeholder',
      );
      // Navigate after 3 seconds even without prompt
      _navigationTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          _navigateToResult();
        }
      });
      return;
    }

    // Build comprehensive prompt combining name, style, and idea
    final List<String> promptParts = [];

    if (name.isNotEmpty) {
      promptParts.add('tattoo design with "$name"');
    }

    if (style.isNotEmpty) {
      promptParts.add('in ${style.toLowerCase()} style');
    }

    if (idea.isNotEmpty) {
      promptParts.add(idea);
    }

    // Add style descriptors
    promptParts.add(
      'tattoo design, black and white, line art, minimalist, intricate details',
    );

    final finalPrompt = promptParts.join(', ');

    print('LoadingScreen: Starting image generation...');
    print('LoadingScreen: Name: $name');
    print('LoadingScreen: Style: $style');
    print('LoadingScreen: Idea: $idea');
    print('LoadingScreen: Final Prompt: $finalPrompt');

    try {
      final imageBytes = await _apiService.textToImage(
        prompt: finalPrompt,
        width: 1024,
        height: 1024,
        steps: 4,
      );

      print('LoadingScreen: Image generated successfully');
      print('LoadingScreen: Image size: ${imageBytes.length} bytes');

      // Save image to temp file for background removal
      final tempDir = await getTemporaryDirectory();
      final tempImageFile = File(
        '${tempDir.path}/generated_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await tempImageFile.writeAsBytes(imageBytes);
      print('LoadingScreen: Saved image to temp file: ${tempImageFile.path}');

      // Mask background using Prodia API (matches provided CURL, JPEG output)
      // Then refine in an isolate to produce a PNG with proper alpha.
      Uint8List finalImageBytes =
          imageBytes; // Fallback to original if removal fails
      try {
        print('LoadingScreen: Starting background mask...');
        final maskedImage = await _apiService.maskBackground(
          imageFile: tempImageFile,
        );
        print('LoadingScreen: Background mask successful!');
        print('LoadingScreen: Masked image size: ${maskedImage.length} bytes');

        // Run heavy pixel work off the UI thread.
        final alphaApplied = await compute(applyAlphaMaskToImageIsolate, {
          'inputImageBytes': imageBytes,
          'maskBytes': maskedImage,
        });
        print(
          'LoadingScreen: Alpha-applied image size: ${alphaApplied.length} bytes',
        );
        finalImageBytes = alphaApplied;
      } catch (e) {
        print('LoadingScreen: Background mask/alpha processing failed: $e');
        print('LoadingScreen: Using original image without background mask');
        // Continue with original image
      }

      // Clean up temp file
      try {
        await tempImageFile.delete();
        print('LoadingScreen: Temp file deleted');
      } catch (e) {
        print('LoadingScreen: Error deleting temp file: $e');
      }

      // Ensure minimum 3 seconds wait time
      final startTime = DateTime.now();
      final elapsed = DateTime.now().difference(startTime);
      final remainingTime = 3 - elapsed.inSeconds;

      if (remainingTime > 0) {
        print('LoadingScreen: Waiting $remainingTime more seconds...');
        await Future.delayed(Duration(seconds: remainingTime));
      }

      if (mounted) {
        setState(() {
          _generatedImageBytes = finalImageBytes;
        });
        print(
          'LoadingScreen: Final image ready, size: ${finalImageBytes.length} bytes',
        );
        print('LoadingScreen: Navigating to result screen...');
        _navigateToResult();
      }
    } catch (e) {
      print('LoadingScreen: Error generating image: $e');
      // Still navigate after 3 seconds even on error
      _navigationTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          _navigateToResult();
        }
      });
    }
  }

  void _navigateToResult() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final styleName = widget.styleName ?? l10n.genericTattoo;
    if (_generatedImageBytes != null) {
      final name = widget.name?.trim() ?? '';
      if (name.isNotEmpty) {
        HistoryService.addTattooEntry(
          styleName: styleName,
          promptText: widget.promptText,
          name: name,
          imageBytes: _generatedImageBytes!,
        );
      } else {
        HistoryService.addCreationEntry(
          styleName: styleName,
          promptText: widget.promptText,
          imageBytes: _generatedImageBytes!,
        );
      }
    }
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            styleName: styleName,
            generatedImageBytes: _generatedImageBytes,
          ),
        ),
      );
    }
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
    final l10n = AppLocalizations.of(context)!;
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
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: AppColors.buttonBackground,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          color: AppColors.textGrey,
                          size: 48.sp,
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
                    l10n.loadingGeneratingYourTattoo,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                      fontFamily: 'Amaranth',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  // Animated progress bar with moving effect (sized to match text)
                  SizedBox(
                    width: 178
                        .w, // Approximate width of "Generating your tattoo.." text
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            // Calculate position for moving bar (left to right and back)
                            final barWidth = 80.w;
                            final maxPosition = constraints.maxWidth - barWidth;
                            final position =
                                _progressAnimation.value * maxPosition;

                            return Container(
                              height: 2.h,
                              decoration: BoxDecoration(
                                color: AppColors.textGrey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(1.r),
                              ),
                              child: Stack(
                                children: [
                                  // Moving orange bar
                                  Positioned(
                                    left: position,
                                    child: Container(
                                      width: barWidth,
                                      height: 2.h,
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
                                        borderRadius: BorderRadius.circular(
                                          1.r,
                                        ),
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
