import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';
import 'utils/theme_manager.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = true; // Default to dark theme
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getBool('isDarkTheme');
      if (savedTheme != null) {
        setState(() {
          _isDarkTheme = savedTheme;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // If there's an error, use default theme
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = !_isDarkTheme;
    setState(() {
      _isDarkTheme = newTheme;
    });

    // Save to shared preferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkTheme', newTheme);
    } catch (e) {
      // Handle error silently
      debugPrint('Error saving theme preference: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading screen while theme preference is being loaded
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return ThemeProvider(
      isDarkTheme: _isDarkTheme,
      toggleTheme: toggleTheme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'InkVision - Tattoo Maker',
        theme: ThemeManager.lightTheme,
        darkTheme: ThemeManager.darkTheme,
        themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        home: SplashScreen(isDarkTheme: _isDarkTheme),
      ),
    );
  }
}
