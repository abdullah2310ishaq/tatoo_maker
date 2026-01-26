import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';

class ActionButtonsWidget extends StatelessWidget {
  final File? bodyPartImage;
  final bool isProcessing;
  final bool isSaving;
  final Uint8List? processedTryOnBytes;
  final VoidCallback onCapturePhoto;
  final VoidCallback onApply;
  final VoidCallback onSave;
  final double bottomPadding;

  const ActionButtonsWidget({
    super.key,
    required this.bodyPartImage,
    required this.isProcessing,
    required this.isSaving,
    required this.processedTryOnBytes,
    required this.onCapturePhoto,
    required this.onApply,
    required this.onSave,
    required this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 20.0,
        bottom: bottomPadding > 0 ? bottomPadding : 20.0,
      ),
      child: Column(
        children: [
          if (bodyPartImage == null)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onCapturePhoto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA6541D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.capturePhoto,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Amaranth',
                  ),
                ),
              ),
            )
          else
            Column(
              children: [
                if (processedTryOnBytes == null)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (isProcessing || bodyPartImage == null)
                          ? null
                          : onApply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA6541D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              l10n.apply,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Amaranth',
                              ),
                            ),
                    ),
                  ),
                if (processedTryOnBytes == null) const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        (isSaving ||
                            isProcessing ||
                            processedTryOnBytes == null)
                        ? null
                        : onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA6541D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            l10n.download,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Amaranth',
                            ),
                          ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
