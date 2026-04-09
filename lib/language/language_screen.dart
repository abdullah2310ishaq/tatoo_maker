import 'package:flutter/foundation.dart';
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
import '../utils/theme_manager.dart';

/// Language selection screen - Supports both light and dark themes
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.textWhite : AppColors.textPrimary,
            size: 22.sp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.chooseALanguage,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textWhite : AppColors.textPrimary,
            fontFamily: 'Amaranth',
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: ElevatedButton(
              onPressed: _selectedLanguage != null
                  ? () async {
                      final localeService = Provider.of<LocaleService>(
                        context,
                        listen: false,
                      );
                      await localeService.setLocaleByCode(_selectedLanguage!);
                      if (context.mounted) {
                        // Go back to HomeShell (root) after changing language
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                elevation: 0,
              ),
              child: Text(
                AppLocalizations.of(context)!.next,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Amaranth',
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: isDark
            ? ThemeManager.darkModeBackgroundGradient
            : ThemeManager.lightModeBackground,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: GridView.builder(
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
                      isDark: isDark,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 28.h),
              child: Transform.translate(
                offset: Offset(0, -15.h),
                child: _LanguageScreenNativeAd(isDark: isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required Map<String, dynamic> language,
    required bool isSelected,
    required bool isDark,
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
          color: isDark
              ? AppColors.buttonBackground
              : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.lightPrimary
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.lightPrimary.withOpacity(0.25),
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
                            color: isDark ? AppColors.textGrey : Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Amaranth',
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
                            color: isDark ? AppColors.textGrey : Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Amaranth',
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
                        ? AppColors.lightPrimary
                        : (isDark
                              ? AppColors.textWhite
                              : AppColors.textPrimary),
                    fontFamily: 'Amaranth',
                  ),
                ),
              ),
              // Selection Indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.lightPrimary,
                  size: 20.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageScreenNativeAd extends StatefulWidget {
  const _LanguageScreenNativeAd({required this.isDark});

  final bool isDark;

  @override
  State<_LanguageScreenNativeAd> createState() =>
      _LanguageScreenNativeAdState();
}

class _LanguageScreenNativeAdState extends State<_LanguageScreenNativeAd> {
  NativeAd? _nativeAd;
  bool _loaded = false;
  bool _loggedLayoutOnce = false;

  static void _log(String message) {
    debugPrint('[NativeAd][LanguageScreen] $message');
  }

  @override
  void initState() {
    super.initState();
    _log('initState isDark=${widget.isDark} → _load()');
    _load();
  }

  @override
  void didUpdateWidget(covariant _LanguageScreenNativeAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDark == widget.isDark) return;
    _log('didUpdateWidget theme changed → reload ad');
    _loggedLayoutOnce = false;
    _nativeAd?.dispose();
    _nativeAd = null;
    _loaded = false;
    _load();
  }

  void _load() {
    final unitId = AdmobIds.nativeUnitId();
    if (unitId.isEmpty) {
      _log('skip load: native unit id is empty');
      return;
    }

    _log('load() factoryId=listTileLanguage unitIdLen=${unitId.length}');

    final ad = NativeAd(
      adUnitId: unitId,
      request: const AdRequest(),
      factoryId: 'listTileLanguage',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _log('onAdLoaded');
          if (!mounted) return;
          setState(() {
            _nativeAd = ad as NativeAd;
            _loaded = true;
          });
        },
        onAdFailedToLoad: (ad, LoadAdError error) {
          _log(
            'onAdFailedToLoad code=${error.code} domain=${error.domain} '
            'message=${error.message}',
          );
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
    _log('dispose');
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    if (isPro) return const SizedBox.shrink();

    final ad = _nativeAd;
    if (!_loaded || ad == null) return SizedBox(height: 108.h);

    // Compact native_ads_language.xml (≈40dp CTA); tweak XML + slot together.
    final slotH = 108.h;
    if (kDebugMode && !_loggedLayoutOnce) {
      _loggedLayoutOnce = true;
      _log(
        'AdWidget slot height=${slotH.toStringAsFixed(1)} '
        'screenH=${MediaQuery.sizeOf(context).height.toStringAsFixed(0)}',
      );
    }

    final cardColor = widget.isDark
        ? AppColors.inputCardDarkBackground
        : AppColors.lightBackground;

    final radius = BorderRadius.circular(14.r);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
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
      ),
    );
  }
}
