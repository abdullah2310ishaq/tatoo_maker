import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../home_shell.dart';
import '../l10n/app_localizations.dart';
import '../providers/usage_limit_provider.dart';
import '../services/admob_ids.dart';
import '../services/rewarded_ad_flow.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../utils/toast.dart';
import '../pro_access_screen.dart';
import 'loading_screen.dart';
import 'result_screen.dart';
import 'widgets/free_creation_generate_gate_dialog.dart';

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
  int _unlockedCardsCount = 1;
  late final List<Uint8List> _unlockedImages = [widget.generatedImageBytes];

  void _openRemoveLimitsPaywall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProAccessScreen(
          showInterstitialOnClose: false,
          // Close (X) should return back to this results screen (pop),
          // not force the user to the home creation page.
          goToNextScreenOnClose: false,
          // If purchase/restore completes inside the paywall, it will replace
          // with this screen so the user stays in the same flow.
          nextScreen: FreeCreationMultiResultScreen(
            generatedImageBytes: widget.generatedImageBytes,
            styleName: widget.styleName,
            promptText: widget.promptText,
            selectedStyleAsset: widget.selectedStyleAsset,
          ),
        ),
      ),
    );
  }

  Future<void> _onRecreatePressed() async {
    if (_isRecreating) return;
    final usage = context.read<UsageLimitProvider>();
    final l10n = AppLocalizations.of(context)!;
    final gateChoice = await showFreeCreationGenerateGateDialog(
      context: context,
      freeGenerationsRemaining: usage.freeCreationHomeGenerationsRemaining,
      freeGenerationLimit: UsageLimitProvider.creationHomeFreeLimit,
    );
    if (!mounted) return;

    switch (gateChoice) {
      case FreeCreationGenerateGateChoice.dismissed:
        return;
      case FreeCreationGenerateGateChoice.removeLimits:
        _openRemoveLimitsPaywall();
        return;
      case FreeCreationGenerateGateChoice.watchAd:
        break;
    }

    setState(() => _isRecreating = true);
    try {
      final earned = await showRewardedAdIfAvailable(
        context,
        adUnitId: AdmobIds.rewardedUnitId(),
      );
      if (!mounted) return;
      if (!earned) {
        AppToast.show(
          context,
          message: l10n.rewardedAdNotAvailableTryAgain,
          isSuccess: false,
        );
        return;
      }
      final canStart = await usage.canStartCreationHomeGeneration();
      if (!mounted) return;
      if (!canStart) {
        AppToast.show(
          context,
          message: l10n.creationFreeGateNoGenerationsLeft,
          isSuccess: false,
        );
        return;
      }
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

  Future<void> _onLockedCardTap() async {
    if (_unlockedCardsCount >= 4) {
      _openFullResult();
      return;
    }
    final usage = context.read<UsageLimitProvider>();
    final l10n = AppLocalizations.of(context)!;

    final gateChoice = await showFreeCreationGenerateGateDialog(
      context: context,
      freeGenerationsRemaining: usage.freeCreationHomeGenerationsRemaining,
      freeGenerationLimit: UsageLimitProvider.creationHomeFreeLimit,
    );
    if (!mounted) return;

    switch (gateChoice) {
      case FreeCreationGenerateGateChoice.dismissed:
        return;
      case FreeCreationGenerateGateChoice.removeLimits:
        _openRemoveLimitsPaywall();
        return;
      case FreeCreationGenerateGateChoice.watchAd:
        final earned = await showRewardedAdIfAvailable(
          context,
          adUnitId: AdmobIds.rewardedUnitId(),
        );
        if (!mounted) return;
        if (!earned) {
          AppToast.show(
            context,
            message: l10n.rewardedAdNotAvailableTryAgain,
            isSuccess: false,
          );
          return;
        }
        final canStart = await usage.canStartCreationHomeGeneration();
        if (!mounted) return;
        if (!canStart) {
          AppToast.show(
            context,
            message: l10n.creationFreeGateNoGenerationsLeft,
            isSuccess: false,
          );
          return;
        }
        final nextBytes = await Navigator.of(context).push<Uint8List?>(
          MaterialPageRoute(
            builder: (_) => LoadingScreen(
              selectedStyleAsset: widget.selectedStyleAsset,
              styleName: widget.styleName == 'generic' ? null : widget.styleName,
              promptText: widget.promptText,
              freeCreationHomeFlow: true,
              popWithResultOnComplete: true,
            ),
          ),
        );
        if (!mounted) return;
        if (nextBytes == null || nextBytes.isEmpty) return;

        setState(() {
          if (_unlockedImages.length < 4) {
            _unlockedImages.add(nextBytes);
          } else {
            _unlockedImages[_unlockedImages.length - 1] = nextBytes;
          }
          _unlockedCardsCount = _unlockedImages.length.clamp(1, 4);
        });
        return;
    }
  }

  void _openFullResult() {
    _openResultForBytes(widget.generatedImageBytes);
  }

  void _openResultForBytes(Uint8List bytes) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          styleName: widget.styleName,
          generatedImageBytes: bytes,
          promptText: widget.promptText,
          showProAccessOnOpen: false,
          returnToHomeOnClose: false,
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
        onTap: _onLockedCardTap,
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

  Widget _unlockedCard(Uint8List bytes, bool isDark) {
    return Material(
      color: AppColors.textWhite,
      borderRadius: BorderRadius.circular(16.r),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () => _openResultForBytes(bytes),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.memory(bytes, fit: BoxFit.cover),
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
                            size: 20.sp,
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
                      vertical: 40.h,
                    ),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 0.95,
                      children: List<Widget>.generate(4, (index) {
                        final isUnlocked = index < _unlockedCardsCount;
                        if (!isUnlocked) return _lockedCard(l10n, isDark);
                        final bytes = _unlockedImages[index];
                        return _unlockedCard(bytes, isDark);
                      }),
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
