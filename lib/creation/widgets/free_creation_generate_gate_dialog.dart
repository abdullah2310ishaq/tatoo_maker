import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/colors.dart';

/// User choice from the free-tier creation generate gate.
enum FreeCreationGenerateGateChoice { dismissed, removeLimits, watchAd }

const String _modaAssetPath = 'assets/dialog.png';

/// Modal for non-pro users before generating from the creation (tattoo) flow.
Future<FreeCreationGenerateGateChoice> showFreeCreationGenerateGateDialog({
  required BuildContext context,
  required int freeGenerationsRemaining,
  required int freeGenerationLimit,
}) async {
  final result = await showDialog<FreeCreationGenerateGateChoice>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      final l10n = AppLocalizations.of(dialogContext)!;
      final canWatchAd = freeGenerationsRemaining > 0;
      final counterLabel = l10n.creationFreeGateAdUsesCounter(
        freeGenerationsRemaining,
        freeGenerationLimit,
      );

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.navBarBackground,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.cardGlowStart, width: 2),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 40.h, 16.w, 20.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: AspectRatio(
                          aspectRatio: 16 / 10,
                          child: Image.asset(
                            _modaAssetPath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => ColoredBox(
                              color: AppColors.buttonBackground,
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: AppColors.textGrey,
                                  size: 40.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        l10n.creationFreeGateTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Amaranth',
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textWhite,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(
                            dialogContext,
                          ).pop(FreeCreationGenerateGateChoice.removeLimits),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.cardGlowStart,
                            foregroundColor: AppColors.textWhite,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            l10n.creationFreeGateRemoveLimits,
                            style: TextStyle(
                              fontFamily: 'Amaranth',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: canWatchAd
                              ? () => Navigator.of(
                                  dialogContext,
                                ).pop(FreeCreationGenerateGateChoice.watchAd)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textGrey,
                            disabledBackgroundColor: AppColors.textGrey
                                .withValues(alpha: 0.35),
                            foregroundColor: AppColors.textWhite,
                            disabledForegroundColor: AppColors.textWhite
                                .withValues(alpha: 0.5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.creationFreeGateWatchAd,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Amaranth',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                counterLabel,
                                style: TextStyle(
                                  fontFamily: 'Amaranth',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: canWatchAd
                                      ? AppColors.textWhite
                                      : AppColors.textWhite.withValues(
                                          alpha: 0.5,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 6.h,
                  right: 6.w,
                  child: IconButton(
                    onPressed: () => Navigator.of(
                      dialogContext,
                    ).pop(FreeCreationGenerateGateChoice.dismissed),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textWhite,
                      size: 22.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  return result ?? FreeCreationGenerateGateChoice.dismissed;
}
