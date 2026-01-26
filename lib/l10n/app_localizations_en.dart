// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get skip => 'Skip';

  @override
  String get continue_ => 'Continue';

  @override
  String get start => 'Start';

  @override
  String get customCreation => 'Custom Creation';

  @override
  String get customCreationDescription =>
      'Create custom designs and bring\nyour creative ideas to life.';

  @override
  String get tattooMaker => 'Tattoo Maker';

  @override
  String get flowerCreation => 'Flower Creation';

  @override
  String get flowerCreationDescription =>
      'Turn your name into a beautiful\nflower-inspired design.';
}
