import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagePreviewScreen extends StatefulWidget {
  final File imageFile;

  const ImagePreviewScreen({super.key, required this.imageFile});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  void initState() {
    super.initState();
    _setSystemUIOverlay();
  }

  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          // Image preview
          Positioned.fill(
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.white70,
                    size: 64.sp,
                  ),
                );
              },
            ),
          ),
          // Close button (safe-area aware)
          Positioned(
            top: padding.top + 8.h,
            left: 16.w,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 32.sp),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Bottom buttons: Cross and Tick (safe-area aware)
          Positioned(
            bottom: padding.bottom + 32.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cross button - cancel
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withValues(alpha: 0.8),
                      border: Border.all(color: Colors.white, width: 3.w),
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 30.sp),
                  ),
                ),
                SizedBox(width: 40.w),
                // Tick button - confirm
                GestureDetector(
                  onTap: () => Navigator.pop(context, widget.imageFile),
                  child: Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withValues(alpha: 0.8),
                      border: Border.all(color: Colors.white, width: 3.w),
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 30.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
