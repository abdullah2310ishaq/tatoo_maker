import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/usage_limit_provider.dart';
import '../../../services/admob_ids.dart';
import '../../../services/remote_config_service.dart';
import '../../../utils/colors.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_next_button.dart';

class StepTattooIdeaPage extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const StepTattooIdeaPage({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final cardBgColor = isDark ? null : AppColors.lightBackground;
    final cardGradient = isDark
        ? const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.cardGradientStart, AppColors.cardGradientEnd],
          )
        : null;
    const int maxCharacters = 500;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scrollable content — prevents overflow when keyboard opens
            Flexible(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OnboardingHeader(currentStep: 4, onBack: onBack),
                    const _TattooIdeaBannerAd(),
                    SizedBox(height: 28.h),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.stepTattooIdeaWhatYourTattooIdea,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Amaranth',
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 150.h,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.titleGradientStart,
                            width: 1.w,
                          ),
                          color: cardBgColor,
                          gradient: cardGradient,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controller,
                                    maxLength: maxCharacters,
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: textColor,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(
                                        context,
                                      )!.stepTattooIdeaHint,
                                      hintStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.textGrey,
                                      ),
                                      border: InputBorder.none,
                                      counterText: '',
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 265.h),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            _TattooIdeaNativeAd(isDark: isDark),
            OnboardingNextButton(
              enabled: controller.text.trim().isNotEmpty,
              isLastStep: false,
              onPressed: onNext,
            ),
            SizedBox(height: 35.h),
          ],
        );
      },
    );
  }
}

class _TattooIdeaBannerAd extends StatefulWidget {
  const _TattooIdeaBannerAd();

  @override
  State<_TattooIdeaBannerAd> createState() => _TattooIdeaBannerAdState();
}

class _TattooIdeaBannerAdState extends State<_TattooIdeaBannerAd> {
  BannerAd? _ad;
  bool _loaded = false;

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
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rc = context.watch<RemoteConfigService>();
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    if (isPro || !rc.tattooIdeaShowBanner) return const SizedBox.shrink();

    final ad = _ad;
    if (!_loaded || ad == null) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SafeArea(
          bottom: false,
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

class _TattooIdeaNativeAd extends StatefulWidget {
  const _TattooIdeaNativeAd({required this.isDark});

  final bool isDark;

  @override
  State<_TattooIdeaNativeAd> createState() => _TattooIdeaNativeAdState();
}

class _TattooIdeaNativeAdState extends State<_TattooIdeaNativeAd> {
  NativeAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _TattooIdeaNativeAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDark == widget.isDark) return;
    _ad?.dispose();
    _ad = null;
    _loaded = false;
    _load();
  }

  void _load() {
    final unitId = AdmobIds.nativeUnitId();
    if (unitId.isEmpty) return;

    final ad = NativeAd(
      adUnitId: unitId,
      request: const AdRequest(),
      factoryId: 'listTileLanguage',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _ad = ad as NativeAd;
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
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rc = context.watch<RemoteConfigService>();
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    if (isPro || !rc.tattooIdeaShowNative) return const SizedBox.shrink();

    final slotH = 108.h;
    final ad = _ad;
    if (!_loaded || ad == null) {
      return Padding(
        padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
        child: SizedBox(height: slotH),
      );
    }

    final cardColor = widget.isDark
        ? AppColors.inputCardDarkBackground
        : AppColors.lightBackground;
    final radius = BorderRadius.circular(14.r);

    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
      child: Material(
        color: cardColor,
        elevation: 4,
        shadowColor: AppColors.toastShadow,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: double.infinity,
          height: slotH,
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }
}
