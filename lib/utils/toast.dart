import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';

/// Global toast utility for showing success/error messages
/// Supports both light and dark themes
class AppToast {
  static OverlayEntry? _currentOverlayEntry;

  /// Show a toast message
  ///
  /// [message] - The message to display
  /// [isSuccess] - true for success (green), false for error (orange)
  /// [duration] - How long the toast should be visible
  static void show(
    BuildContext context, {
    required String message,
    bool isSuccess = true,
    Duration duration = const Duration(seconds: 2),
  }) {
    // Remove previous toast if exists (prevent stacking)
    if (_currentOverlayEntry != null) {
      try {
        if (_currentOverlayEntry!.mounted) {
          _currentOverlayEntry!.remove();
        }
      } catch (e) {
        // Ignore errors if overlay is already removed
      }
      _currentOverlayEntry = null;
    }

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) =>
          _AppToastWidget(message: message, isSuccess: isSuccess),
    );

    _currentOverlayEntry = overlayEntry;
    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      try {
        if (overlayEntry.mounted) {
          overlayEntry.remove();
        }
        if (_currentOverlayEntry == overlayEntry) {
          _currentOverlayEntry = null;
        }
      } catch (e) {
        // Ignore errors if overlay is already removed
        _currentOverlayEntry = null;
      }
    });
  }
}

class _AppToastWidget extends StatelessWidget {
  final String message;
  final bool isSuccess;

  const _AppToastWidget({required this.message, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme-based colors
    // Light theme: white background with orange accent
    // Dark theme: black background with orange accent
    final backgroundColor = isDark
        ? AppColors
              .darkBackground // Black for dark theme
        : AppColors.lightBackground; // White for light theme

    final textColor = isDark
        ? AppColors
              .textWhite // White text for dark theme
        : AppColors.textPrimary; // Dark text for light theme

    final accentColor = isSuccess
        ? const Color(0xFF2E7D32) // Green for success
        : AppColors.lightPrimary; // Orange for error/warning

    return Stack(
      children: [
        Positioned(
          bottom: 90.h, // Higher position above navbar
          left: 0,
          right: 0,
          child: SafeArea(
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 1.sw - 32.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: accentColor, width: 1.5.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8.r,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          message,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Amaranth',
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSuccess) ...[
                        SizedBox(width: 6.w),
                        Text('🔥', style: TextStyle(fontSize: 16.sp)),
                      ] else ...[
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.warning_rounded,
                          color: accentColor,
                          size: 16.sp,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
