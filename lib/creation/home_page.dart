import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:tatoo_maker/utils/colors.dart';
import '../providers/theme_provider.dart';
import '../providers/usage_limit_provider.dart';
import 'loading_screen.dart';
import 'models/tattoo_style_item.dart';
import 'widgets/dream_ink_card.dart';
import 'widgets/explore_inspiration_section.dart';
import 'widgets/home_header.dart';
import 'widgets/tattoo_style_section.dart';
import 'widgets/tutorial_overlay.dart';
import '../utils/toast.dart';
import '../utils/route_observer.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onHistoryTap;
  final VoidCallback? onProTap;
  final bool alwaysShowTutorialOverlay;

  /// Notifies the shell when generate state changes (enabled + tap callback for navbar).
  final void Function(bool enabled, VoidCallback onGenerateTap)?
  onRegisterGenerateAction;

  const HomePage({
    super.key,
    this.onMenuTap,
    this.onHistoryTap,
    this.onProTap,
    this.alwaysShowTutorialOverlay = false,
    this.onRegisterGenerateAction,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  int? _selectedStyleIndex;
  final TextEditingController _dreamInkController = TextEditingController();
  static const int _maxCharacters = 600;
  bool _showTutorialOverlay = false;
  final GlobalKey _dreamInkCardKey = GlobalKey();
  final GlobalKey _tattooStyleSectionKey = GlobalKey();
  final ScrollController _styleRowScrollController = ScrollController();
  String? _lastAutoFilledPrompt;
  bool _isSettingDreamInkText = false;

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

  static bool _isRtlLocale(Locale locale) {
    const rtlCodes = ['ar', 'he', 'fa', 'ur'];
    return rtlCodes.contains(locale.languageCode);
  }

  /// Wraps [child] in RTL Directionality when locale is RTL (e.g. Arabic). Navbar/drawer stay LTR.
  Widget _wrapWithRtlIfNeeded(BuildContext context, {required Widget child}) {
    final isRtl = _isRtlLocale(Localizations.localeOf(context));
    if (!isRtl) return child;
    return Directionality(textDirection: TextDirection.rtl, child: child);
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
      const TattooStyleItem(label: 'Unicorn', assetPath: 'assets/unicorn.png'),
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
      const TattooStyleItem(label: 'Floral', assetPath: 'assets/floral.png'),
      TattooStyleItem(
        label: 'Wolf',
        assetPath: isDark ? 'assets/wolf_dark.png' : 'assets/wolf_light.png',
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _dreamInkController.dispose();
    _styleRowScrollController.dispose();
    super.dispose();
  }

  @override
  void didPushNext() {
    // Navigating away from HomePage → close keyboard.
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void didPopNext() {
    // Returning to HomePage → ensure keyboard stays closed.
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _onDreamInkChanged(String _) {
    // If user edits the text manually, stop treating it as auto-filled.
    if (_isSettingDreamInkText) return;
    _lastAutoFilledPrompt = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final l10n = AppLocalizations.of(context)!;

    // If the user has a style selected and is still using the last auto-filled
    // prompt (i.e. they didn't customize the text), update the prompt when
    // the app language changes so the text matches the new locale.
    _maybeUpdatePromptForLocale(l10n);
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
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
            ),
            child: Builder(
              builder: (context) {
                final isRtl = _isRtlLocale(Localizations.localeOf(context));

                Widget scroll = CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: isDark ? Colors.black : Colors.white,
                      elevation: 0,
                       scrolledUnderElevation: 0,
                      surfaceTintColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      toolbarHeight: 80.h,
                      flexibleSpace: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 20.h,
                            left: 20.w,
                            right: 20.w,
                          ),
                          child: HomeHeader(
                            isDark: isDark,
                            onMenuTap: _onMenuTap,
                            onHistoryTap: widget.onHistoryTap,
                            onProTap: widget.onProTap,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          start: 20.w,
                          end: 20.w,
                          bottom: bottomAreaHeight,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            // Describe Your Dream Ink card (RTL in Arabic, centered like English)
                            _wrapWithRtlIfNeeded(
                              context,
                              child: DreamInkCard(
                                cardKey: _dreamInkCardKey,
                                controller: _dreamInkController,
                                maxCharacters: _maxCharacters,
                                onChanged: _onDreamInkChanged,
                                checkAssetExists: _checkAssetExists,
                                onInspirationTap: _onInspirationTap,
                                hasSelectedStyle: _selectedStyleIndex != null,
                                showClearButton:
                                    _selectedStyleIndex != null ||
                                    _dreamInkController.text.trim().isNotEmpty,
                                onClearStyleTap: () {
                                  setState(() {
                                    _selectedStyleIndex = null;
                                    _dreamInkController.clear();
                                    _lastAutoFilledPrompt = null;
                                  });
                                },
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
                            // Explore Inspiration section (parent provides start padding in both LTR/RTL)
                            _wrapWithRtlIfNeeded(
                              context,
                              child: ExploreInspirationSection(
                                onPromptSelected: _onExplorePromptSelected,
                              ),
                            ),
                            SizedBox(
                              height: 40.h,
                            ), // Extra spacing to ensure last cards are fully visible
                          ],
                        ),
                      ),
                    ),
                  ],
                );

                return isRtl
                    ? Directionality(
                        textDirection: TextDirection.rtl,
                        child: scroll,
                      )
                    : scroll;
              },
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

  bool get _canGenerate => _dreamInkController.text.trim().isNotEmpty;

  void _maybeUpdatePromptForLocale(AppLocalizations l10n) {
    if (_selectedStyleIndex == null) return;
    if (_lastAutoFilledPrompt == null) return;

    final currentText = _dreamInkController.text.trim();
    // If user has edited the text since the last auto-fill, don't override it.
    if (currentText.isEmpty || currentText != _lastAutoFilledPrompt!.trim()) {
      return;
    }

    final styles = _styles;
    if (_selectedStyleIndex! < 0 || _selectedStyleIndex! >= styles.length) {
      return;
    }

    final stylePrompts = _stylePrompts(l10n);
    final selectedStyle = styles[_selectedStyleIndex!];
    final newPrompt = stylePrompts[selectedStyle.label];
    if (newPrompt == null) return;

    final nextText = newPrompt.length > _maxCharacters
        ? newPrompt.substring(0, _maxCharacters)
        : newPrompt;

    // If the new localized text is effectively the same, just refresh the marker.
    if (nextText.trim() == currentText) {
      _lastAutoFilledPrompt = nextText.trim();
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _isSettingDreamInkText = true;
      _dreamInkController.text = nextText;
      _isSettingDreamInkText = false;
      _lastAutoFilledPrompt = nextText.trim();
      setState(() {});
    });
  }

  void _onInspirationTap() {
    final styles = _styles;
    if (styles.isEmpty) return;
    // Pick a random style (prefer different from current selection)
    int randomIndex = Random().nextInt(styles.length);
    if (_selectedStyleIndex != null && styles.length > 1) {
      var attempts = 0;
      while (randomIndex == _selectedStyleIndex && attempts < 5) {
        randomIndex = Random().nextInt(styles.length);
        attempts++;
      }
    }

    // Inspiration = "random idea": always update the text to match the random style prompt.
    final l10n = AppLocalizations.of(context)!;
    final stylePrompts = _stylePrompts(l10n);
    final selectedStyle = styles[randomIndex];
    final prompt = stylePrompts[selectedStyle.label];

    setState(() {
      _selectedStyleIndex = randomIndex;
      if (prompt != null) {
        final nextText = prompt.length > _maxCharacters
            ? prompt.substring(0, _maxCharacters)
            : prompt;
        _isSettingDreamInkText = true;
        _dreamInkController.text = nextText;
        _isSettingDreamInkText = false;
        _lastAutoFilledPrompt = nextText.trim();
      }
    });

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
    final currentText = _dreamInkController.text.trim();
    final isAutoFilledText =
        _lastAutoFilledPrompt != null &&
        currentText == _lastAutoFilledPrompt!.trim();
    final isUserTypedText =
        currentText.isNotEmpty && _lastAutoFilledPrompt == null;

    setState(() {
      // Toggle selection: tap again to unselect — clear dream ink text too
      if (_selectedStyleIndex == index) {
        _selectedStyleIndex = null;
        // Preserve user text; clear only auto-filled style text.
        if (isAutoFilledText) {
          _dreamInkController.clear();
        }
        _lastAutoFilledPrompt = null;
        return;
      }

      _selectedStyleIndex = index;

      // If user has custom text in Dream Ink, never replace it with style text.
      // Style remains selected and will still be used in backend prompt.
      if (isUserTypedText) {
        _lastAutoFilledPrompt = null;
        return;
      }

      final selectedStyle = _styles[index];
      final prompt = stylePrompts[selectedStyle.label];
      if (prompt == null) return;

      final nextText = prompt.length > _maxCharacters
          ? prompt.substring(0, _maxCharacters)
          : prompt;
      _isSettingDreamInkText = true;
      _dreamInkController.text = nextText;
      _isSettingDreamInkText = false;
      _lastAutoFilledPrompt = nextText.trim();
    });
  }

  Future<void> _onGenerateTap() async {
    if (!_canGenerate) return;
    final usageLimitProvider = context.read<UsageLimitProvider>();
    final canStartGeneration = await usageLimitProvider.canStartGeneration();
    if (!mounted) return;
    if (!canStartGeneration) {
      widget.onProTap?.call();
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    if (_selectedStyleIndex == null) {
      AppToast.show(
        context,
        message: l10n.stepStylePickYourTitleStyle,
        isSuccess: false,
      );
      return;
    }

    // Close keyboard before navigating away so it won't remain open on return.
    FocusScope.of(context).unfocus();

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

  void _onExplorePromptSelected(String prompt) {
    final trimmed = prompt.trim();
    if (trimmed.isEmpty) return;

    final nextText = trimmed.length > _maxCharacters
        ? trimmed.substring(0, _maxCharacters)
        : trimmed;

    _isSettingDreamInkText = true;
    _dreamInkController.text = nextText;
    _isSettingDreamInkText = false;
    _lastAutoFilledPrompt = null; // treat as user text so style won't override

    setState(() {});

    // Bring focus/visibility to the Dream Ink card.
    final targetContext = _dreamInkCardKey.currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        alignment: 0.2,
      );
    }

    final l10n = AppLocalizations.of(context)!;
    AppToast.show(
      context,
      message: l10n.stepStylePickYourTitleStyle,
      isSuccess: false,
    );
  }

  void _onMenuTap() {
    // Requested: opening drawer should reset Dream Ink + style and close keyboard.
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _selectedStyleIndex = null;
      _dreamInkController.clear();
      _lastAutoFilledPrompt = null;
    });
    widget.onMenuTap?.call();
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
