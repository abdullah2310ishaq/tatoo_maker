import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'utils/colors.dart';
import 'creation/home_page.dart';
import 'tattoo/tattoo_page.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = ThemeProvider.of(context);

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
            // Floating bottom navigation bar - positioned above safe area
            Positioned(
              left: 20,
              right: 20,
              bottom: bottomPadding > 0 ? bottomPadding + 10 : 20,
              child: _buildFloatingNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPage(VoidCallback openDrawer) {
    switch (_selectedIndex) {
      case 0:
        return HomePage(onMenuTap: openDrawer);
      case 1:
        return TattooPage(onMenuTap: openDrawer);
      case 2:
        return const Center(
          child: Text('Flower Page', style: TextStyle(fontSize: 24)),
        );
      default:
        return HomePage(onMenuTap: openDrawer);
    }
  }

  Widget _buildFloatingNavBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBarBgColor = isDark
        ? AppColors.navBarBackground
        : AppColors.lightBackground;

    return Container(
      decoration: BoxDecoration(
        color: navBarBgColor,
        borderRadius: BorderRadius.circular(50),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            iconPath: 'assets/creation.svg',
            label: 'Creation',
            index: 0,
          ),
          _buildNavItem(
            iconPath: 'assets/tatoo.svg',
            label: 'Tattoo',
            index: 1,
          ),
          _buildNavItem(
            iconPath: 'assets/flower.svg',
            label: 'Flower',
            index: 2,
          ),
        ],
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
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSvgIcon(iconPath, itemColor, index),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: itemColor,
                  fontSize: 12,
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
            width: 24,
            height: 27,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            placeholderBuilder: (context) =>
                Icon(_getIconData(index), size: 24, color: color),
          );
        }
        return Icon(_getIconData(index), size: 24, color: color);
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
