import 'package:flutter/material.dart';

class ThemeProvider extends InheritedWidget {
  final bool isDarkTheme;
  final VoidCallback toggleTheme;

  const ThemeProvider({
    super.key,
    required this.isDarkTheme,
    required this.toggleTheme,
    required super.child,
  });

  static ThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return oldWidget.isDarkTheme != isDarkTheme;
  }
}
