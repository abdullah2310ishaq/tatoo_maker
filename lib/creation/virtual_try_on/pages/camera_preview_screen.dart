import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewScreen extends StatefulWidget {
  final CameraController cameraController;

  const CameraPreviewScreen({super.key, required this.cameraController});

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  File? _capturedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview or captured image
          if (_capturedImage != null)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.file(_capturedImage!, fit: BoxFit.cover),
            )
          else
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: AspectRatio(
                  aspectRatio: widget.cameraController.value.aspectRatio,
                  child: CameraPreview(widget.cameraController),
                ),
              ),
            ),
          // Close button (top left)
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Bottom buttons: Tick/Cross if captured, Capture button if not
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: _capturedImage != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Cross button - retake
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _capturedImage = null;
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.withValues(alpha: 0.8),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Tick button - confirm
                      GestureDetector(
                        onTap: () {
                          if (_capturedImage != null) {
                            Navigator.pop(context, _capturedImage);
                          }
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.withValues(alpha: 0.8),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: GestureDetector(
                      onTap: _capturePhoto,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: const Icon(
                          Icons.camera,
                          color: Colors.black,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _capturePhoto() async {
    try {
      final XFile image = await widget.cameraController.takePicture();
      if (!mounted) return;
      setState(() {
        _capturedImage = File(image.path);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error capturing photo: $e')));
    }
  }
}
