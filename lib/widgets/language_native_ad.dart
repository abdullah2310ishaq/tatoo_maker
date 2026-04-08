import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../providers/usage_limit_provider.dart';
import '../services/admob_ids.dart';
import '../utils/colors.dart';

/// Native (template) ad for language onboarding / language settings.
/// Shown for free users only; Pro users see nothing.
class LanguageNativeAd extends StatefulWidget {
  const LanguageNativeAd({
    super.key,
    required this.isDark,
    this.compact = false,
  });

  final bool isDark;

  /// Shorter height + tighter padding (e.g. first-language screen).
  final bool compact;

  @override
  State<LanguageNativeAd> createState() => _LanguageNativeAdState();
}

class _LanguageNativeAdState extends State<LanguageNativeAd> {
  NativeAd? _nativeAd;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant LanguageNativeAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDark != widget.isDark) {
      _nativeAd?.dispose();
      _nativeAd = null;
      _loaded = false;
      _load();
    }
  }

  void _load() {
    final unitId = AdmobIds.nativeUnitId();
    if (unitId.isEmpty) return;

    final ad = NativeAd(
      adUnitId: unitId,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: widget.isDark
            ? AppColors.navBarBackground
            : AppColors.lightBackground,
        cornerRadius: 12,
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _nativeAd = ad as NativeAd;
            _loaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (kDebugMode) {
            debugPrint('[LanguageNativeAd] failed to load: $error');
          }
          if (!mounted) return;
          setState(() {
            _nativeAd = null;
            _loaded = false;
          });
        },
      ),
    );

    _nativeAd = ad;
    ad.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    if (isPro) return const SizedBox.shrink();

    final ad = _nativeAd;
    if (!_loaded || ad == null) {
      return SizedBox(height: widget.compact ? 4.h : 8.h);
    }

    final adHeight = widget.compact ? 81.h : 90.h;

    return Padding(
      padding: EdgeInsets.only(bottom: widget.compact ? 4.h : 8.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(
          width: double.infinity,
          height: adHeight,
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }
}
