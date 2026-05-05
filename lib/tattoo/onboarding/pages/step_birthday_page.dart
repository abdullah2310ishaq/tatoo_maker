import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/usage_limit_provider.dart';
import '../../../services/admob_ids.dart';
import '../../../services/remote_config_service.dart';
import '../../../services/native_ad_service.dart';
import '../../../utils/colors.dart';
import '../widgets/onboarding_header.dart';

class StepBirthdayPage extends StatefulWidget {
  final int selectedMonth;
  final int selectedDay;
  final int selectedYear;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<int> onDayChanged;
  final ValueChanged<int> onYearChanged;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const StepBirthdayPage({
    super.key,
    required this.selectedMonth,
    required this.selectedDay,
    required this.selectedYear,
    required this.onMonthChanged,
    required this.onDayChanged,
    required this.onYearChanged,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<StepBirthdayPage> createState() => _StepBirthdayPageState();
}

class _StepBirthdayPageState extends State<StepBirthdayPage> {
  bool _bannerVisible = false;
  bool _nativeVisible = false;

  bool _isDateValid() {
    final now = DateTime.now();
    try {
      final selectedDate = DateTime(
        widget.selectedYear,
        widget.selectedMonth + 1, // Month is 0-indexed in widget
        widget.selectedDay,
      );
      // Date is valid if it's not in the future
      return !selectedDate.isAfter(now);
    } catch (e) {
      // Invalid date (e.g., Feb 30)
      return false;
    }
  }

  String _getFormattedDate(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final months = [
      l10n.monthJanuary,
      l10n.monthFebruary,
      l10n.monthMarch,
      l10n.monthApril,
      l10n.monthMay,
      l10n.monthJune,
      l10n.monthJuly,
      l10n.monthAugust,
      l10n.monthSeptember,
      l10n.monthOctober,
      l10n.monthNovember,
      l10n.monthDecember,
    ];
    return '${months[widget.selectedMonth]} ${widget.selectedDay} ${widget.selectedYear}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final rc = context.watch<RemoteConfigService>();
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    final canShowBanner = !isPro && rc.tattooBirthdayShowBanner;
    final canShowNative = !isPro && rc.tattooBirthdayShowNative;

    final shouldShowNative = canShowNative;
    final shouldShowBanner = canShowBanner && !canShowNative;
    if (!shouldShowBanner && _bannerVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_bannerVisible) setState(() => _bannerVisible = false);
      });
    }
    if (!shouldShowNative && _nativeVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_nativeVisible) setState(() => _nativeVisible = false);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OnboardingHeader(
                    currentStep: 2,
                    onBack: widget.onBack,
                    trailing: Padding(
                      padding: EdgeInsets.only(top: 1.h),
                      child: _BirthdayNextTopRightButton(
                        enabled: _isDateValid(),
                        onPressed: widget.onNext,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    AppLocalizations.of(context)!.stepBirthdayWhatsYourBirthday,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Amaranth',
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    _getFormattedDate(context),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Amaranth',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: _buildDatePicker(isDark),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
        // Bottom ads (no reserved space when not loaded).
        // Order: Banner first, then Native. Gap only when both visible.
        if (shouldShowBanner)
          _BirthdayBannerAd(
            onVisibilityChanged: (visible) {
              if (_bannerVisible == visible) return;
              setState(() => _bannerVisible = visible);
            },
          ),
        if (shouldShowNative) ...[
          if (_bannerVisible && _nativeVisible) SizedBox(height: 8.h),
          _BirthdayNativeAd(
            isDark: isDark,
            onVisibilityChanged: (visible) {
              if (_nativeVisible == visible) return;
              setState(() => _nativeVisible = visible);
            },
          ),
        ],
        SafeArea(
          top: false,
          left: false,
          right: false,
          child: SizedBox(height: 8.h),
        ),
      ],
    );
  }

