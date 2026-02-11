import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import 'utils/colors.dart';
import 'utils/toast.dart';
import 'creation/home_page.dart';
import 'history/history_page.dart';
import 'tattoo/tattoo_page.dart';
import 'flower/flower_home.dart';
import 'widgets/app_drawer.dart';
import 'widgets/exit_confirmation_dialog.dart';
import 'providers/theme_provider.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _generateEnabled = false;
  VoidCallback? _onGenerateTap;
  bool _hasShownConnectivityToast = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivityOnce();
  }

  Future<void> _checkConnectivityOnce() async {
    if (_hasShownConnectivityToast) return;
    bool isOffline = false;
    try {
      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 4);
      final request = await client.getUrl(
        Uri.parse('https://www.google.com'),
      );
      final response = await request.close();
      client.close(force: true);
      if (response.statusCode >= 200 && response.statusCode < 500) {
        return;
      }
      isOffline = true;
    } on SocketException {
      isOffline = true;
    } on Exception {
      isOffline = true;
    } on Object {
      // Any other error (e.g. OSError, TimeoutException) → treat as offline
      isOffline = true;
    }

    if (!isOffline || !mounted) return;
    _hasShownConnectivityToast = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context)!;
        AppToast.show(
          context,
          message: l10n.noInternetConnectionSomeFeatures,
          isSuccess: false,
          duration: const Duration(seconds: 3),
        );
      });
    });
  }

  void _onItemTapped(int index) {
      // When switching tabs, remove focus from any text fields so the keyboard
    // does not automatically open when returning to the home screen.
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedIndex = index; 
    });
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = ThemeProvider.of(context);
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop && mounted) {
          final shouldExit = await ExitConfirmationDialog.show(context);
          if (shouldExit == true && mounted) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        drawer: AppDrawer(
          isDarkTheme: themeProvider?.isDarkTheme ?? false,
          onThemeToggle: themeProvider?.toggleTheme ?? () {},
        ),
        body: Stack(
          children: [
            // Main content area based on selected index
            SafeArea(
              child: Container(
                color: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                child: _buildCurrentPage(openDrawer),
              ),
            ),
            // Static bottom area: fixed layout so navbar never moves when changing tabs
            if (!keyboardVisible)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_selectedIndex == 0)
                        _buildGenerateButtonSeparate()
                      else
                        SizedBox(height: 66.h + 8.h),
                      _buildFloatingNavBar(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPage(VoidCallback openDrawer) {
    switch (_selectedIndex) {
      case 0:
        return HomePage(
          onMenuTap: openDrawer,
          onHistoryTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => HistoryPage(tabIndex: _selectedIndex),
              ),
            );
          },
          onRegisterGenerateAction: (enabled, onTap) {
            _onGenerateTap = onTap;
            if (_generateEnabled != enabled) {
              setState(() => _generateEnabled = enabled);
            }
          },
        );
      case 1:
        return TattooPage(
          onMenuTap: openDrawer,
          onHistoryTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => HistoryPage(tabIndex: _selectedIndex),
              ),
            );
          },
        );
      case 2:
        return FlowerHome(
          onMenuTap: openDrawer,
          onHistoryTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => HistoryPage(tabIndex: _selectedIndex),
              ),
            );
          },
        );
      default:
        return HomePage(
          onMenuTap: openDrawer,
          onHistoryTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => HistoryPage(tabIndex: _selectedIndex),
              ),
            );
          },
        );
    }
  }

  Widget _buildFloatingNavBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final navBarBgColor = isDark
        ? AppColors.navBarBackground
        : AppColors.lightBackground;

    return Container(
      margin: EdgeInsets.only(top: 4.h),
      decoration: BoxDecoration(
        color: navBarBgColor,
        // Normal (non-circular) navbar shape
        borderRadius: BorderRadius.zero,
        border: isDark
            ? null
            : Border.all(
                color: AppColors.textGrey.withValues(alpha: 0.2),
                width: 1,
              ),
        boxShadow: [
          BoxShadow(
            color: AppColors.navBarActive.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            iconPath: 'assets/creation.svg',
            label: l10n.creation,
            index: 0,
          ),

          _buildNavItem(
            iconPath: 'assets/tatoo.svg',
            label: l10n.tattoo,
            index: 1,
          ),
          _buildNavItem(
            iconPath: 'assets/flower.svg',
            label: l10n.flower,
            index: 2,
          ),
        ],
      ),
    );
  }

  /// Generate button above the navbar (Creation tab only) — original pill style.
  Widget _buildGenerateButtonSeparate() {
    final l10n = AppLocalizations.of(context)!;
    final enabled = _generateEnabled && _onGenerateTap != null;
    const Color enabledColor = Color(0xFFA6541D); // Burnt orange (original)
    const Color disabledColor = Color(0xFF2A2A2A);

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: GestureDetector(
          onTap: enabled ? _onGenerateTap : null,
          child: Container(
            height: 66.h,
            decoration: BoxDecoration(
              color: enabled ? enabledColor : disabledColor,
              borderRadius: BorderRadius.circular(6.r),
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: enabledColor.withValues(alpha: 0.3),
                        blurRadius: 8.r,
                        offset: Offset(0, 4.h),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              l10n.homeGenerate,
              style: TextStyle(
                fontSize: 23.sp,
                fontWeight: FontWeight.w600,
                color: enabled ? AppColors.textWhite : AppColors.textGrey,
                fontFamily: 'Amaranth',
                shadows: enabled
                    ? [
                        Shadow(
                          color: AppColors.gradientBlack.withValues(alpha: 0.3),
                          offset: Offset(0, 2.h),
                          blurRadius: 4.r,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required int index,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isSelected = _selectedIndex == index;
    final Color itemColor = isSelected
        ? AppColors.navBarActive
        : (isDark
              ? AppColors.navBarInactive
              : AppColors.textPrimary.withValues(alpha: 0.6));

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSvgIcon(iconPath, itemColor, index),
              SizedBox(height: 2.h),
              Text(
                label,
                style: TextStyle(
                  color: itemColor,
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSvgIcon(String iconPath, Color color, int index) {
    return FutureBuilder(
      future: _checkAssetExists(iconPath),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return SvgPicture.asset(
            iconPath,
            width: 30.w,
            height: 35.h,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            placeholderBuilder: (context) =>
                Icon(_getIconData(index), size: 22, color: color),
          );
        }
        return Icon(_getIconData(index), size: 22, color: color);
      },
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

  IconData _getIconData(int index) {
    switch (index) {
      case 0:
        return Icons.brush; // Creation icon
      case 1:
        return Icons.auto_awesome; // Tattoo icon
      case 2:
        return Icons.local_florist; // Flower icon
      default:
        return Icons.circle;
    }
  }
}
