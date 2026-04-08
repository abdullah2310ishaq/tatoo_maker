import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../providers/usage_limit_provider.dart';
import '../services/admob_ids.dart';

class TopBannerAd extends StatefulWidget {
  const TopBannerAd({super.key});

  @override
  State<TopBannerAd> createState() => _TopBannerAdState();
}

class _TopBannerAdState extends State<TopBannerAd> {
  BannerAd? _bannerAd;
  bool _didLoad = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final unitId = AdmobIds.bannerUnitId();
    if (unitId.isEmpty) return;

    final ad = BannerAd(
      adUnitId: unitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _bannerAd = ad as BannerAd;
            _didLoad = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (kDebugMode) {
            debugPrint('[TopBannerAd] failed to load: $error');
          }
          if (!mounted) return;
          setState(() {
            _bannerAd = null;
            _didLoad = false;
          });
        },
      ),
    );

    _bannerAd = ad;
    ad.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    if (isPro) return const SizedBox.shrink();

    final ad = _bannerAd;
    if (!_didLoad || ad == null) return const SizedBox.shrink();

    return SafeArea(
      bottom: false,
      child: Center(
        child: SizedBox(
          width: ad.size.width.toDouble(),
          height: ad.size.height.toDouble(),
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }
}
