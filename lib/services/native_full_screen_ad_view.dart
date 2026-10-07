// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// import '../utils/colors.dart';
//
//
// /// Full-height native ad using the medium Android factory (`listTileMedium`).
// class NativeFullScreenAdView extends StatefulWidget {
//   final String adUnitId;
//   final bool enabled;
//
//   const NativeFullScreenAdView({
//     super.key,
//     required this.adUnitId,
//     this.enabled = true,
//   });
//
//   @override
//   State<NativeFullScreenAdView> createState() => _NativeFullScreenAdViewState();
// }
//
// class _NativeFullScreenAdViewState extends State<NativeFullScreenAdView> {
//   NativeAd? nativeAd;
//   bool isLoadedNativeAd = false;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.enabled) {
//       _loadAd();
//     }
//   }
//
//   void _loadAd() {
//     if (!widget.enabled) return;
//
//     final ad = NativeAd(
//       adUnitId: widget.adUnitId,
//       factoryId: 'listTileLanguage',
//       request: const AdRequest(),
//       listener: NativeAdListener(
//         onAdLoaded: (ad) {
//           if (!mounted) {
//             ad.dispose();
//             return;
//           }
//           setState(() {
//             nativeAd = ad as NativeAd;
//             isLoadedNativeAd = true;
//           });
//         },
//         onAdFailedToLoad: (ad, error) {
//           ad.dispose();
//           if (!mounted) return;
//           setState(() {
//             nativeAd = null;
//             isLoadedNativeAd = false;
//           });
//           debugPrint(
//             'NativeFullScreenAd failed: ${error.code} - ${error.message}',
//           );
//         },
//       ),
//     );
//
//     nativeAd = ad;
//     ad.load();
//   }
//
//   @override
//   void dispose() {
//     nativeAd?.dispose();
//     nativeAd = null;
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!widget.enabled) {
//       return const SizedBox.shrink();
//     }
//
//     final ad = nativeAd;
//
//     if (!isLoadedNativeAd || ad == null) {
//       return const Center(
//         child: CircularProgressIndicator(color: AppColors.blueClr),
//       );
//     }
//
//     return SizedBox.expand(
//       child: AdWidget(ad: ad),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../providers/usage_limit_provider.dart';
import '../utils/colors.dart';

class NativeFullScreenAdView extends StatefulWidget {
  const NativeFullScreenAdView({
    super.key,
    required this.adUnitId,
    this.isDark,
    this.backgroundColor,
  });

  static const String factoryId = 'listTileLanguage';

  final String adUnitId;
  final bool? isDark;
  final Color? backgroundColor;

  @override
  State<NativeFullScreenAdView> createState() => _NativeFullScreenAdViewState();
}

class _NativeFullScreenAdViewState extends State<NativeFullScreenAdView> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

// Don't load/show ad for Pro users.
      if (context.read<UsageLimitProvider>().isProUnlocked) return;

      _loadAd();
    });
  }

  Future<void> _loadAd() async {
    final unitId = widget.adUnitId.trim();

    if (unitId.isEmpty) return;

// Double-check Pro status before loading.
    if (context.read<UsageLimitProvider>().isProUnlocked) return;

    final isDark =
        widget.isDark ?? (Theme.of(context).brightness == Brightness.dark);

    final bgColor = widget.backgroundColor ??
        (isDark ? AppColors.darkBackground : AppColors.lightBackground);

    final ad = NativeAd(
      adUnitId: unitId,
      factoryId: NativeFullScreenAdView.factoryId,
      request: const AdRequest(),
      customOptions: <String, Object>{
        'bgColor': bgColor.value,
        'isDark': isDark,
      },
      listener: NativeAdListener(
        onAdLoaded: (loadedAd) {
          if (!mounted) {
            loadedAd.dispose();
            return;
          }

// Pro user may have become Pro while the ad was loading.
          if (context.read<UsageLimitProvider>().isProUnlocked) {
            loadedAd.dispose();
            return;
          }

          setState(() {
            _nativeAd = loadedAd as NativeAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (failedAd, error) {
          failedAd.dispose();

          debugPrint(
            '[NativeFullScreenAdView] failed to load: '
            '${error.code} - ${error.message}',
          );

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

// Pro users should not see the ad or loading indicator.
    if (isPro) {
      return const SizedBox.shrink();
    }

    final ad = _nativeAd;

// Loading state.
    if (!_isLoaded || ad == null) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.lightPrimary,
        ),
      );
    }

// Loaded full-screen native ad.
    return SizedBox.expand(
      child: AdWidget(ad: ad),
    );
  }
}
