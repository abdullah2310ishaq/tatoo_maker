import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import '../utils/theme_manager.dart';
import '../providers/theme_provider.dart';
import 'loading_screen.dart';
import 'models/tattoo_style_item.dart';
import 'widgets/dream_ink_card.dart';
import 'widgets/explore_inspiration_section.dart';
import 'widgets/home_header.dart';
import 'widgets/tattoo_style_section.dart';
import 'widgets/tutorial_overlay.dart';

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
      if (kDebugMode) {
        debugPrint(
          '[HomePage] tutorialShown=$tutorialShown, willShow=${!tutorialShown}',
        );
      }
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

  List<TattooStyleItem> get _styles {
    final themeProvider = ThemeProvider.of(context);
    final isDark =
        themeProvider?.isDarkTheme ??
        Theme.of(context).brightness == Brightness.dark;
    return [
      const TattooStyleItem(label: 'Dragon', assetPath: 'assets/dragon.png'),
      const TattooStyleItem(label: 'Unicorn', assetPath: 'assets/unicorn.png'),
      const TattooStyleItem(label: 'Floral', assetPath: 'assets/floral.png'),
      TattooStyleItem(
        label: 'Abstract',
        assetPath: isDark
            ? 'assets/abstract_dark.png'
            : 'assets/abstract_light.png',
      ),
      TattooStyleItem(
        label: 'Butterfly',
        assetPath: isDark
            ? 'assets/butterfly_dark.png'
            : 'assets/butterfly_light.png',
      ),
      TattooStyleItem(
        label: 'Eagle',
        assetPath: isDark ? 'assets/eagle_dark.png' : 'assets/eagle_light.png',
      ),
      TattooStyleItem(
        label: 'Lion',
        assetPath: isDark ? 'assets/lion_dark.png' : 'assets/lion_light.png',
      ),
      TattooStyleItem(
        label: 'Spider',
        assetPath: isDark
            ? 'assets/spider_dark.png'
            : 'assets/spider_light.png',
      ),
      TattooStyleItem(
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
                  HomeHeader(isDark: isDark, onMenuTap: widget.onMenuTap),
                  SizedBox(height: 30.h),
                  // Describe Your Dream Ink card
                  DreamInkCard(
                    cardKey: _dreamInkCardKey,
                    controller: _dreamInkController,
                    maxCharacters: _maxCharacters,
                    onChanged: (_) => setState(() {}),
                    checkAssetExists: _checkAssetExists,
                  ),
                  SizedBox(height: 32.h),
                  // Tattoo style selector section (includes Generate button)
                  TattooStyleSection(
                    styles: _styles,
                    selectedIndex: _selectedStyleIndex,
                    onStyleTap: _onStyleTap,
                    onGenerateTap: _onGenerateTap,
                    generateEnabled: _canGenerate,
                  ),
                  SizedBox(height: 32.h),
                  // Explore Inspiration section
                  const ExploreInspirationSection(),
                  SizedBox(
                    height: 40.h,
                  ), // Extra spacing to ensure last cards are fully visible
                ],
              ),
            ),
          ),
          // Tutorial Overlay
          if (_showTutorialOverlay)
            Positioned.fill(
              child: TutorialOverlay(
                highlightKey: _dreamInkCardKey,
                checkAssetExists: _checkAssetExists,
                onDismiss: _dismissTutorialOverlay,
              ),
            ),
        ],
      ),
    );
  }

  bool get _canGenerate =>
      _selectedStyleIndex != null && _dreamInkController.text.trim().isNotEmpty;

  void _onStyleTap(int index) {
    final l10n = AppLocalizations.of(context)!;
    final stylePrompts = _stylePrompts(l10n);

    setState(() {
      // Toggle selection: tap again to unselect
      if (_selectedStyleIndex == index) {
        _selectedStyleIndex = null;
        return;
      }

      _selectedStyleIndex = index;

      // Auto-fill text only if empty or if current text matches a prompt
      final selectedStyle = _styles[index];
      final prompt = stylePrompts[selectedStyle.label];
      if (prompt == null) return;

      final currentText = _dreamInkController.text.trim();
      final isEmpty = currentText.isEmpty;
      final isPromptText = stylePrompts.values.any(
        (p) => p.trim() == currentText,
      );

      if (isEmpty || isPromptText) {
        _dreamInkController.text = prompt;
      }
    });
  }

  void _onGenerateTap() {
    if (!_canGenerate) return;

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

  Future<void> _dismissTutorialOverlay() async {
    await _markTutorialAsShown();
    if (!mounted) return;
    setState(() {
      _showTutorialOverlay = false;
    });
  }

  Future<bool> _checkAssetExists(String path) async {
    try {
      await DefaultAssetBundle.of(context).load(path);
      return true;
    } catch (e) {
      return false;
    }
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
