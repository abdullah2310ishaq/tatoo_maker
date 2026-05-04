import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../home_shell.dart';
import '../l10n/app_localizations.dart';
import '../pro_access_screen.dart';
import '../providers/usage_limit_provider.dart';
import '../services/admob_ids.dart';
import '../services/interstitial_ad_flow.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../utils/toast.dart';
import 'loading_screen.dart';
import 'result_screen.dart';

/// Free-tier creation: one real design + three locked previews, then full [ResultScreen] on tap.
class FreeCreationMultiResultScreen extends StatefulWidget {
  final Uint8List generatedImageBytes;
  final String styleName;
  final String? promptText;
  final String? selectedStyleAsset;

  const FreeCreationMultiResultScreen({
    super.key,
    required this.generatedImageBytes,
    required this.styleName,
    this.promptText,
    this.selectedStyleAsset,
  });

  @override
  State<FreeCreationMultiResultScreen> createState() =>
      _FreeCreationMultiResultScreenState();
}

class _FreeCreationMultiResultScreenState
    extends State<FreeCreationMultiResultScreen> {
  bool _isRecreating = false;

  Future<void> _onRecreatePressed() async {
    if (_isRecreating) return;
    final usage = context.read<UsageLimitProvider>();
    final canStart = await usage.canStartCreationHomeGeneration();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    if (!canStart) {
      AppToast.show(
        context,
        message: l10n.creationFreeGateNoGenerationsLeft,
        isSuccess: false,
      );
      return;
    }

    setState(() => _isRecreating = true);
    try {
      await showInterstitialAdIfAvailable(
        context,
        adUnitId: AdmobIds.interstitialUnitId(),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoadingScreen(
            selectedStyleAsset: widget.selectedStyleAsset,
            styleName: widget.styleName == 'generic' ? null : widget.styleName,
            promptText: widget.promptText,
            freeCreationHomeFlow: true,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isRecreating = false);
    }
  }

  void _openPaywall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProAccessScreen(
          showInterstitialOnClose: false,
          goToNextScreenOnClose: true,
          nextScreen: const HomeShell(),
        ),
      ),
    );
  }

  void _openFullResult() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          styleName: widget.styleName,
          generatedImageBytes: widget.generatedImageBytes,
          promptText: widget.promptText,
          showProAccessOnOpen: false,
        ),
      ),
    );
  }

  Widget _lockedCard(AppLocalizations l10n, bool isDark) {
    return Material(
      color: const Color(0xFFC8C8C8),
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: _openPaywall,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Image.memory(
                  widget.generatedImageBytes,
                  fit: BoxFit.cover,
                ),
              ),
              ColoredBox(color: AppColors.textWhite.withValues(alpha: 0.35)),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.proBadgeBackground,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: AppColors.textWhite,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            l10n.creationMultiProBadge,
                            style: TextStyle(
                              color: AppColors.textWhite,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Amaranth',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      l10n.creationMultiUnlockAllDesigns,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textWhite
                            : AppColors.textPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Amaranth',
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _unlockedCard(bool isDark) {
    return Material(
      color: AppColors.textWhite,
      borderRadius: BorderRadius.circular(16.r),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: _openFullResult,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.memory(widget.generatedImageBytes, fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeShell()),
          (route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Container(
          decoration: isDark
              ? ThemeManager.darkModeBackgroundGradient
              : ThemeManager.lightModeBackground,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 0),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Material(
                      color: AppColors.buttonBackground,
                      borderRadius: BorderRadius.circular(8.r),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8.r),
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const HomeShell(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            Icons.arrow_back,
                            color: AppColors.cardGlowStart,
                            size: 22.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 0.95,
                      children: [
                        _unlockedCard(isDark),
                        _lockedCard(l10n, isDark),
                        _lockedCard(l10n, isDark),
                        _lockedCard(l10n, isDark),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: _isRecreating ? null : _onRecreatePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.proBadgeBackground,
                        foregroundColor: AppColors.textWhite,
                        disabledBackgroundColor: AppColors.proBadgeBackground
                            .withValues(alpha: 0.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: _isRecreating
                          ? SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.textWhite,
                              ),
                            )
                          : Text(
                              l10n.creationMultiRecreate,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Amaranth',
                              ),
                            ),
                    ),
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
