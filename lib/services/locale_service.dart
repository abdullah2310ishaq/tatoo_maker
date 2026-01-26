import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage app locale/language preferences
class LocaleService extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  Locale _currentLocale = const Locale('en'); // Default to English

  LocaleService() {
    _loadLocale();
  }

  /// Get current locale
  Locale getCurrentLocale() => _currentLocale;

  /// Set locale by language code
  Future<void> setLocaleByCode(String languageCode) async {
    _currentLocale = Locale(languageCode);
    await _saveLocale(languageCode);
    notifyListeners();
  }

  /// Load saved locale from SharedPreferences
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey);
      if (savedLocale != null) {
        _currentLocale = Locale(savedLocale);
        notifyListeners();
      }
    } catch (e) {
      // Use default locale if error
      debugPrint('Error loading locale: $e');
    }
  }

  /// Save locale to SharedPreferences
  Future<void> _saveLocale(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }
}
