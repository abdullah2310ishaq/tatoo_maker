import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../providers/usage_limit_provider.dart';
import '../utils/colors.dart';
import 'admob_ids.dart';

class NativeSmallAdView extends StatefulWidget {
  const NativeSmallAdView({
    super.key,
    this.isDark,
    this.backgroundColor,
  });

  static const double height = 150;
  static const String factoryId = 'listTileSmall';

  final bool? isDark;
  final Color? backgroundColor;

  @override
  State<NativeSmallAdView> createState() => _NativeSmallAdViewState();
}

class _NativeSmallAdViewState extends State<NativeSmallAdView> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.read<UsageLimitProvider>().isProUnlocked) return;
      _loadAd();
    });
  }

  Future<void> _loadAd() async {
    final unitId = AdIds.testNativeIdNew.trim();
    if (unitId.isEmpty) return;

    final isDark = widget.isDark ??
        (Theme.of(context).brightness == Brightness.dark);
    final bgColor = widget.backgroundColor ??
        (isDark ? AppColors.darkBackground : AppColors.lightBackground);

    final ad = NativeAd(
      adUnitId: unitId,
      factoryId: NativeSmallAdView.factoryId,
      request: const AdRequest(),
      customOptions: <String, Object>{
        'bgColor': bgColor.value,
        'isDark': isDark,
      },
      listener: NativeAdListener(
        onAdLoaded: (loadedAd) {
          if (!mounted) return;
          setState(() {
            _nativeAd = loadedAd as NativeAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (failedAd, error) {
          failedAd.dispose();
          debugPrint('[NativeSmallAdView] failed to load: $error');
          if (!mounted) return;
          setState(() {
            _nativeAd = null;
            _isLoaded = false;
          });
        },
      ),
    );

    _nativeAd?.dispose();
    _nativeAd = ad;
    await ad.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    _nativeAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    if (isPro) return const SizedBox.shrink();

    final ad = _nativeAd;
    return SizedBox(
      width: double.infinity,
      height: NativeSmallAdView.height,
      child: _isLoaded && ad != null
          ? AdWidget(ad: ad)
          : const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.lightPrimary,
              ),
            ),
    );
  }
}
