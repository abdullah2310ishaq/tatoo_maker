import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../services/remote_config_service.dart';
import '../../../widgets/language_native_ad.dart';
import '../../../widgets/top_banner_ad.dart';

/// Banner slot for [StepBirthdayPage], gated by Remote Config + existing Pro logic in [TopBannerAd].
class TattooBirthdayBannerAd extends StatelessWidget {
  const TattooBirthdayBannerAd({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<RemoteConfigService, bool>(
      selector: (_, rc) => rc.tattooBirthdayShowBanner,
      builder: (context, show, _) {
        if (!show) return const SizedBox.shrink();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TopBannerAd(),
            SizedBox(height: 12.h),
          ],
        );
      },
    );
  }
}

/// Native ad slot for [StepBirthdayPage], gated by Remote Config + Pro in [LanguageNativeAd].
class TattooBirthdayNativeAd extends StatelessWidget {
  const TattooBirthdayNativeAd({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Selector<RemoteConfigService, bool>(
      selector: (_, rc) => rc.tattooBirthdayShowNative,
      builder: (context, show, _) {
        if (!show) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: LanguageNativeAd(isDark: isDark, compact: true),
        );
      },
    );
  }
}
