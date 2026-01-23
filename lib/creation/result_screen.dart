import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cross_file/cross_file.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import 'virtual_try_on.dart';

class ResultScreen extends StatelessWidget {
  final String styleName;
  final Uint8List? generatedImageBytes;
  final List<Uint8List>? variationImages;

  const ResultScreen({
    super.key,
    required this.styleName,
    this.generatedImageBytes,
    this.variationImages,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Container(
          decoration: isDark
              ? ThemeManager.darkModeBackgroundGradient
              : ThemeManager.lightModeBackground,
          child: Column(
            children: [
              // Header: Close button + Title
              _buildHeader(context, isDark),
              // Main image display - only one big image in center
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: _buildMainImage(isDark),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Action buttons
              Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: bottomPadding > 0 ? bottomPadding : 20.0,
                ),
                child: Column(
                  children: [
                    _buildVirtualTryOnButton(context, isDark),
                    const SizedBox(height: 12),
                    _buildSecondaryButtons(context, isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close button
          IconButton(
            icon: Icon(
              Icons.close,
              color: isDark ? AppColors.textWhite : AppColors.textPrimary,
              size: 28,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // Title (centered)
          Expanded(
            child: Text(
              styleName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textWhite : AppColors.textPrimary,
                fontFamily: 'Amaranth',
              ),
            ),
          ),
          // Spacer to balance the close button
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildMainImage(bool isDark) {
    if (generatedImageBytes != null) {
      // Show image directly on background (transparent background)
      return Image.memory(
        generatedImageBytes!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(isDark);
        },
      );
    }
    return _buildPlaceholder(isDark);
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.buttonBackground
            : AppColors.textGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          color: AppColors.textGrey,
          size: 64,
        ),
      ),
    );
  }

  // Commented out for now - variation carousel
  // Widget _buildVariationCarousel(bool isDark) {
  //   // For now, show placeholder thumbnails
  //   // Later, you can use variationImages if available
  //   final thumbnails = List.generate(3, (index) => index);

  //   return SizedBox(
  //     height: 120,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //       itemCount: thumbnails.length,
  //       itemBuilder: (context, index) {
  //         final isActive = index == 0;
  //         final isPro = index > 0;

  //         return Padding(
  //           padding: EdgeInsets.only(
  //             right: index < thumbnails.length - 1 ? 12 : 0,
  //           ),
  //           child: _buildThumbnail(
  //             isDark: isDark,
  //             isActive: isActive,
  //             isPro: isPro,
  //             imageBytes: index == 0 ? generatedImageBytes : null,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // Commented out - only used by variation carousel
  // Widget _buildThumbnail({
  //   required bool isDark,
  //   required bool isActive,
  //   required bool isPro,
  //   Uint8List? imageBytes,
  // }) {
  //   return GestureDetector(
  //     onTap: () {
  //       // Handle thumbnail tap - switch main image
  //     },
  //     child: Container(
  //       width: 100,
  //       height: 100,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(
  //           color: isActive
  //               ? AppColors.cardGlowStart
  //               : AppColors.textGrey.withOpacity(0.3),
  //           width: isActive ? 2 : 1,
  //         ),
  //       ),
  //       child: Stack(
  //         children: [
  //           // Image or placeholder
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(12),
  //             child: imageBytes != null
  //                 ? Image.memory(
  //                     imageBytes,
  //                     width: 100,
  //                     height: 100,
  //                     fit: BoxFit.cover,
  //                   )
  //                 : Container(
  //                     width: 100,
  //                     height: 100,
  //                     color: isDark
  //                         ? AppColors.buttonBackground
  //                         : AppColors.textGrey.withOpacity(0.1),
  //                     child: Icon(
  //                       Icons.image,
  //                       color: AppColors.textGrey,
  //                       size: 32,
  //                     ),
  //                   ),
  //           ),
  //           // Pro badge
  //           if (isPro)
  //             Positioned(
  //               top: 4,
  //               right: 4,
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 6,
  //                   vertical: 2,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: AppColors.cardGlowStart,
  //                   borderRadius: BorderRadius.circular(4),
  //                 ),
  //                 child: Text(
  //                   'Pro',
  //                   style: TextStyle(
  //                     fontSize: 10,
  //                     fontWeight: FontWeight.w700,
  //                     color: Colors.white,
  //                     fontFamily: 'Amaranth',
  //                   ),
  //                 ),
  //               ),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildVirtualTryOnButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VirtualTryOnScreen(
                tattooImageBytes: generatedImageBytes,
                styleName: styleName,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA6541D), // Burnt orange
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          'Virtual Try-On',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'Amaranth',
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButtons(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildSecondaryButton(
            label: 'Share',
            icon: Icons.share,
            isDark: isDark,
            onTap: () {
              _shareImage(context); // Direct share, no bottom sheet
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSecondaryButton(
            label: 'Download',
            icon: Icons.download,
            isDark: isDark,
            onTap: () {
              _saveImageToGallery(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.buttonBackground
              : AppColors.textGrey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.textGrey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textWhite : AppColors.textPrimary,
              fontFamily: 'Amaranth',
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _shareImage(BuildContext context) async {
    if (generatedImageBytes == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No image to share')));
      return;
    }

    try {
      // Save image to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/inkvision_${styleName}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(generatedImageBytes!);

      // Share the image file
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Check out my ${styleName} tattoo design!',
        subject: '$styleName Tattoo Design',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error sharing: $e')));
      }
    }
  }

  Future<void> _saveImageToGallery(BuildContext context) async {
    if (generatedImageBytes == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No image to save')));
      return;
    }

    try {
      await Gal.putImageBytes(
        generatedImageBytes!,
        name: 'inkvision_${styleName}_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Image saved to gallery')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving image: $e')));
      }
    }
  }
}