  Widget _buildDatePicker(bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final months = [
      l10n.monthJanuary,
      l10n.monthFebruary,
      l10n.monthMarch,
      l10n.monthApril,
      l10n.monthMay,
      l10n.monthJune,
      l10n.monthJuly,
      l10n.monthAugust,
      l10n.monthSeptember,
      l10n.monthOctober,
      l10n.monthNovember,
      l10n.monthDecember,
    ];
    final days = List.generate(31, (i) => i + 1);
    final currentYear = DateTime.now().year;
    // Generate years from current year down to 100 years ago
    final years = List.generate(100, (i) => currentYear - i);

    return SizedBox(
      height: 205.h,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final pickerHeight = constraints.maxHeight;
          final selectionHeight = 50.h;
          // Upward offset so the frame hugs the selected row precisely.
          // (ListWheel has optical center slightly above geometric center.)
          final top = (pickerHeight - selectionHeight) / 2 - 1.h;

          return Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildPickerColumn(
                      items: months,
                      selectedIndex: widget.selectedMonth,
                      onChanged: (index) {
                        widget.onMonthChanged(index);
                        setState(() {}); // Rebuild to update button state
                      },
                      isDark: isDark,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _buildPickerColumn(
                      items: days.map((d) => d.toString()).toList(),
                      selectedIndex: widget.selectedDay - 1,
                      onChanged: (index) {
                        widget.onDayChanged(index + 1);
                        setState(() {}); // Rebuild to update button state
                      },
                      isDark: isDark,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _buildPickerColumn(
                      items: years.map((y) => y.toString()).toList(),
                      selectedIndex: years.contains(widget.selectedYear)
                          ? years.indexOf(widget.selectedYear)
                          : 0,
                      onChanged: (index) {
                        widget.onYearChanged(years[index]);
                        setState(() {}); // Rebuild to update button state
                      },
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 1,
                right: 8,
                top: top,
                height: selectionHeight,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFFE8B3A),
                        width: 1.5.w,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPickerColumn({
    required List<String> items,
    required int selectedIndex,
    required ValueChanged<int> onChanged,
    required bool isDark,
  }) {
    return SizedBox(
      height: 200.h,
      child: ListWheelScrollView.useDelegate(
        controller: FixedExtentScrollController(initialItem: selectedIndex),
        itemExtent: 50.h,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        perspective: 0.003,
        diameterRatio: 1.5,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= items.length) return null;
            final isSelected = index == selectedIndex;
            return Center(
              child: Text(
                items[index],
                style: TextStyle(
                  fontSize: isSelected ? 20.sp : 16.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? (isDark ? AppColors.textWhite : AppColors.textPrimary)
                      : (isDark
                            ? AppColors.textGrey.withOpacity(0.4)
                            : AppColors.textGrey.withOpacity(0.4)),
                ),
              ),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}

class _BirthdayBannerAd extends StatefulWidget {
  const _BirthdayBannerAd({required this.onVisibilityChanged});

  final ValueChanged<bool> onVisibilityChanged;

  @override
  State<_BirthdayBannerAd> createState() => _BirthdayBannerAdState();
}

class _BirthdayBannerAdState extends State<_BirthdayBannerAd> {
  BannerAd? _ad;
  int _loadedWidth = 0;
  bool _loaded = false;
  bool _lastEmitted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadIfEligibleForCurrentWidth();
    });
  }

  void _emit(bool visible) {
    if (_lastEmitted == visible) return;
    _lastEmitted = visible;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onVisibilityChanged(visible);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadIfEligibleForCurrentWidth();
  }

  Future<void> _loadIfEligibleForCurrentWidth() async {
    if (!mounted) return;
    final rc = context.read<RemoteConfigService>();
    final isPro = context.read<UsageLimitProvider>().isProUnlocked;
    if (isPro || !rc.tattooBirthdayShowBanner) return;

    final width = MediaQuery.of(context).size.width.truncate();
    if (width <= 0) return;
    if (_loadedWidth == width && _ad != null) return;
    _loadedWidth = width;

    await _loadAdaptive(unitId: AdmobIds.bannerUnitId(), width: width);
  }

  Future<void> _loadAdaptive({
    required String unitId,
    required int width,
  }) async {
    if (unitId.isEmpty) return;
    final adaptiveSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (adaptiveSize == null) return;

    _ad?.dispose();
    _ad = null;
    if (mounted && _loaded) {
      setState(() {
        _loaded = false;
      });
    }

    final ad = BannerAd(
      adUnitId: unitId,
      request: const AdRequest(),
      size: adaptiveSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _ad = ad as BannerAd;
            _loaded = true;
          });
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _ad = null;
            _loaded = false;
          });
        },
      ),
    );

    _ad = ad;
    ad.load();
  }

  @override
  void dispose() {
    _emit(false);
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rc = context.watch<RemoteConfigService>();
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    if (isPro || !rc.tattooBirthdayShowBanner) {
      _emit(false);
      return const SizedBox.shrink();
    }

    final ad = _ad;
    if (!_loaded || ad == null) {
      _emit(false);
      return const SizedBox.shrink();
    }

    _emit(true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SafeArea(
          top: false,
          left: false,
          right: false,
          child: Center(
            child: SizedBox(
              width: ad.size.width.toDouble(),
              height: ad.size.height.toDouble(),
              child: AdWidget(ad: ad),
            ),
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}

class _BirthdayNativeAd extends StatefulWidget {
  const _BirthdayNativeAd({
    required this.isDark,
    required this.onVisibilityChanged,
  });

  final bool isDark;
  final ValueChanged<bool> onVisibilityChanged;

  @override
  State<_BirthdayNativeAd> createState() => _BirthdayNativeAdState();
}

class _BirthdayNativeAdState extends State<_BirthdayNativeAd> {
  bool _lastEmitted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final rc = context.read<RemoteConfigService>();
      final isPro = context.read<UsageLimitProvider>().isProUnlocked;
      if (isPro || !rc.tattooBirthdayShowNative) return;
      // Platform views may not preserve transparency reliably on all Android
      // compositions, so we set an explicit themed background color.
      final cardColor = AppColors.gradientBottom;
      unawaited(
        NativeAdService.instance.preload(
          backgroundColor: cardColor.value,
          isDark: true,
        ),
      );
    });
  }

  void _emit(bool visible) {
    if (_lastEmitted == visible) return;
    _lastEmitted = visible;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onVisibilityChanged(visible);
    });
  }

  @override
  void didUpdateWidget(covariant _BirthdayNativeAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDark == widget.isDark) return;
    _emit(false);
    final cardColor = AppColors.gradientBottom;
    unawaited(
      NativeAdService.instance.ensureLoaded(
        backgroundColor: cardColor.value,
        isDark: true,
      ),
    );
  }

  @override
  void dispose() {
    _emit(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rc = context.watch<RemoteConfigService>();
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    if (isPro || !rc.tattooBirthdayShowNative) {
      _emit(false);
      return const SizedBox.shrink();
    }

    final nativeService = context.watch<NativeAdService>();
    final ad = nativeService.ad;
    if (!nativeService.isLoaded || ad == null) {
      _emit(false);
      return const SizedBox.shrink();
    }

    _emit(true);
    final cardColor = AppColors.gradientBottom;
    final radius = BorderRadius.circular(14.r);
    final slotHeight = 280.h;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: cardColor,
        elevation: 0,
        shadowColor: const Color(0x00000000),
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: double.infinity,
          height: slotHeight,
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }
}

class _BirthdayNextTopRightButton extends StatelessWidget {
  const _BirthdayNextTopRightButton({
    required this.enabled,
    required this.onPressed,
  });

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final enabledBackground = AppColors.darkPrimary;
    final disabledBackground = isDark
        ? AppColors.buttonBackground
        : AppColors.textGrey.withOpacity(0.1);
    final enabledText = AppColors.textWhite;
    final disabledText = AppColors.textGrey;

    return SizedBox(
      height: 44.h,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? enabledBackground : disabledBackground,
          foregroundColor: enabled ? enabledText : disabledText,
          elevation: enabled ? 4 : 0,
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          l10n.next,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Amaranth',
          ),
        ),
      ),
    );
  }
}
