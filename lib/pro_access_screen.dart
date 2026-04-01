import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'l10n/app_localizations.dart';
import 'services/billing_service.dart';
import 'utils/colors.dart';

class ProAccessScreen extends StatefulWidget {
  final Widget nextScreen;

  const ProAccessScreen({super.key, required this.nextScreen});

  @override
  State<ProAccessScreen> createState() => _ProAccessScreenState();
}

class _ProAccessScreenState extends State<ProAccessScreen> {
  late final PageController _pageController;
  late final Timer _sliderTimer;
  late final BillingService _billingService;

  Timer? _closeButtonTimer;
  StreamSubscription<BillingPurchaseEvent>? _billingEventsSubscription;

  int _index = 0;
  bool _canClose = false;
  bool _isPurchasing = false;
  bool _isBillingReady = false;
  PlanVariant _selectedPlan = PlanVariant.lifetime;

  void _log(String message) {
    debugPrint('[ProAccessScreen] $message');
  }

  final List<String> _images = const [
    'assets/in_app/in_appone.png',
    'assets/in_app/in_apptwo.png',
    'assets/in_app/in_appthree.png',
    'assets/in_app/in_appfour.png',
    'assets/in_app/in_appfive.png',
  ];

  @override
  void initState() {
    super.initState();
    _log('initState: screen opened.');

    _pageController = PageController();
    _billingService = BillingService();

    _sliderTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      _index = (_index + 1) % _images.length;

      _pageController.animateToPage(
        _index,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    });

