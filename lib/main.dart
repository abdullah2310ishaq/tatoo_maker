import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import 'package:tatoo_maker/services/locale_service.dart';
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
  bool _isDarkTheme = false; // Default to light theme
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
        // No saved preference, use default (light theme)
        setState(() {
          _isDarkTheme = false;
          _isLoading = false;
        });
        // Save the default theme preference
        await prefs.setBool('isDarkTheme', false);
      }
    } catch (e) {
      // If there's an error, use default theme (light)
      setState(() {
        _isDarkTheme = false;
        _isLoading = false;
      });
      debugPrint('Error loading theme preference: $e');
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
        builder: (context, child) {
          return MediaQuery(
            // Lock text scale factor to 1.0 to prevent system font size changes
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => LocaleService(),
      child: ThemeProvider(
        isDarkTheme: _isDarkTheme,
        toggleTheme: toggleTheme,
        child: ScreenUtilInit(
          designSize: const Size(375, 812), // iPhone X design size
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            final locale = context.watch<LocaleService>().getCurrentLocale();
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'InkVision - Tattoo Maker',
              theme: ThemeManager.lightTheme,
              darkTheme: ThemeManager.darkTheme,
              themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
              locale: locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) {
                return MediaQuery(
                  // Lock text scale factor to 1.0 to prevent system font size changes
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                );
              },
              home: SplashScreen(isDarkTheme: _isDarkTheme),
            );
          },
        ),
      ),
    );
  }
}
