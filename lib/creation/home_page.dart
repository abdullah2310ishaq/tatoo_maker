import 'dart:math';

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
  final VoidCallback? onHistoryTap;
  final bool alwaysShowTutorialOverlay;

  /// Notifies the shell when generate state changes (enabled + tap callback for navbar).
  final void Function(bool enabled, VoidCallback onGenerateTap)?
  onRegisterGenerateAction;

  const HomePage({
    super.key,
    this.onMenuTap,
    this.onHistoryTap,
    this.alwaysShowTutorialOverlay = false,
    this.onRegisterGenerateAction,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _selectedStyleIndex;
  final TextEditingController _dreamInkController = TextEditingController();
  static const int _maxCharacters = 600;
  bool _showTutorialOverlay = false;
  final GlobalKey _dreamInkCardKey = GlobalKey();
  final GlobalKey _tattooStyleSectionKey = GlobalKey();
  final ScrollController _styleRowScrollController = ScrollController();

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
      if (widget.alwaysShowTutorialOverlay) {
        if (mounted) {
          setState(() {
            _showTutorialOverlay = true;
          });
        }
        return;
      }

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
    _styleRowScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    // Defer so we don't call setState on parent during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onRegisterGenerateAction?.call(_canGenerate, _onGenerateTap);
    });
    // Bottom area: separate Generate button (56 + 8 margin) + navbar + safe area
    final bottomAreaHeight = 56.h + 8.h + 88.h + bottomPadding + 20.h;

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
                // Keep left padding globally, but allow specific sections
                // (like the tattoo style row) to reach the right edge.
                right: 0,
                bottom: bottomAreaHeight, // Clear Generate button + navbar
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  // Header: menu + InkVision + notification (single line)
                  Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: HomeHeader(
                      isDark: isDark,
                      onMenuTap: widget.onMenuTap,
                      onHistoryTap: widget.onHistoryTap,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  // Describe Your Dream Ink card
                  Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: DreamInkCard(
                      cardKey: _dreamInkCardKey,
                      controller: _dreamInkController,
                      maxCharacters: _maxCharacters,
                      onChanged: (_) => setState(() {}),
                      checkAssetExists: _checkAssetExists,
                      onInspirationTap: _onInspirationTap,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // Tattoo style selector section (Generate is in bottom navbar)
                  SizedBox(
                    key: _tattooStyleSectionKey,
                    child: TattooStyleSection(
                      styles: _styles,
                      selectedIndex: _selectedStyleIndex,
                      onStyleTap: _onStyleTap,
                      scrollController: _styleRowScrollController,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // Explore Inspiration section
                  Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: const ExploreInspirationSection(),
                  ),
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

  void _onInspirationTap() {
    final styles = _styles;
    if (styles.isEmpty) return;
    final randomIndex = Random().nextInt(styles.length);
    _onStyleTap(randomIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_styleRowScrollController.hasClients) {
        // Scroll horizontal row so the selected card is fully visible.
        // Matches `TattooStyleSection` card widths.
        final double itemWidth = 92.w;
        final double selectedWidth = 108.w;
        final double gap = 2.w;

        final viewport = _styleRowScrollController.position.viewportDimension;
        final rawOffset =
            (randomIndex * (itemWidth + gap)) - (viewport - selectedWidth) / 2;
        final targetOffset = rawOffset.clamp(
          0.0,
          _styleRowScrollController.position.maxScrollExtent,
        );

        _styleRowScrollController.animateTo(
          targetOffset.toDouble(),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onStyleTap(int index) {
    final l10n = AppLocalizations.of(context)!;
    final stylePrompts = _stylePrompts(l10n);

    setState(() {
      // Toggle selection: tap again to unselect — clear dream ink text too
      if (_selectedStyleIndex == index) {
        _selectedStyleIndex = null;
        _dreamInkController.clear();
        return;
      }

      _selectedStyleIndex = index;

      // Auto-fill with style prompt only when dream ink is empty.
      // If user already wrote something, keep their prompt; style is reference/inspiration.
      final selectedStyle = _styles[index];
      final prompt = stylePrompts[selectedStyle.label];
      if (prompt == null) return;

      final currentText = _dreamInkController.text.trim();
      if (currentText.isEmpty) {
        _dreamInkController.text = prompt.length > _maxCharacters
            ? prompt.substring(0, _maxCharacters)
            : prompt;
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