    _closeButtonTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() {
        _canClose = true;
      });
    });

    _initializeBilling();
  }

  @override
  void dispose() {
    _sliderTimer.cancel();
    _closeButtonTimer?.cancel();
    _billingEventsSubscription?.cancel();
    unawaited(_billingService.dispose());
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    _log('Navigating to next screen after billing flow.');
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => widget.nextScreen));
  }

  void _closeScreen() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }
    _goNext();
  }

  Future<void> _initializeBilling() async {
    _log('Initializing billing service...');
    try {
      await _billingService.initialize();
    } catch (error, stackTrace) {
      debugPrint('[ProAccessScreen] Billing initialize failed: $error');
      debugPrint('[ProAccessScreen] Billing init stack trace: $stackTrace');
    }
    if (!mounted) return;

    _billingEventsSubscription = _billingService.purchaseEvents.listen(
      _onBillingEvent,
    );

    final trialProduct = _billingService.productForPlan(BillingPlan.freeTrial);
    final lifetimeProduct = _billingService.productForPlan(
      BillingPlan.lifetime,
    );
    _log(
      'Billing products => trial=${trialProduct?.id}:${trialProduct?.price}, lifetime=${lifetimeProduct?.id}:${lifetimeProduct?.price}',
    );

    setState(() {
      _isBillingReady =
          _billingService.isStoreAvailable && _billingService.hasProducts;
    });
    _log('Billing ready=$_isBillingReady');
  }

  String _freeTrialDisplayPrice(AppLocalizations l10n) {
    return _billingService.productForPlan(BillingPlan.freeTrial)?.price ??
        l10n.proAccessPlanWeeklyPrice;
  }

  String _lifetimeDisplayPrice() {
    return _billingService.productForPlan(BillingPlan.lifetime)?.price ?? '--';
  }

  String? _lifetimeOriginalDisplayPrice() {
    final lifetimeProduct = _billingService.productForPlan(
      BillingPlan.lifetime,
    );
    if (lifetimeProduct == null) return null;

    final originalRawPrice = lifetimeProduct.rawPrice / 0.8;
    try {
      return NumberFormat.simpleCurrency(
        name: lifetimeProduct.currencyCode,
      ).format(originalRawPrice);
    } catch (_) {
      return null;
    }
  }

  String _bottomFooterText(AppLocalizations l10n) {
    if (_selectedPlan == PlanVariant.lifetime) {
      final lifetimePrice = _lifetimeDisplayPrice();
      if (lifetimePrice == '--') {
        return l10n.proAccessLifetimeLegalNoPrice;
      }
      return l10n.proAccessLifetimeLegalWithPrice(lifetimePrice);
    }
    return l10n.proAccessLegalNote(_freeTrialDisplayPrice(l10n));
  }

  BillingPlan _toBillingPlan(PlanVariant variant) {
    switch (variant) {
      case PlanVariant.freeTrial:
        return BillingPlan.freeTrial;
      case PlanVariant.lifetime:
        return BillingPlan.lifetime;
    }
  }

  void _onBillingEvent(BillingPurchaseEvent event) {
    if (!mounted) return;
    _log(
      'Billing event => status=${event.status}, productId=${event.productId}',
    );

    switch (event.status) {
      case BillingPurchaseStatus.pending:
        setState(() {
          _isPurchasing = true;
        });
        break;
      case BillingPurchaseStatus.purchased:
        _goNext();
        break;
      case BillingPurchaseStatus.canceled:
      case BillingPurchaseStatus.error:
        setState(() {
          _isPurchasing = false;
        });
        break;
    }
  }

  Future<void> _onContinuePressed() async {
    if (_isPurchasing) return;
    _log('Continue tapped. selectedPlan=$_selectedPlan');

    setState(() {
      _isPurchasing = true;
    });

    // While IDs are placeholders, purchase might fail to launch.
    if (!_isBillingReady) {
      _log('Billing not ready. Falling back to next screen.');
      setState(() {
        _isPurchasing = false;
      });
      _goNext();
      return;
    }

    final bool started = await _billingService.purchasePlan(
      _toBillingPlan(_selectedPlan),
    );
    if (!mounted) return;

    if (!started) {
      _log('Purchase did not start. Falling back to next screen.');
      setState(() {
        _isPurchasing = false;
      });
      _goNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final isArabic =
                Localizations.localeOf(context).languageCode == 'ar';
            final isFreeTrialSelected = _selectedPlan == PlanVariant.freeTrial;
            // Increase image height by ~10% for stronger background presence.
            final imageHeight = screenHeight * 0.67;

            final bottomReservedHeight =
                screenHeight *
                (isArabic
                    ? (isFreeTrialSelected ? 0.16 : 0.16)
                    : (isFreeTrialSelected ? 0.12 : 0.12));
            final headerTopOffset = screenHeight * (isArabic ? 0.235 : 0.275);

            // Gradient should start fading exactly where the text starts.
            final fadeStartFraction = headerTopOffset / screenHeight;
            final fadeMidFraction = (fadeStartFraction + 0.18).clamp(
              fadeStartFraction,
              0.75,
            );

            return Stack(
              children: [
                /// TOP IMAGE SLIDER
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _images.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Image.asset(
                          _images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Container(color: AppColors.darkBackground);
                          },
                        );
                      },
                    ),
                  ),
                ),

                /// GRADIENT OVERLAY
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x00000000),
                          Color(0x00000000),
                          Color(0x99000000),
                          Color(0xE6000000),
                          Color(0xFF000000),
                        ],
                        stops: [
                          0.0,
                          fadeStartFraction,
                          fadeMidFraction,
                          0.60,
                          1.0,
                        ],
                      ),
                    ),
                  ),
                ),

                /// MAIN CONTENT
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      20.w,
                      0,
                      20.w,
                      bottomReservedHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: headerTopOffset),

                        /// TITLE (single line: Get [PRO] Access)
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.proAccessTitleGet,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: isArabic ? 40.sp : 46.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textWhite,
                                  fontFamily: 'Antonio',
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                decoration: BoxDecoration(
                                  color: AppColors.darkPrimary,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  l10n.proAccessTitlePro,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: isArabic ? 40.sp : 46.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textWhite,
                                    fontFamily: 'Antonio',
                                  ),
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Text(
                                l10n.proAccessTitleAccess,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: isArabic ? 40.sp : 46.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textWhite,
                                  fontFamily: 'Antonio',
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 8.h),

                        Text(
                          l10n.proAccessSubtitle,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isArabic ? 22.sp : 25.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textWhite,
                            fontFamily: 'Antonio',
                          ),
                        ),

                        SizedBox(
                          height: _selectedPlan == PlanVariant.freeTrial
                              ? 18.h
                              : 22.h,
                        ),

                        _FeatureRow(
                          text: l10n.proAccessFeatureUnlimitedTattooCreation,
                        ),
                        _FeatureRow(text: l10n.proAccessFeatureFastProcessing),
                        _FeatureRow(text: l10n.proAccessFeatureUnlockAllStyles),
                        _FeatureRow(
                          text: l10n.proAccessFeatureRemoveWatermarks,
                        ),

                        SizedBox(height: 18.h),

                        _PlanCard(
                          variant: PlanVariant.lifetime,
                          leftText: l10n.proAccessPlanLifetimeSubscription,
                          rightText: _lifetimeDisplayPrice(),
                          originalRightText: _lifetimeOriginalDisplayPrice(),
                          verticalPadding: 17.h,
                          isSelected: _selectedPlan == PlanVariant.lifetime,
                          onTap: () {
                            _log('Plan selected: lifetime');
                            setState(() {
                              _selectedPlan = PlanVariant.lifetime;
                            });
                          },
                        ),

                        SizedBox(height: 10.h),

                        _PlanCard(
                          variant: PlanVariant.freeTrial,
                          leftText: l10n.proAccessPlanFreeTrial,
                          rightText: _freeTrialDisplayPrice(l10n),
                          verticalPadding: 17.h,
                          isSelected: _selectedPlan == PlanVariant.freeTrial,
                          onTap: () {
                            _log('Plan selected: free trial');
                            setState(() {
                              _selectedPlan = PlanVariant.freeTrial;
                            });
                          },
                        ),
                        SizedBox(
                          height: _selectedPlan == PlanVariant.freeTrial
                              ? (isArabic ? 30.h : 40.h)
                              : 22.h,
                        ),
                      ],
                    ),
                  ),
                ),

                /// BOTTOM CTA
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 1, 20.w, 10.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: _onContinuePressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: _isPurchasing
                                ? SizedBox(
                                    width: 22.sp,
                                    height: 22.sp,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.textWhite,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          (_selectedPlan ==
                                                      PlanVariant.freeTrial
                                                  ? l10n.proAccessContinueForFree
                                                  : l10n.continue_)
                                              .toUpperCase(),
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize:
                                                _selectedPlan ==
                                                    PlanVariant.freeTrial
                                                ? 16.sp
                                                : 18.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textWhite,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.textWhite,
                                        size: 22.sp,
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        SizedBox(height: 6.h),
                        Text(
                          l10n.proAccessAutoRenewableCancelAnytime,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textGrey.withOpacity(0.85),
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 6.h),

                        Text(
                          _bottomFooterText(l10n),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textGrey.withOpacity(0.85),
                            height: 1.4,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// CLOSE BUTTON (keep on top so taps are never blocked)
                Positioned(
                  top: 12.h,
                  left: 16.w,
                  child: IgnorePointer(
                    ignoring: !_canClose,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: _canClose ? 1 : 0,
                      child: IconButton(
                        onPressed: _closeScreen,
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.all(8.w),
                          minimumSize: Size(42.w, 42.w),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: Icon(
                          Icons.close,
                          color: AppColors.textWhite,
                          size: 32.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

enum PlanVariant { freeTrial, lifetime }

class _PlanCard extends StatelessWidget {
  final PlanVariant variant;
  final String leftText;
  final String? rightText;
  final String? originalRightText;
  final bool isSelected;
  final VoidCallback? onTap;
  final double? verticalPadding;

  const _PlanCard({
    required this.variant,
    required this.leftText,
    this.rightText,
    this.originalRightText,
    this.isSelected = false,
    this.onTap,
    this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isFree = variant == PlanVariant.freeTrial;
    final showLifetimeBadge = variant == PlanVariant.lifetime;
    final horizontalPadding = isSelected ? 16.w : 15.w;
    final resolvedVerticalPadding =
        (verticalPadding ?? 13.h) + (isSelected ? 2.h : 0);
    final leftTextSize = isSelected ? 14.sp : 13.sp;
    final rightTextSize = isSelected ? 13.sp : 12.sp;
    final borderColor = isSelected
        ? AppColors.darkPrimary
        : AppColors.navBarBackground.withOpacity(0);
    final borderWidth = isSelected ? 1.6.w : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: resolvedVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.darkBackground.withOpacity(0.01)
              : (isFree
                    ? AppColors.navBarBackground
                    : AppColors.navBarBackground),
          borderRadius: BorderRadius.circular(isSelected ? 12.r : 12.r),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    leftText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: leftTextSize,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.darkPrimary
                          : AppColors.textWhite,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                if (rightText != null)
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (originalRightText != null)
                          Text(
                            originalRightText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textGrey.withOpacity(0.9),
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppColors.textGrey.withOpacity(
                                0.9,
                              ),
                              fontFamily: 'Inter',
                            ),
                          ),
                        Text(
                          rightText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: rightTextSize,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.textWhite
                                : AppColors.textGrey.withOpacity(0.95),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (showLifetimeBadge)
              Positioned(
                top: -42.h,
                right: -5.w,
                child: IgnorePointer(
                  child: Image.asset(
                    'assets/splash/20off.png',
                    width: 50.w,
                    height: 50.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;

  const _FeatureRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final rowWidth = constraints.maxWidth * 0.55;

          return SizedBox(
            width: rowWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: AppColors.darkPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 14.sp,
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textWhite,
                      fontFamily: 'Antonio',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
