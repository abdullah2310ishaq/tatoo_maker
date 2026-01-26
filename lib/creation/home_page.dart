import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  bool _showTutorialOverlay = true; // Show on each restart for now
  final GlobalKey _dreamInkCardKey = GlobalKey();

  // Style prompts map
  static const Map<String, String> _stylePrompts = {
    'Wolf':
        'Minimal tribal wolf tattoo drawn with bold white lines , abstract sharp curves, clean line-art, tattoo flash style.',
    'Abstract':
        'Tribal abstract tattoo symbolizing inner strength and resilience, flowing sharp curves rising upward, bold confident line-art, powerful vertical composition, minimalist tribal style, solid white ink',
    'Lion':
        'Majestic lion tattoo representing courage and leadership, calm powerful expression, detailed mane, strong shading, artistic tattoo design, solid white ink, high contrast',
    'Eagle':
        'Eagle tattoo in mid-flight symbolizing freedom and vision, wide wings, sharp feather detail, dynamic motion, bold tattoo art, solid white ink, high contrast',
    'Spider':
        'Detailed spider tattoo symbolizing patience and control, realistic anatomy, clean web elements, dark artistic tattoo style, solid white ink, high contrast',
    'Butterfly':
        'Delicate butterfly tattoo representing transformation and growth, detailed wings, soft shading, elegant tattoo illustration, solid white ink, high contrast.',
    'Dragon':
        'Fantasy dragon tattoo design, coiled body, dark scales, glowing orange wings, sharp horns, bold clean lines',
    'Unicorn':
        'Unicorn head tattoo design, golden horn, flowing rainbow mane, detailed fantasy illustration',
    'Floral':
        'Pastel floral bouquet, peach & blush roses, wildflowers, golden foliage, cascading ribbons, asymmetrical teardrop, romantic vintage, soft lighting, high realism, dark background.',
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
    // Add padding for floating navbar (approximately 80px height + spacing)
    final navbarHeight = 80.h + bottomPadding;

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
                  SizedBox(height: 16.h),
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
                  fontFamily: 'Amaranth',
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
                      'Describe Your Dream Ink',
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
                          hintText: 'Tell us what you envision...',
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
                              'Inspiration',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${_maxCharacters - _dreamInkController.text.length} characters remaining',
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tattoo Style',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
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

  Widget _buildStyleCard(_TattooStyleItem item, int index, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double width = isSelected ? 150.w : 130.w;
    final Color borderColor = isSelected
        ? AppColors.navBarActive
        : AppColors.cardGradientEnd;
    final cardBgColor = isDark
        ? const Color(0xFF151411)
        : AppColors.lightCardBackground;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;

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
              if (_stylePrompts.containsKey(selectedStyle.label)) {
                final currentText = _dreamInkController.text.trim();
                final isEmpty = currentText.isEmpty;
                // Check if current text matches any prompt (was auto-filled)
                final isPromptText = _stylePrompts.values.any(
                  (prompt) => prompt.trim() == currentText,
                );

                // Only override if empty or if it's a prompt text (not user-written)
                if (isEmpty || isPromptText) {
                  _dreamInkController.text =
                      _stylePrompts[selectedStyle.label]!;
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
                item.label,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;

    final List<Map<String, String?>> inspirationItems = [
      {
        'title': 'Gothqueen',
        'prompt':
            'Black and grey gothic queen tattoo, bald female face, ornate crown, geometric linework, realistic shading, symmetrical, high detail',
        'bigImage': 'assets/explore/gothbig.png',
        'smallImage': 'assets/explore/gothsmall.png',
      },
      {
        'title': 'Floral',
        'prompt':
            'Beautiful floral tattoo design with intricate petals and leaves, natural flowing curves, botanical tattoo style, detailed line-work, solid white ink, high contrast',
        'bigImage': 'assets/explore/floralbig.png',
        'smallImage': null,
      },
      {
        'title': 'Skull with fedora and pipe',
        'prompt':
            'Realistic black & grey skull tattoo, side-profile skull wearing a classic fedora, smoking a curved pipe with soft upward smoke, vintage noir style, detailed bone & teeth texture, smooth gradient shading with dotwork and soft realism, fine-needle detailing, high-contrast blacks, professional tattoo artwork.',
        'bigImage': 'assets/explore/skullbig.png',
        'smallImage': 'assets/explore/skullsmall.png',
      },
      {
        'title': 'Elegant snake tattoo',
        'prompt':
            'Ultra-detailed black & white aggressive snake tattoo, open mouth with long fangs and forked tongue, flowing coiled body, fine-line detailed scales, deep black shading, strong contrast, realistic depth, clean negative space, traditional engraving × modern realism, razor-sharp outlines, monochrome ink, no background, professional tattoo flash, forearm or sleeve ready.',
        'bigImage': 'assets/explore/snakebig.png',
        'smallImage': 'assets/explore/snakesmall.png',
      },
      {
        'title': 'Feather and birds in flight',
        'prompt':
            'Ultra-detailed black & white feather tattoo, elegant realistic feather with fine linework, symmetrical barbs and sharp spine, smooth dotwork gradient shading, minimal premium fineline style, small bird silhouettes flowing upward, balanced composition, razor-sharp outlines, high-contrast black ink, modern tattoo realism, monochrome only, no background on white canvas, professional flash, stencil-ready.',
        'bigImage': 'assets/explore/featherbig.png',
        'smallImage': 'assets/explore/feathersmall.png',
      },
      {
        'title': 'Rainy bat with celestial stars',
        'prompt':
            'Symmetrical bat tattoo with fully spread wings, solid black body, wings filled with smooth rainbow gradient (purple to blue, green, yellow, orange), clean bold outlines with fine linework, subtle dotwork shading, surrounded by small stars and dots, two four-pointed stars above and below, mystical celestial vibe, modern neo-traditional style, high contrast, sharp detail.',
        'bigImage': 'assets/explore/batbig.png',
        'smallImage': 'assets/explore/batsmall.png',
      },
      {
        'title': 'Elegant black cat silhouette design',
        'prompt':
            'A minimalist black cat tattoo design in elegant abstract style, side-profile sitting cat with a long flowing curved tail, smooth sweeping lines and sharp tapered edges, solid black ink with subtle gradient shading for depth, geometric and fluid shapes forming the body, delicate whisker lines extending from the face, modern fine-line tattoo style, high contrast, clean negative space, sophisticated and artistic look, tattoo flash art',
        'bigImage': 'assets/explore/catbig.png',
        'smallImage': 'assets/explore/catsmall.png',
      },
      {
        'title': 'Red rose tattoo design',
        'prompt':
            'Realistic red rose tattoo, single blooming rose with layered petals, rich deep red color, fine detailed petal texture, subtle gradient shading, natural green stem with small thorns and two detailed leaves, clean crisp outlines, soft realism tattoo style, high contrast, smooth color blending, professional tattoo flash quality, isolated rose only',
        'bigImage': 'assets/explore/rosebig.png',
        'smallImage': 'assets/explore/rosesmall.png',
      },
      {
        'title': 'Black infinity arrow tattoo',
        'prompt':
            'Realistic Minimalist black infinity arrow tattoo, smooth continuous loop with sharp arrow, clean bold linework, high-contrast solid black ink, modern minimal style, monochrome, stencil-ready.',
        'bigImage': 'assets/explore/infinitybig.png',
        'smallImage': 'assets/explore/infinitysmall.png',
      },
      {
        'title': 'Black scorpion tattoo design',
        'prompt':
            'Realistic minimalist black scorpion tattoo design, bold solid black ink, sharp clean linework, symmetrical tribal-inspired detailing, high contrast, smooth curves, modern tattoo style, stencil-ready, isolated on plain background, ultra-detailed, professional tattoo flash',
        'bigImage': 'assets/explore/scorpionbig.png',
        'smallImage': 'assets/explore/scorpionsmall.png',
      },
      {
        'title': 'Crescent moon and star tattoo',
        'prompt':
            'Minimalist black ink tattoo, fine-line style, upward crescent moon with solid black fill, small four-point star above aligned vertically, subtle dot accents, celestial and mystical aesthetic, simple geometry, balanced spacing, clean background, precise linework, high contrast, timeless minimal tattoo design',
        'bigImage': 'assets/explore/moonbig.png',
        'smallImage': 'assets/explore/moonsmall.png',
      },
      {
        'title': 'Sleeping panda tattoo',
        'prompt':
            'Minimalist cute panda tattoo, tiny sleeping panda lying on its side, simple rounded shape, solid black and white ink, soft smooth fills, minimal facial details, clean edges, modern minimalist tattoo style, monochrome, no background, white canvas, stencil-ready.',
        'bigImage': 'assets/explore/pandabig.png',
        'smallImage': 'assets/explore/pandasmall.png',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore Inspiration',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
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
            'Generate',
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _showTutorialOverlay = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Stack(
          children: [
            // Arrow and text in a bordered container positioned below the card
            Positioned(
              top: MediaQuery.of(context).size.height * 0.34,
              left: 20.w,
              right: 20.w,
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(color: Colors.transparent),
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
                    SizedBox(height: 16.h),
                    // Text
                    Text(
                      'Describe the tattoo you have in mind, or tap \'Inspiration\' for ideas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Amaranth',
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TattooStyleItem {
  final String label;
  final String assetPath;

  const _TattooStyleItem({required this.label, required this.assetPath});
}
