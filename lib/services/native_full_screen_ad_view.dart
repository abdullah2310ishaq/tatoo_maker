import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/colors.dart';


/// Full-height native ad using the medium Android factory (`listTileMedium`).
class NativeFullScreenAdView extends StatefulWidget {
  final String adUnitId;
  final bool enabled;

  const NativeFullScreenAdView({
    super.key,
    required this.adUnitId,
    this.enabled = true,
  });

  @override
  State<NativeFullScreenAdView> createState() => _NativeFullScreenAdViewState();
}

class _NativeFullScreenAdViewState extends State<NativeFullScreenAdView> {
  NativeAd? nativeAd;
  bool isLoadedNativeAd = false;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _loadAd();
    }
  }

  void _loadAd() {
    if (!widget.enabled) return;

    final ad = NativeAd(
      adUnitId: widget.adUnitId,
      factoryId: 'listTileLanguage',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            nativeAd = ad as NativeAd;
            isLoadedNativeAd = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            nativeAd = null;
            isLoadedNativeAd = false;
          });
          debugPrint(
            'NativeFullScreenAd failed: ${error.code} - ${error.message}',
          );
        },
      ),
    );

    nativeAd = ad;
    ad.load();
  }

  @override
  void dispose() {
    nativeAd?.dispose();
    nativeAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return const SizedBox.shrink();
    }

    final ad = nativeAd;

    if (!isLoadedNativeAd || ad == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.blueClr),
      );
    }

    return SizedBox.expand(
      child: AdWidget(ad: ad),
    );
  }
}
