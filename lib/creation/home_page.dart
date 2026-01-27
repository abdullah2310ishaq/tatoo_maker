import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../providers/theme_provider.dart';
import '../widgets/inkvision_underline.dart';
import 'loading_screen.dart';
import 'explore_detail_screen.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onMenuTap;

  const HomePage({super.key, this.onMenuTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _selectedStyleIndex;
  final TextEditingController _dreamInkController = TextEditingController();
  static const int _maxCharacters = 250;
  bool _showTutorialOverlay = false;
  final GlobalKey _dreamInkCardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkTutorialStatus();
    // Wait for layout to complete before showing overlay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _showTutorialOverlay) {
        setState(() {
          // Trigger rebuild to get card position
        });
      }
    });
  }

  Future<void> _checkTutorialStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tutorialShown = prefs.getBool('home_tutorial_shown') ?? false;
      if (!tutorialShown && mounted) {
        setState(() {
          _showTutorialOverlay = true;
        });
      }
    } catch (e) {
      // On error, don't show tutorial
      debugPrint('Error checking tutorial status: $e');
    }
  }

  Map<String, String> _stylePrompts(AppLocalizations l10n) => {
    'Wolf': l10n.tattooStylePromptWolf,
    'Abstract': l10n.tattooStylePromptAbstract,
    'Lion': l10n.tattooStylePromptLion,
    'Eagle': l10n.tattooStylePromptEagle,
    'Spider': l10n.tattooStylePromptSpider,
    'Butterfly': l10n.tattooStylePromptButterfly,
    'Dragon': l10n.tattooStylePromptDragon,
    'Unicorn': l10n.tattooStylePromptUnicorn,
    'Floral': l10n.tattooStylePromptFloral,
  };

  List<_TattooStyleItem> get _styles {
    final themeProvider = ThemeProvider.of(context);
    final isDark =
        themeProvider?.isDarkTheme ??
        Theme.of(context).brightness == Brightness.dark;
    return [
      const _TattooStyleItem(label: 'Dragon', assetPath: 'assets/dragon.png'),
      const _TattooStyleItem(label: 'Unicorn', assetPath: 'assets/unicorn.png'),
      const _TattooStyleItem(label: 'Floral', assetPath: 'assets/floral.png'),
      _TattooStyleItem(
        label: 'Abstract',
        assetPath: isDark
            ? 'assets/abstract_dark.png'
            : 'assets/abstract_light.png',
      ),
      _TattooStyleItem(
        label: 'Butterfly',
        assetPath: isDark
            ? 'assets/butterfly_dark.png'
            : 'assets/butterfly_light.png',
      ),
      _TattooStyleItem(
        label: 'Eagle',
        assetPath: isDark ? 'assets/eagle_dark.png' : 'assets/eagle_light.png',
      ),
      _TattooStyleItem(
        label: 'Lion',
        assetPath: isDark ? 'assets/lion_dark.png' : 'assets/lion_light.png',
      ),
      _TattooStyleItem(
        label: 'Spider',
        assetPath: isDark
            ? 'assets/spider_dark.png'
            : 'assets/spider_light.png',
      ),
      _TattooStyleItem(
        label: 'Wolf',
        assetPath: isDark ? 'assets/wolf_dark.png' : 'assets/wolf_light.png',
      ),
    ];
  }

  @override
  void dispose() {
    _dreamInkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    // Add padding for floating navbar (navbar height ~80px + bottom padding + extra spacing for visibility)
    final navbarHeight = 80.h + bottomPadding + 20.h;

    return SafeArea(
      child: Stack(
        children: [
          Container(
            decoration: isDark
                ? ThemeManager.darkModeBackgroundGradient
                : ThemeManager.lightModeBackground,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                bottom: navbarHeight, // Ensure content scrolls above navbar
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  // Header: menu + InkVision + notification (single line)
                  _buildHeader(isDark: isDark),
                  SizedBox(height: 30.h),
                  // Describe Your Dream Ink card
                  _buildDreamInkCard(),
                  SizedBox(height: 32.h),
                  // Tattoo style selector section (includes Generate button)
                  _buildTattooStyleSection(),
                  SizedBox(height: 32.h),
                  // Explore Inspiration section
                  _buildExploreInspirationSection(),
                  SizedBox(
                    height: 40.h,
                  ), // Extra spacing to ensure last cards are fully visible
                ],
              ),
            ),
          ),
          // Tutorial Overlay
          if (_showTutorialOverlay) _buildTutorialOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeader({required bool isDark}) {
    final iconColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final buttonBgColor = isDark
        ? AppColors.buttonBackground
        : AppColors.textGrey.withOpacity(0.1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Menu button
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: buttonBgColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/one.svg',
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              placeholderBuilder: (context) =>
                  Icon(Icons.menu, color: iconColor, size: 24.sp),
            ),
            onPressed: widget.onMenuTap,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'InkVision',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textWhite
                      : AppColors.darkBackground,
                  fontFamily: 'Tomorrow',
                ),
              ),
              SizedBox(height: 6.h),
              InkVisionUnderline(width: 120.w, height: 3.h),
            ],
          ),
        ),
        // Notification button
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: buttonBgColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/two.svg',
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              placeholderBuilder: (context) => Icon(
                Icons.notifications_outlined,
                color: iconColor,
                size: 24.sp,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildDreamInkCard() {
    final l10n = AppLocalizations.of(context)!;
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

    return SizedBox(
      key: _dreamInkCardKey,
      height: 280.h,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.titleGradientStart, width: 1.w),
          color: cardBgColor,
          gradient: cardGradient,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Stack(
              children: [
                // Orange glow: clipped to the same border radius, anchored to corner
                if (isDark)
                  Positioned(
                    // Push slightly outside so it visually starts from the corner.
                    top: -60.h,
                    right: -60.w,
                    child: IgnorePointer(
                      child: Container(
                        width: 180.w,
                        height: 180.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            center: Alignment.topRight,
                            radius: 0.9,
                            colors: [
                              AppColors.cardGlowStart,
                              AppColors.cardGlowEnd,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                // Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeDescribeYourDreamInk,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Amaranth',
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Scrollable text input
                    Expanded(
                      child: TextField(
                        controller: _dreamInkController,
                        maxLength: _maxCharacters,
                        maxLines: null,
                        style: TextStyle(fontSize: 14.sp, color: textColor),
                        decoration: InputDecoration(
                          hintText: l10n.homeDreamInkHint,
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
                    SizedBox(height: 12.h),
                    // Divider
                    Divider(
                      color: AppColors.textGrey.withOpacity(0.3),
                      thickness: 1.h,
                    ),
                    SizedBox(height: 12.h),
                    // Footer with Inspiration and character count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FutureBuilder<bool>(
                              future: _checkAssetExists(
                                'assets/inspiration.svg',
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data == true) {
                                  return SvgPicture.asset(
                                    'assets/inspiration.svg',
                                    width: 22.w,
                                    height: 22.h,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.textGrey,
                                      BlendMode.srcIn,
                                    ),
                                  );
                                }
                                return Icon(
                                  Icons.casino_outlined,
                                  size: 22.sp,
                                  color: AppColors.textGrey,
                                );
                              },
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              l10n.homeInspiration,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${_maxCharacters - _dreamInkController.text.length} ${l10n.homeCharactersRemaining}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTattooStyleSection() {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeTattooStyle,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w300,
            color: textColor,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 190.h,
          child: ListView.separated(
            key: ValueKey(ThemeProvider.of(context)?.isDarkTheme ?? false),
            scrollDirection: Axis.horizontal,
            itemCount: _styles.length,
            separatorBuilder: (_, __) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              final item = _styles[index];
              final bool isSelected = _selectedStyleIndex == index;
              return _buildStyleCard(item, index, isSelected);
            },
          ),
        ),
        SizedBox(height: 24.h),
        // Generate button always visible in tattoo style section
        _buildGenerateButton(),
      ],
    );
  }

  String _getLocalizedStyleLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'Dragon':
        return l10n.styleDragon;
      case 'Unicorn':
        return l10n.styleUnicorn;
      case 'Floral':
        return l10n.styleFloral;
      case 'Abstract':
        return l10n.styleAbstract;
      case 'Butterfly':
        return l10n.styleButterfly;
      case 'Eagle':
        return l10n.styleEagle;
      case 'Lion':
        return l10n.styleLion;
      case 'Spider':
        return l10n.styleSpider;
      case 'Wolf':
        return l10n.styleWolf;
      default:
        return key;
    }
  }

  Widget _buildStyleCard(_TattooStyleItem item, int index, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final stylePrompts = _stylePrompts(l10n);
    final double width = isSelected ? 150.w : 130.w;
    final Color borderColor = isSelected
        ? AppColors.navBarActive
        : AppColors.cardGradientEnd;
    final cardBgColor = isDark
        ? const Color(0xFF151411)
        : AppColors.lightCardBackground;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final localizedLabel = _getLocalizedStyleLabel(item.label, l10n);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.4.w),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          setState(() {
            // Toggle selection: tap again to unselect
            if (_selectedStyleIndex == index) {
              _selectedStyleIndex = null;
            } else {
              _selectedStyleIndex = index;
              // Auto-fill text only if empty or if current text matches a prompt
              final selectedStyle = _styles[index];
              if (stylePrompts.containsKey(selectedStyle.label)) {
                final currentText = _dreamInkController.text.trim();
                final isEmpty = currentText.isEmpty;
                // Check if current text matches any prompt (was auto-filled)
                final isPromptText = stylePrompts.values.any(
                  (prompt) => prompt.trim() == currentText,
                );

                // Only override if empty or if it's a prompt text (not user-written)
                if (isEmpty || isPromptText) {
                  _dreamInkController.text = stylePrompts[selectedStyle.label]!;
                }
              }
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(item.assetPath, fit: BoxFit.contain),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                localizedLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExploreInspirationSection() {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;

    final List<Map<String, String?>> inspirationItems = [
      {
        'title': l10n.exploreTitleGothqueen,
        'prompt': l10n.explorePromptGothqueen,
        'bigImage': 'assets/explore/gothbig.png',
        'smallImage': 'assets/explore/gothsmall.png',
      },
      {
        'title': l10n.exploreTitleFloral,
        'prompt': l10n.explorePromptFloral,
        'bigImage': 'assets/explore/floralbig.png',
        'smallImage': null,
      },
      {
        'title': l10n.exploreTitleSkullWithFedoraAndPipe,
        'prompt': l10n.explorePromptSkullWithFedoraAndPipe,
        'bigImage': 'assets/explore/skullbig.png',
        'smallImage': 'assets/explore/skullsmall.png',
      },
      {
        'title': l10n.exploreTitleElegantSnakeTattoo,
        'prompt': l10n.explorePromptElegantSnakeTattoo,
        'bigImage': 'assets/explore/snakebig.png',
        'smallImage': 'assets/explore/snakesmall.png',
      },
      {
        'title': l10n.exploreTitleFeatherAndBirdsInFlight,
        'prompt': l10n.explorePromptFeatherAndBirdsInFlight,
        'bigImage': 'assets/explore/featherbig.png',
        'smallImage': 'assets/explore/feathersmall.png',
      },
      {
        'title': l10n.exploreTitleRainyBatWithCelestialStars,
        'prompt': l10n.explorePromptRainyBatWithCelestialStars,
        'bigImage': 'assets/explore/batbig.png',
        'smallImage': 'assets/explore/batsmall.png',
      },
      {
        'title': l10n.exploreTitleElegantBlackCatSilhouetteDesign,
        'prompt': l10n.explorePromptElegantBlackCatSilhouetteDesign,
        'bigImage': 'assets/explore/catbig.png',
        'smallImage': 'assets/explore/catsmall.png',
      },
      {
        'title': l10n.exploreTitleRedRoseTattooDesign,
        'prompt': l10n.explorePromptRedRoseTattooDesign,
        'bigImage': 'assets/explore/rosebig.png',
        'smallImage': 'assets/explore/rosesmall.png',
      },
      {
        'title': l10n.exploreTitleBlackInfinityArrowTattoo,
        'prompt': l10n.explorePromptBlackInfinityArrowTattoo,
        'bigImage': 'assets/explore/infinitybig.png',
        'smallImage': 'assets/explore/infinitysmall.png',
      },
      {
        'title': l10n.exploreTitleBlackScorpionTattooDesign,
        'prompt': l10n.explorePromptBlackScorpionTattooDesign,
        'bigImage': 'assets/explore/scorpionbig.png',
        'smallImage': 'assets/explore/scorpionsmall.png',
      },
      {
        'title': l10n.exploreTitleCrescentMoonAndStarTattoo,
        'prompt': l10n.explorePromptCrescentMoonAndStarTattoo,
        'bigImage': 'assets/explore/moonbig.png',
        'smallImage': 'assets/explore/moonsmall.png',
      },
      {
        'title': l10n.exploreTitleSleepingPandaTattoo,
        'prompt': l10n.explorePromptSleepingPandaTattoo,
        'bigImage': 'assets/explore/pandabig.png',
        'smallImage': 'assets/explore/pandasmall.png',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeExploreInspiration,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w300,
            color: textColor,
          ),
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 16.w,
            childAspectRatio: 0.65,
          ),
          itemCount: inspirationItems.length,
          itemBuilder: (context, index) {
            final item = inspirationItems[index];
            return _buildInspirationCard(
              item['title']!,
              item['prompt']!,
              item['bigImage']!,
              item['smallImage'],
            );
          },
        ),
      ],
    );
  }

  Widget _buildInspirationCard(
    String title,
    String prompt,
    String bigImagePath,
    String? smallImagePath,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExploreDetailScreen(
              title: title,
              prompt: prompt,
              bigImagePath: bigImagePath,
              smallImagePath: smallImagePath,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFFE8B3A), width: 2.w),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.asset(
            bigImagePath,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.cardGradientStart,
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: AppColors.textGrey,
                    size: 24.sp,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _checkAssetExists(String path) async {
    try {
      await DefaultAssetBundle.of(context).load(path);
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildGenerateButton() {
    final l10n = AppLocalizations.of(context)!;
    final bool enabled =
        _selectedStyleIndex != null &&
        _dreamInkController.text.trim().isNotEmpty;

    return GestureDetector(
      onTap: enabled
          ? () {
              // Navigate to loading screen with selected style asset
              final selectedStyle = _selectedStyleIndex != null
                  ? _styles[_selectedStyleIndex!]
                  : null;
              final assetPath = selectedStyle?.assetPath;
              final styleName = selectedStyle?.label;
              final promptText = _dreamInkController.text.trim();

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoadingScreen(
                    selectedStyleAsset: assetPath,
                    styleName: styleName,
                    promptText: promptText,
                  ),
                ),
              );
            }
          : null,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFFA6541D) // Burnt orange when enabled
              : const Color(0xFF2A2A2A), // Dark grey when disabled
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: const Color(0xFFA6541D).withOpacity(0.3),
                    blurRadius: 8.r,
                    offset: Offset(0, 4.h),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            l10n.homeGenerate,
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w600,
              color: enabled ? Colors.white : AppColors.textGrey,
              fontFamily: 'Amaranth',
              shadows: enabled
                  ? [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 2.h),
                        blurRadius: 4.r,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialOverlay() {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final safeAreaTop = mediaQuery.padding.top;

    // Get the position of the Dream Ink card relative to screen
    final RenderBox? cardBox =
        _dreamInkCardKey.currentContext?.findRenderObject() as RenderBox?;
    final Offset? cardScreenPosition = cardBox?.localToGlobal(Offset.zero);
    final Size? cardSize = cardBox?.size;

    // If card not laid out yet, show full overlay and retry
    if (cardScreenPosition == null || cardSize == null) {
      // Retry after frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _showTutorialOverlay) {
          setState(() {});
        }
      });

      return GestureDetector(
        onTap: () async {
          await _markTutorialAsShown();
          if (mounted) {
            setState(() {
              _showTutorialOverlay = false;
            });
          }
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: isDark
                ? Colors.black.withOpacity(0.8)
                : Colors.black.withOpacity(0.7),
          ),
        ),
      );
    }

    // Convert screen coordinates to SafeArea-relative coordinates
    // Since overlay Stack is inside SafeArea, we need to adjust
    final cardPosition = Offset(
      cardScreenPosition.dx,
      cardScreenPosition.dy - safeAreaTop,
    );

    // Card rect in SafeArea-relative coordinates - add much more margin to move overlay up
    final cardRect = Rect.fromLTWH(
      cardPosition.dx,
      cardPosition.dy -
          40.h, // Move overlay up much more by adding larger margin at top
      cardSize.width,
      cardSize.height + 1.h, // Extend height to compensate
    );

    return GestureDetector(
      onTap: () async {
        await _markTutorialAsShown();
        if (mounted) {
          setState(() {
            _showTutorialOverlay = false;
          });
        }
      },
      child: Stack(
        children: [
          // Blur overlay with hole for card (exempt container from blur)
          ClipPath(
            clipper: _TutorialOverlayClipper(cardRect: cardRect),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.transparent),
            ),
          ),
          // Semi-transparent overlay with hole for card
          Positioned.fill(
            child: CustomPaint(
              size: screenSize,
              painter: _TutorialOverlayPainter(
                cardRect: cardRect,
                overlayColor: isDark
                    ? Colors.black.withOpacity(0.7)
                    : Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          // Arrow and text positioned below the card (moved up)
          Positioned(
            top: cardPosition.dy + cardSize.height - 38.h,
            left: 0,
            right: 0,
            bottom: 100.h,
            child: Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Arrow pointing up
                  FutureBuilder<bool>(
                    future: _checkAssetExists('assets/arrow.svg'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return SvgPicture.asset(
                          'assets/arrow.svg',
                          width: 60.w,
                          height: 60.h,
                          colorFilter: const ColorFilter.mode(
                            AppColors.titleGradientStart,
                            BlendMode.srcIn,
                          ),
                        );
                      }
                      return Icon(
                        Icons.arrow_upward_rounded,
                        size: 60.sp,
                        color: AppColors.titleGradientStart,
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                  // Text with transparent background (moved up)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 8.h,
                    ),
                    child: Text(
                      l10n.homeTutorialOverlayText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Amaranth',
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _markTutorialAsShown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('home_tutorial_shown', true);
    } catch (e) {
      // Handle error silently
      debugPrint('Error saving tutorial status: $e');
    }
  }
}

/// Custom clipper to exclude card area from blur
class _TutorialOverlayClipper extends CustomClipper<Path> {
  final Rect cardRect;

  _TutorialOverlayClipper({required this.cardRect});

  @override
  Path getClip(Size size) {
    // Create a path covering the entire screen
    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create a path for the card area (hole)
    final cardPath = Path()
      ..addRRect(RRect.fromRectAndRadius(cardRect, const Radius.circular(16)));

    // Combine paths: overlay - card = overlay with hole
    return Path.combine(PathOperation.difference, overlayPath, cardPath);
  }

  @override
  bool shouldReclip(_TutorialOverlayClipper oldClipper) {
    return oldClipper.cardRect != cardRect;
  }
}

/// Custom painter for tutorial overlay that creates a "hole" for the card
class _TutorialOverlayPainter extends CustomPainter {
  final Rect cardRect;
  final Color overlayColor;

  _TutorialOverlayPainter({required this.cardRect, required this.overlayColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Create a path covering the entire screen
    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create a path for the card area (hole) - match card's border radius (16.r)
    final cardPath = Path()
      ..addRRect(RRect.fromRectAndRadius(cardRect, const Radius.circular(16)));

    // Combine paths: overlay - card = overlay with hole
    final combinedPath = Path.combine(
      PathOperation.difference,
      overlayPath,
      cardPath,
    );

    // Draw the overlay with the hole
    final paint = Paint()..color = overlayColor;
    canvas.drawPath(combinedPath, paint);
  }

  @override
  bool shouldRepaint(_TutorialOverlayPainter oldDelegate) {
    return oldDelegate.cardRect != cardRect ||
        oldDelegate.overlayColor != overlayColor;
  }
}

class _TattooStyleItem {
  final String label;
  final String assetPath;

  const _TattooStyleItem({required this.label, required this.assetPath});
}
