import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../providers/usage_limit_provider.dart';
import '../services/admob_ids.dart';
import '../services/locale_service.dart';
import '../utils/colors.dart';
import '../real_onboarding/real_onboarding_flow.dart';

/// First language selection screen - Light theme only (one-time onboarding)
class FirstLanguageScreen extends StatefulWidget {
  const FirstLanguageScreen({super.key});

  @override
  State<FirstLanguageScreen> createState() => _FirstLanguageScreenState();
}

class _FirstLanguageScreenState extends State<FirstLanguageScreen> {
  String? _selectedLanguage;

  final List<Map<String, dynamic>> _languages = [
    {
      'code': 'en',
      'name': 'English',
      'nativeName': 'English',
      'imageAsset': 'assets/language/usa.svg',
      'isPng': false,
    },
    {
      'code': 'es',
      'name': 'Spanish',
      'nativeName': 'Español',
      'imageAsset': 'assets/language/espanol.svg',
      'isPng': false,
    },
    {
      'code': 'fr',
      'name': 'French',
      'nativeName': 'Français',
      'imageAsset': 'assets/language/french.svg',
      'isPng': false,
    },
    {
      'code': 'de',
      'name': 'German',
      'nativeName': 'Deutsch',
      'imageAsset': 'assets/language/german.svg',
      'isPng': false,
    },
    {
      'code': 'it',
      'name': 'Italian',
      'nativeName': 'Italiano',
      'imageAsset': 'assets/language/italian.svg',
      'isPng': false,
    },
    {
      'code': 'pt',
      'name': 'Portuguese',
      'nativeName': 'Português',
      'imageAsset': 'assets/language/portugal.png',
      'isPng': true,
    },
    {
      'code': 'ru',
      'name': 'Russian',
      'nativeName': 'Русский',
      'imageAsset': 'assets/language/russia.svg',
      'isPng': false,
    },
    {
      'code': 'zh',
      'name': 'Chinese',
      'nativeName': '中文',
      'imageAsset': 'assets/language/china.svg',
      'isPng': false,
    },
    {
      'code': 'ja',
      'name': 'Japanese',
      'nativeName': '日本語',
      'imageAsset': 'assets/language/japan.svg',
      'isPng': false,
    },
    {
      'code': 'ko',
      'name': 'Korean',
      'nativeName': '한국어',
      'imageAsset': 'assets/language/korea.svg',
      'isPng': false,
    },
    {
      'code': 'ar',
      'name': 'Arabic',
      'nativeName': 'العربية',
      'imageAsset': 'assets/language/sudan.svg',
      'isPng': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Get current locale from service
    final localeService = Provider.of<LocaleService>(context, listen: false);
    _selectedLanguage = localeService.getCurrentLocale().languageCode;
  }

  @override
  Widget build(BuildContext context) {
    // Follow dark theme (default theme is dark)
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  AppLocalizations.of(context)!.chooseALanguage,
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                    fontFamily: 'Amaranth',
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: GridView.builder(
                    physics: const ClampingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                    ),
                    itemCount: _languages.length,
                    itemBuilder: (context, index) {
                      final language = _languages[index];
                      final isSelected = _selectedLanguage == language['code'];
                      return _buildLanguageCard(
                        language: language,
                        isSelected: isSelected,
                      );
                    },
                  ),
                ),
                // Thin gap — less empty black strip above native.
                SizedBox(height: 8.h),
                const _FirstLanguageNativeAd(),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: _selectedLanguage != null
                        ? () async {
                            final localeService = Provider.of<LocaleService>(
                              context,
                              listen: false,
                            );
                            await localeService.setLocaleByCode(
                              _selectedLanguage!,
                            );
                            if (context.mounted) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RealOnboardingFlow(),
                                ),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkPrimary,
                      foregroundColor: AppColors.textWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.continue_,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Amaranth',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required Map<String, dynamic> language,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = language['code'] as String;
        });
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.navBarBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.darkPrimary
                : AppColors.textGrey.withOpacity(0.35),
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.darkPrimary.withOpacity(0.25),
                    blurRadius: 8.r,
                    offset: Offset(0, 2.h),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            children: [
              // Flag Icon
              SizedBox(
                width: 32.w,
                height: 32.h,
                child: (language['isPng'] as bool? ?? false)
                    ? Image.asset(
                        language['imageAsset'] as String,
                        width: 32.w,
                        height: 32.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, _, __) => Text(
                          language['name'] as String,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : SvgPicture.asset(
                        language['imageAsset'] as String,
                        width: 32.w,
                        height: 32.h,
                        fit: BoxFit.contain,
                        placeholderBuilder: (context) =>
                            const SizedBox.shrink(),
                        errorBuilder: (context, _, __) => Text(
                          language['name'] as String,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
              SizedBox(width: 12.w),
              // Language Name
              Expanded(
                child: Text(
                  language['nativeName'] as String,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? AppColors.darkPrimary
                        : AppColors.textWhite,
                    fontFamily: 'Amaranth',
                  ),
                ),
              ),
              // Selection Indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.darkPrimary,
                  size: 20.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FirstLanguageNativeAd extends StatefulWidget {
  const _FirstLanguageNativeAd();

  @override
  State<_FirstLanguageNativeAd> createState() => _FirstLanguageNativeAdState();
}

class _FirstLanguageNativeAdState extends State<_FirstLanguageNativeAd> {
  NativeAd? _nativeAd;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final unitId = AdmobIds.nativeUnitId();
    if (unitId.isEmpty) return;

    final ad = NativeAd(
      adUnitId: unitId,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: AppColors.navBarBackground,
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
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
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
    if (!_loaded || ad == null) return SizedBox(height: 4.h);

    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(
          width: double.infinity,
          height: 81.h,
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }
}
