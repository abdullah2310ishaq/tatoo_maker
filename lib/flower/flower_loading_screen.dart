import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/usage_limit_provider.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../utils/toast.dart';
import '../utils/image_processing_isolates.dart';
import '../services/prodia_api_service.dart';
import '../services/history_service.dart';
import 'flower_result_screen.dart';

/// Loading screen for generating floral tattoo based on name
class FlowerLoadingScreen extends StatefulWidget {
  final String name;

  const FlowerLoadingScreen({super.key, required this.name});

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

    // Start API call
    _generateFloralTattoo();
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
          'intricate floral patterns, beautiful typography integrated with nature';

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
    if (_generatedImageBytes != null) {
      await context.read<UsageLimitProvider>().recordGenerationSuccess();
      HistoryService.addFlowerEntry(
        name: widget.name,
        imageBytes: _generatedImageBytes!,
      );
    }
    // Ads removed from this flow for now.
    if (mounted) {
      debugPrint('[FlowerLoadingScreen] step 3/3: opening FlowerResultScreen');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => FlowerResultScreen(
            name: widget.name,
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

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Container(
        decoration: isDark
            ? ThemeManager.darkModeBackgroundGradient
            : ThemeManager.lightModeBackground,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return CircularProgressIndicator(
                      value: _progressAnimation.value,
                      strokeWidth: 4,
                      color: AppColors.titleGradientStart,
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.flowerLoadingCreatingYourFloralTattoo,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textWhite : AppColors.textPrimary,
                    fontFamily: 'Amaranth',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.flowerLoadingDesigningWithBeautifulFlowers(widget.name),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textGrey
                        : AppColors.textGrey.withOpacity(0.7),
                    fontFamily: 'Amaranth',
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
