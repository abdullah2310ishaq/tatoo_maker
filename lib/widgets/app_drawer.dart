import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/colors.dart';
import 'inkvision_underline.dart';

class AppDrawer extends StatelessWidget {
  final bool isDarkTheme;
  final VoidCallback onThemeToggle;

  const AppDrawer({
    super.key,
    required this.isDarkTheme,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.buttonBackground;
    final backgroundColor = isDark
        ? AppColors.drawerDarkBackground
        : AppColors.lightBackground;
    final iconColor = isDark ? AppColors.textWhite : AppColors.buttonBackground;

    return Drawer(
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // Header with InkVision title and underline
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'InkVision',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Amaranth',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const InkVisionUnderline(width: 120, height: 3),
                ],
              ),
            ),
            const Divider(height: 1),
            // Theme Toggle
            ListTile(
              leading: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: iconColor,
              ),
              title: Text(
                isDark ? 'Dark Theme' : 'Light Theme',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Switch(
                value: isDark,
                onChanged: (_) => onThemeToggle(),
                activeColor: const Color(0xFFFE8B3A),
                activeTrackColor: const Color(0xFFFE8B3A).withOpacity(0.5),
              ),
            ),
            const Divider(height: 1),
            // Menu Items
            Expanded(
              child: ListView(
                children: [
                  _buildMenuItem(
                    context: context,
                    icon: Icons.language,
                    title: 'Languages',
                    trailingText: 'English',
                    textColor: textColor,
                    iconColor: iconColor,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.favorite,
                    title: 'Favorites',
                    textColor: textColor,
                    iconColor: iconColor,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.star,
                    title: 'Rate Us',
                    textColor: textColor,
                    iconColor: iconColor,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.privacy_tip,
                    title: 'Privacy Policy',
                    textColor: textColor,
                    iconColor: iconColor,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.share,
                    title: 'Share App',
                    textColor: textColor,
                    iconColor: iconColor,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.feedback,
                    title: 'Feedback',
                    textColor: textColor,
                    iconColor: iconColor,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.people,
                    title: 'Community Guidelines',
                    textColor: textColor,
                    iconColor: iconColor,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.apps,
                    title: 'More Apps',
                    textColor: textColor,
                    iconColor: iconColor,
                    showAdBadge: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? trailingText,
    required Color textColor,
    required Color iconColor,
    bool showAdBadge = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (showAdBadge) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFE8B3A),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Ad',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 14,
              ),
            ),
          if (trailingText != null) const SizedBox(width: 8),
          Icon(
            CupertinoIcons.chevron_right,
            size: 16,
            color: AppColors.textGrey,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
