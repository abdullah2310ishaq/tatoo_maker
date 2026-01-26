import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cross_file/cross_file.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../creation/virtual_try_on.dart';

/// Result screen for displaying generated floral tattoo
class FlowerResultScreen extends StatelessWidget {
  final String name;
  final Uint8List? generatedImageBytes;

  const FlowerResultScreen({
    super.key,
    required this.name,
    this.generatedImageBytes,
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
              // Main image display
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: _buildMainImage(isDark),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              // Action buttons
              Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  bottom: bottomPadding > 0 ? bottomPadding : 20.h,
                ),
                child: Column(
                  children: [
                    _buildVirtualTryOnButton(context, isDark),
                    SizedBox(height: 12.h),
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
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close button
          IconButton(
            icon: Icon(
              Icons.close,
              color: isDark ? AppColors.textWhite : AppColors.textPrimary,
              size: 28.sp,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // Title (centered) - show the name
          Expanded(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textWhite : AppColors.textPrimary,
                fontFamily: 'Amaranth',
              ),
            ),
          ),
          // Spacer to balance the close button
          SizedBox(width: 48.w),
        ],
      ),
    );
  }

  Widget _buildMainImage(bool isDark) {
    if (generatedImageBytes != null) {
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
      height: 400.h,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.buttonBackground
            : AppColors.textGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_not_supported,
              color: AppColors.textGrey,
              size: 64.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              'Floral tattoo for "$name"',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textGrey,
                fontFamily: 'Amaranth',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVirtualTryOnButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: generatedImageBytes != null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VirtualTryOnScreen(
                      tattooImageBytes: generatedImageBytes,
                      styleName: 'Floral: $name',
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA6541D), // Burnt orange
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
        ),
        child: Text(
          'Virtual Try-On',
          style: TextStyle(
            fontSize: 18.sp,
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
            onTap: () => _shareImage(context),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildSecondaryButton(
            label: 'Download',
            icon: Icons.download,
            isDark: isDark,
            onTap: () => _saveImageToGallery(context),
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
        height: 48.h,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.buttonBackground
              : AppColors.textGrey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: AppColors.textGrey.withOpacity(0.2),
            width: 1.w,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
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
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No image to share')));
      }
      return;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/floral_tattoo_${name}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(generatedImageBytes!);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Check out my floral tattoo design for "$name"!',
        subject: 'Floral Tattoo: $name',
      );
    } catch (e) {
      debugPrint('Error sharing image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Couldn\'t share image. Try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _saveImageToGallery(BuildContext context) async {
    if (generatedImageBytes == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No image to save')));
      }
      return;
    }

    try {
      await Gal.putImageBytes(
        generatedImageBytes!,
        name: 'floral_tattoo_${name}_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Image saved to gallery')));
      }
    } catch (e) {
      debugPrint('Error saving image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Couldn\'t save image. Try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
