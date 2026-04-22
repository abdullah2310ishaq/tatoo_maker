import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/usage_limit_provider.dart';
import '../services/admob_ids.dart';
import '../services/remote_config_service.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../utils/toast.dart';
import '../utils/image_processing_isolates.dart';
import '../services/prodia_api_service.dart';
import '../services/history_service.dart';
import '../widgets/creative_loading_spinner.dart';
import '../widgets/interstitial_ad_loading_dialog.dart';
import 'flower_result_screen.dart';

enum FlowerLoadingMode {
  generate,
  lockedForFreeUser,
}

/// Loading screen for generating floral tattoo based on name
class FlowerLoadingScreen extends StatefulWidget {
  final String name;
  final bool showInterstitialAfterGeneration;
  final FlowerLoadingMode mode;

  const FlowerLoadingScreen({
    super.key,
    required this.name,
    this.showInterstitialAfterGeneration = true,
    this.mode = FlowerLoadingMode.generate,
  });

  const FlowerLoadingScreen.withInterstitialControl({
    super.key,
    required this.name,
    required this.showInterstitialAfterGeneration,
    this.mode = FlowerLoadingMode.generate,
  });

  @override
  State<FlowerLoadingScreen> createState() => _FlowerLoadingScreenState();
}

class _FlowerLoadingScreenState extends State<FlowerLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  Timer? _navigationTimer;
  Uint8List? _generatedImageBytes;
  final ProdiaApiService _apiService = ProdiaApiService();
  bool _isShowingInterstitial = false;

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

    // Start flow
    final isPro = context.read<UsageLimitProvider>().isProUnlocked;
    final shouldLock = !isPro || widget.mode == FlowerLoadingMode.lockedForFreeUser;
    if (shouldLock) {
      unawaited(_runLockedFreeUserFlow());
    } else {
      _generateFloralTattoo();
    }
  }

  Future<void> _runLockedFreeUserFlow() async {
    // Keep the spinner visible briefly so the screen feels consistent.
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    if (widget.showInterstitialAfterGeneration) {
      await _showInterstitialAdIfAvailable(
        unitIdOverride: AdmobIds.interstitialUnitId(),
      );
    }
    if (!mounted) return;

    await _navigateToResult();
  }

  Future<void> _generateFloralTattoo() async {
    if (widget.name.isEmpty) {
      _navigationTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          unawaited(_navigateToResult());
        }
      });
      return;
    }

    print('FlowerLoadingScreen: Starting floral tattoo generation...');
    print('FlowerLoadingScreen: Name: ${widget.name}');

    try {
      // Prompt based on person's name and florals (one per letter in the name)
      final letters = widget.name.toUpperCase().split('');
      final lettersDesc = letters.join(', ');
      final prompt =
          'floral tattoo design based on the person\'s name "${widget.name}" '
          'and the florals for each letter ($lettersDesc), '
          'elegant calligraphy, botanical illustration, delicate flowers and leaves, '
          'line art style, black and white, minimalist tattoo design, '
          'intricate floral patterns, beautiful typography integrated with nature, '
          // Keep artwork isolated, clean, and never printed on skin.
          'clean standalone tattoo flash artwork, centered composition, white paper background, '
          '2d illustration only, isolated design, no mockup, no photo, '
          // Strict body-part exclusion instructions (no negative prompt support).
          'STRICTLY NO human body parts, no skin, no person, no portrait, no tattooed body photo';

      final imageBytes = await _apiService.textToImage(
        prompt: prompt,
        width: 1024,
        height: 1024,
        steps: 4,
      );

      print('FlowerLoadingScreen: Image generated successfully');
      print('FlowerLoadingScreen: Image size: ${imageBytes.length} bytes');

      // Save image to temp file for background removal
      final tempDir = await getTemporaryDirectory();
      final tempImageFile = File(
        '${tempDir.path}/floral_generated_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await tempImageFile.writeAsBytes(imageBytes);
      print(
        'FlowerLoadingScreen: Saved image to temp file: ${tempImageFile.path}',
      );

      // Mask background and refine alpha for transparent output.
      Uint8List finalImageBytes =
          imageBytes; // Fallback to original if masking fails
      try {
        print('FlowerLoadingScreen: Starting background mask...');
        final maskedImage = await _apiService.maskBackground(
          imageFile: tempImageFile,
        );
        print('FlowerLoadingScreen: Background mask successful!');
        print(
          'FlowerLoadingScreen: Masked image size: ${maskedImage.length} bytes',
        );

        final alphaApplied = await compute(applyAlphaMaskToImageIsolate, {
          'inputImageBytes': imageBytes,
          'maskBytes': maskedImage,
        });
        print(
          'FlowerLoadingScreen: Alpha-applied image size: ${alphaApplied.length} bytes',
        );
        finalImageBytes = alphaApplied;
      } catch (e) {
        print(
          'FlowerLoadingScreen: Background mask/alpha processing failed: $e',
        );
        print(
          'FlowerLoadingScreen: Using original image without background mask',
        );
      }

      // Clean up temp file
      try {
        await tempImageFile.delete();
        print('FlowerLoadingScreen: Temp file deleted');
      } catch (e) {
        print('FlowerLoadingScreen: Error deleting temp file: $e');
      }

      if (mounted) {
        setState(() {
          _generatedImageBytes = finalImageBytes;
        });
        print(
          'FlowerLoadingScreen: Final image ready, size: ${finalImageBytes.length} bytes',
        );
        print('FlowerLoadingScreen: Navigating to result screen...');
        await _navigateToResult();
      }
    } catch (e) {
      print('FlowerLoadingScreen: Error generating floral tattoo: $e');
      if (mounted) {
        final isNetworkError =
            e is SocketException ||
            e.toString().contains('SocketException') ||
            e.toString().contains('host lookup') ||
            e.toString().contains('Failed host lookup');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final l10n = AppLocalizations.of(context)!;
          AppToast.show(
            context,
            message: isNetworkError
                ? l10n.noInternetConnectionPleaseCheckNetwork
                : 'Error generating. Try again after sometime.',
            isSuccess: false,
            duration: const Duration(seconds: 3),
          );
        });
        // Navigate immediately on error: show fallback ResultScreen without ads/paywall.
        await _navigateToResult();
      }
    }
  }

  Future<void> _navigateToResult() async {
    if (!mounted) return;
    debugPrint(
      '[FlowerLoadingScreen] generation finished -> preparing result navigation '
      '(hasImage=${_generatedImageBytes != null})',
    );
    if (widget.mode == FlowerLoadingMode.generate &&
        _generatedImageBytes != null) {
      await context.read<UsageLimitProvider>().recordGenerationSuccess();
      HistoryService.addFlowerEntry(
        name: widget.name,
        imageBytes: _generatedImageBytes!,
      );
    }

    // Show only an interstitial (no paywall) when enabled in Remote Config.
    if (_generatedImageBytes != null &&
        widget.showInterstitialAfterGeneration) {
      await _maybeShowInterstitialAfterGeneration();
    }

    if (mounted) {
      debugPrint('[FlowerLoadingScreen] step 3/3: opening FlowerResultScreen');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => FlowerResultScreen(
            name: widget.name,
            generatedImageBytes: _generatedImageBytes,
            showProAccessOnOpen: false,
            enablePaywallPrompts: true,
          ),
        ),
      );
    }
  }

  Future<void> _maybeShowInterstitialAfterGeneration() async {
    if (!mounted) return;
    if (_isShowingInterstitial) return;

    final rc = context.read<RemoteConfigService>();
    final isPro = context.read<UsageLimitProvider>().isProUnlocked;
    if (isPro || !rc.flowerShowInterstitialAfterGeneration) return;

    _isShowingInterstitial = true;
    try {
      await _showInterstitialAdIfAvailable(
        unitIdOverride: AdmobIds.interstitialUnitId(),
      );
    } finally {
      _isShowingInterstitial = false;
    }
  }

  Future<void> _showInterstitialAdIfAvailable({String? unitIdOverride}) async {
    final unitId = (unitIdOverride ?? '').trim();
    if (unitId.isEmpty) return;

    final completer = Completer<void>();
    InterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) async {
          final loadingHandle = await showInterstitialAdLoadingDialog(context);
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              loadingHandle.close();
              if (!completer.isCompleted) completer.complete();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              loadingHandle.close();
              if (!completer.isCompleted) completer.complete();
            },
          );
          try {
            await Future<void>.delayed(const Duration(milliseconds: 150));
            ad.show();
          } catch (_) {
            ad.dispose();
            loadingHandle.close();
            if (!completer.isCompleted) completer.complete();
          }
        },
        onAdFailedToLoad: (error) {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    try {
      await completer.future.timeout(const Duration(seconds: 5));
    } catch (_) {
      // Never block navigation forever.
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
            Expanded(
              flex: 3,
              child: Center(child: const CreativeLoadingSpinner()),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.flowerLoadingCreatingYourFloralTattoo,
                    textAlign: TextAlign.center,
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
                  SizedBox(height: 6.h),
                  Text(
                    l10n.flowerLoadingDesigningWithBeautifulFlowers(
                      widget.name,
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.textGrey
                          : AppColors.textGrey.withOpacity(0.7),
                      fontFamily: 'Amaranth',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: 178.w,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
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
