import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
import 'providers/usage_limit_provider.dart';
import 'providers/asset_sync_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'services/app_open_ad_service.dart';
import 'services/remote_config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await RemoteConfigService.instance.initialize();
  await MobileAds.instance.initialize();
  if (kDebugMode) {
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: const ['70CF55242CE18F7DA1D476CAEEB9E92F'],
      ),
    );
  }
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _isDarkTheme = true; // Default to dark theme
  bool _isLoading = true;
  late final AppOpenAdService _appOpenAdService;
  late final UsageLimitProvider _usageLimitProvider;
  DateTime? _pausedAt;
  static const String _prefsProUnlockedKey = 'usage_pro_unlocked';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Show on every meaningful "resume from background" without a long throttle.
    // Cold start won't show because `_pausedAt` is null then.
    _appOpenAdService = AppOpenAdService.instance
      ..configure(minIntervalBetweenShows: Duration.zero);
    _usageLimitProvider = UsageLimitProvider();
    // Preload early so "resume from cache" can show ASAP.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _appOpenAdService.preload();
    });
    _loadThemePreference();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        // Some Android flows (e.g., opening Gallery / permission dialogs) can go
        // inactive without a reliable paused. Treat it as "background started"
        // so App Open can show on resume consistently.
        _pausedAt ??= DateTime.now();
        _appOpenAdService.preload();
        break;
      case AppLifecycleState.paused:
        _pausedAt = DateTime.now();
        // Preload while app is backgrounded so it's ready on resume.
        _appOpenAdService.preload();
        break;
      case AppLifecycleState.resumed:
        _maybeShowAppOpenAdOnResume();
        break;
      default:
        break;
    }
  }

  Future<void> _maybeShowAppOpenAdOnResume() async {
    if (UsageLimitProvider.forceProForTesting) {
      _pausedAt = null;
      return;
    }
    // Only show when coming back from background ("cache"), not on cold start.
    final pausedAt = _pausedAt;
    if (pausedAt == null) return;

    // Ignore super-quick task switching (prevents spammy show attempts).
    if (DateTime.now().difference(pausedAt) < const Duration(seconds: 2)) {
      if (kDebugMode) {
        debugPrint('[AppOpen] skip: resumed too quickly');
      }
      _pausedAt = null;
      return;
    }

    if (!mounted) return;
    if (_appOpenAdService.isTemporarilyDisabled) {
      if (kDebugMode) {
        debugPrint('[AppOpen] skip: temporarily disabled by active screen');
      }
      _pausedAt = null;
      return;
    }

    // IMPORTANT: UsageLimitProvider loads async; on a fresh resume it might still
    // be on the default `false` value. Read from prefs to avoid showing to PRO.
    try {
      final prefs = await SharedPreferences.getInstance();
      final isPro = prefs.getBool(_prefsProUnlockedKey) ?? false;
      if (isPro) {
        if (kDebugMode) {
          debugPrint('[AppOpen] skip: user is pro');
        }
        _pausedAt = null;
        return;
      }
    } catch (_) {
      // If prefs fails, fall back to in-memory provider value.
      if (_usageLimitProvider.isProUnlocked) {
        _pausedAt = null;
        return;
      }
    }

    if (kDebugMode) {
      debugPrint('[AppOpen] resume->show');
    }
    // Show on every resume; if needed, wait for load.
    await _appOpenAdService.showIfAvailable(waitForLoad: true);

    // Reset so next resume requires a fresh background.
    _pausedAt = null;
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appOpenAdService.dispose();
    _usageLimitProvider.dispose();
    super.dispose();
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
        ChangeNotifierProvider.value(value: RemoteConfigService.instance),
        ChangeNotifierProvider(create: (_) => LocaleService()),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider()..loadFavorites(),
        ),
        ChangeNotifierProvider.value(value: _usageLimitProvider),
        ChangeNotifierProvider(
          create: (_) => AssetSyncProvider()..load(),
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
