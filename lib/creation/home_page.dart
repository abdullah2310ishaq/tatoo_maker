import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/colors.dart';
import '../widgets/inkvision_underline.dart';

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

  final List<_TattooStyleItem> _styles = const [
    _TattooStyleItem(label: 'Dragon', assetPath: 'assets/dragon.png'),
    _TattooStyleItem(label: 'Unicorn', assetPath: 'assets/unicorn.png'),
    _TattooStyleItem(label: 'Floral', assetPath: 'assets/floral.png'),
  ];

  @override
  void dispose() {
    _dreamInkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.navBarBackground, AppColors.darkBackground],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Header: menu + InkVision + notification (single line)
                  _buildHeader(isDark: true),
                  const SizedBox(height: 30),
                  // Describe Your Dream Ink card
                  _buildDreamInkCard(),
                  const SizedBox(height: 32),
                  // Tattoo style selector section (includes Generate button)
                  _buildTattooStyleSection(),
                  const SizedBox(height: 32),
                  // Explore Inspiration section
                  _buildExploreInspirationSection(),
                  const SizedBox(height: 16),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Menu button
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.buttonBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/one.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.textWhite,
                BlendMode.srcIn,
              ),
              placeholderBuilder: (context) =>
                  const Icon(Icons.menu, color: AppColors.textWhite),
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
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textWhite
                      : AppColors.buttonBackground,
                  fontFamily: 'Amaranth',
                ),
              ),
              const SizedBox(height: 6),
              const InkVisionUnderline(width: 120, height: 3),
            ],
          ),
        ),
        // Notification button
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.buttonBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/two.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.textWhite,
                BlendMode.srcIn,
              ),
              placeholderBuilder: (context) => const Icon(
                Icons.notifications_outlined,
                color: AppColors.textWhite,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildDreamInkCard() {
    return SizedBox(
      key: _dreamInkCardKey,
      height: 280,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.titleGradientStart, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.cardGradientStart,
                  AppColors.cardGradientEnd,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Orange glow: clipped to the same border radius, anchored to corner
                Positioned(
                  // Push slightly outside so it visually starts from the corner.
                  top: -60,
                  right: -60,
                  child: IgnorePointer(
                    child: Container(
                      width: 180,
                      height: 180,
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
                    const Text(
                      'Describe Your Dream Ink',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite,
                        fontFamily: 'Amaranth',
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Scrollable text input
                    Expanded(
                      child: TextField(
                        controller: _dreamInkController,
                        maxLength: _maxCharacters,
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textWhite,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Tell us what you envision...',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: AppColors.textGrey,
                          ),
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Divider
                    Divider(
                      color: AppColors.textGrey.withOpacity(0.3),
                      thickness: 1,
                    ),
                    const SizedBox(height: 12),
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
                                    width: 22,
                                    height: 22,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.textGrey,
                                      BlendMode.srcIn,
                                    ),
                                  );
                                }
                                return const Icon(
                                  Icons.casino_outlined,
                                  size: 22,
                                  color: AppColors.textGrey,
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Inspiration',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${_maxCharacters - _dreamInkController.text.length} characters remaining',
                          style: TextStyle(
                            fontSize: 12,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tattoo Style',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textWhite,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textGrey,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Text(
                'View All',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              label: const Icon(Icons.chevron_right, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _styles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = _styles[index];
              final bool isSelected = _selectedStyleIndex == index;
              return _buildStyleCard(item, index, isSelected);
            },
          ),
        ),
        const SizedBox(height: 24),
        // Generate button always visible in tattoo style section
        _buildGenerateButton(),
      ],
    );
  }

  Widget _buildStyleCard(_TattooStyleItem item, int index, bool isSelected) {
    final double width = isSelected ? 150 : 130;
    final Color borderColor = isSelected
        ? AppColors.navBarActive
        : AppColors.cardGradientEnd;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF151411),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.4),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          setState(() {
            // Toggle selection: tap again to unselect
            if (_selectedStyleIndex == index) {
              _selectedStyleIndex = null;
            } else {
              _selectedStyleIndex = index;
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(item.assetPath, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExploreInspirationSection() {
    final List<String> inspirationImages = [
      'assets/inspiration_one.png',
      'assets/inspiration_two.png',
      'assets/inspiration_one.png',
      'assets/inspiration_two.png',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Explore Inspiration',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textWhite,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return _buildInspirationCard(inspirationImages[index]);
          },
        ),
      ],
    );
  }

  Widget _buildInspirationCard(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFE8B3A), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.cardGradientStart,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: AppColors.textGrey,
                ),
              ),
            );
          },
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
    final bool enabled = _selectedStyleIndex != null;

    return GestureDetector(
      onTap: enabled
          ? () {
              // Placeholder tap handler for now.
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Generate tapped')));
            }
          : null,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFFA6541D) // Burnt orange when enabled
              : const Color(0xFF2A2A2A), // Dark grey when disabled
          borderRadius: BorderRadius.circular(12),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: const Color(0xFFA6541D).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            'Generate',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: enabled ? Colors.white : AppColors.textGrey,
              fontFamily: 'Amaranth',
              shadows: enabled
                  ? [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
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
              top: MediaQuery.of(context).size.height * 0.46,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
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
                            width: 60,
                            height: 60,
                            colorFilter: const ColorFilter.mode(
                              AppColors.titleGradientStart,
                              BlendMode.srcIn,
                            ),
                          );
                        }
                        return const Icon(
                          Icons.arrow_upward_rounded,
                          size: 60,
                          color: AppColors.titleGradientStart,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Text
                    Text(
                      'Describe the tattoo you have in mind, or tap \'Inspiration\' for ideas',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
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
