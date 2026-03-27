import 'dart:async';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../utils/toast.dart';
import '../utils/image_processing_isolates.dart';
import '../services/prodia_api_service.dart';
import '../services/history_service.dart';
import '../l10n/app_localizations.dart';
import 'result_screen.dart';
import '../widgets/creative_loading_spinner.dart';

class LoadingScreen extends StatefulWidget {
  final String?
  selectedStyleAsset; // Asset path for the selected style (e.g., 'assets/unicorn.png')
  final String? styleName; // Name of the selected style (e.g., 'Unicorn')
  final String? promptText; // The text prompt for image generation
  final String? name; // User's name for tattoo generation

  /// Tattoo module only: date of birth (e.g. "January 4, 2000")
  final String? dobFormatted;

  /// Tattoo module only: zodiac/star sign (e.g. "Capricorn")
  final String? zodiacSign;

  /// Tattoo module only: place of birth
  final String? placeOfBirth;

  const LoadingScreen({
    super.key,
    this.selectedStyleAsset,
    this.styleName,
    this.promptText,
    this.name,
    this.dobFormatted,
    this.zodiacSign,
    this.placeOfBirth,
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
    final name = widget.name?.trim() ?? '';
    final style = widget.styleName?.trim() ?? '';
    final idea = widget.promptText?.trim() ?? '';
    final dob = widget.dobFormatted?.trim() ?? '';
    final zodiac = widget.zodiacSign?.trim() ?? '';
    final place = widget.placeOfBirth?.trim() ?? '';

    final isTattooModule =
        dob.isNotEmpty || zodiac.isNotEmpty || place.isNotEmpty;

    if (name.isEmpty && idea.isEmpty && !isTattooModule) {
      print(
        'LoadingScreen: No name or prompt text provided, using placeholder',
      );
      _navigationTimer = Timer(const Duration(seconds: 5000), () {
        if (mounted) _navigateToResult();
      });
      return;
    }

    final List<String> promptParts = [];

    if (isTattooModule) {
      // Tattoo module: tattoo based on name, DOB, star, place of birth, and idea. Style = inspiration only.
      if (idea.isNotEmpty) {
        promptParts.add('$idea, tattoo design');
      } else {
        promptParts.add('personalized tattoo design');
      }
      if (name.isNotEmpty) {
        promptParts.add('for the name "$name"');
      }
      if (dob.isNotEmpty) {
        promptParts.add('date of birth $dob');
      }
      if (zodiac.isNotEmpty) {
        promptParts.add('zodiac star sign $zodiac');
      }
      if (place.isNotEmpty) {
        promptParts.add('place of birth $place');
      }
      if (style.isNotEmpty) {
        promptParts.add(
          'inspired by ${style.toLowerCase()} style, aesthetic only',
        );
      }
    } else {
      // Creation / other: user idea = main subject, style = inspiration only
      if (idea.isNotEmpty) {
        promptParts.add('$idea, tattoo design');
      } else {
        promptParts.add('tattoo design');
      }
      if (name.isNotEmpty) {
        promptParts.add('incorporating the name "$name"');
      }
      if (style.isNotEmpty) {
        promptParts.add(
          'inspired by ${style.toLowerCase()} style, aesthetic only',
        );
        // Dragon: reinforce Eastern fiery dragon aesthetic when user provided a subject
        if (style.toLowerCase() == 'dragon' && idea.isNotEmpty) {
          promptParts.add(
            'incorporate subject with fiery dragon-like details, scales, sharp fierce lines, dramatic shading, flowing powerful design, as if breathing fire, mythical elements, bold red orange gold, Eastern-inspired',
          );
        }
        // Unicorn: reinforce pastel magical whimsical aesthetic when user provided a subject
        if (style.toLowerCase() == 'unicorn' && idea.isNotEmpty) {
          promptParts.add(
            'incorporate subject with soft flowing lines, magical accents stars sparkles, graceful gentle curves, whimsical highlights, ethereal magical quality, pastel pinks blues purples silvers, lightness and enchantment, fantasy and dreams',
          );
        }
        // Floral: reinforce delicate organic floral aesthetic when user provided a subject
        if (style.toLowerCase() == 'floral' && idea.isNotEmpty) {
          promptParts.add(
            'incorporate subject with soft floral details, delicate petals and leaves subtly woven in, flowing graceful curves, muted natural blush pink soft white earthy green, gentle shading, realistic textures, elegant organic serenity, light highlights',
          );
        }
      }
    }

    // Global style: force the model to produce a clean standalone tattoo
    // flash/stencil artwork — NOT ink on a real body.
    promptParts.add(
      'clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, '
      'black and white, line art, minimalist, intricate details, standalone tattoo design, '
      'white background, high contrast, 2d only, flat design, isolated artwork',
    );

    // Strict body-part exclusion instructions (Flux has no negative_prompt
    // param, so these must live in the positive prompt).
    promptParts.add(
      'STRICTLY NO human body parts whatsoever: and white background',
      // 'no skin, no flesh, no human body, no arms, no legs, no hands, no fingers, no feet, '
      // 'no torso, no back, no chest, no shoulder, no neck, no face, no head, no ears, no lips, '
      // 'no eyes, no nails, no veins, no body hair, no tattoo studio, no tattoo machine, '
      // 'no person, no people, no model, no portrait photo, no photograph of body, '
      // 'no real skin texture, no wrist, no ankle, no elbow, no muscle, no anatomy',
    );

    final finalPrompt = promptParts.join(', ');

    print('LoadingScreen: Starting image generation...');
    print('LoadingScreen: Name: $name');
    print('LoadingScreen: Style: $style');
    print('LoadingScreen: Idea: $idea');
    if (isTattooModule) {
      print('LoadingScreen: DOB: $dob');
      print('LoadingScreen: Zodiac: $zodiac');
      print('LoadingScreen: Place: $place');
    }
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

      // Mask background and refine alpha for transparent output.
      Uint8List finalImageBytes =
          imageBytes; // Fallback to original if masking fails
      try {
        print('LoadingScreen: Starting background mask...');
        final maskedImage = await _apiService.maskBackground(
          imageFile: tempImageFile,
        );
        print('LoadingScreen: Background mask successful!');
        print('LoadingScreen: Masked image size: ${maskedImage.length} bytes');

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

      // If this looks like a connectivity issue (no host / no internet),
      // show a clear toast. Covers SocketException and ClientException wrapping it.
      final isNetworkError =
          e is SocketException ||
          e.toString().contains('SocketException') ||
          e.toString().contains('host lookup') ||
          e.toString().contains('Failed host lookup');
      if (mounted && isNetworkError) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final l10n = AppLocalizations.of(context)!;
          AppToast.show(
            context,
            message: l10n.noInternetConnectionPleaseCheckNetwork,
            isSuccess: false,
            duration: const Duration(seconds: 3),
          );
        });
      }

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
    // Use key 'generic' when no style so history/result can show localized title
    final styleName = widget.styleName ?? 'generic';
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
            promptText: widget.promptText,
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

    return SafeArea(
      child: Container(
        decoration: isDark
            ? ThemeManager.darkModeBackgroundGradient
            : ThemeManager.lightModeBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Centered creative spinner
            // Centered creative spinner
            Expanded(
              flex: 3,
              child: Center(child: const CreativeLoadingSpinner()),
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
