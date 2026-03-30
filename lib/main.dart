import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import 'package:tatoo_maker/services/locale_service.dart';
import 'splash_screen.dart';
import 'utils/theme_manager.dart';
import 'utils/route_observer.dart';
import 'providers/theme_provider.dart';
import 'providers/favorites_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // Lock app orientation so it does not rotate.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
        // No saved preference, use default (dark theme)
        setState(() {
          _isDarkTheme = true;
          _isLoading = false;
        });
        // Save the default theme preference
        await prefs.setBool('isDarkTheme', true);
      }
    } catch (e) {
      // If there's an error, use default theme (dark)
      setState(() {
        _isDarkTheme = true;
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
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(1.0)),
            child: child!,
          );
        },
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleService()),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider()..loadFavorites(),
        ),
      ],
      child: ThemeProvider(
        isDarkTheme: _isDarkTheme,
        toggleTheme: toggleTheme,
        child: ScreenUtilInit(
          designSize: const Size(375, 812), // iPhone X design size
          minTextAdapt: true,
          splitScreenMode: false,
          builder: (context, child) {
            final locale = context.watch<LocaleService>().getCurrentLocale();
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: '"AI Tattoo - Tattoo Maker',
              theme: ThemeManager.lightTheme,
              darkTheme: ThemeManager.darkTheme,
              themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
              locale: locale,
              navigatorObservers: [routeObserver],
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
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(1.0)),
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
