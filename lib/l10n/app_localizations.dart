import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Skip button text for onboarding screens
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Continue button text for onboarding screens
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// Start button text for final onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Title for first onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Tattoo Creation'**
  String get tattooCreation;

  /// Description text for first onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Create unique tattoo designs and see how they look on your hand in real time.'**
  String get tattooCreationDescription;

  /// Title for second onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Custom Creation'**
  String get customCreation;

  /// Description text for second onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Create custom designs and bring\nyour creative ideas to life.'**
  String get customCreationDescription;

  /// Title for third onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Tattoo Maker'**
  String get tattooMaker;

  /// Feature title for third onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Flower Creation'**
  String get flowerCreation;

  /// Description text for third onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Turn your name into a beautiful\nflower-inspired design.'**
  String get flowerCreationDescription;

  /// Title for language selection screen
  ///
  /// In en, this message translates to:
  /// **'Choose a Language'**
  String get chooseALanguage;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Camera permission dialog title
  ///
  /// In en, this message translates to:
  /// **'Camera Permission Required'**
  String get cameraPermissionRequired;

  /// Generic permission dialog title
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// Dialog/CTA: Cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Dialog/CTA: Open Settings
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Button label: Retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Camera permission required to take photos message
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to take photos.'**
  String get cameraPermissionIsRequiredToTakePhotos;

  /// Camera access explanation for settings dialog
  ///
  /// In en, this message translates to:
  /// **'This app needs camera access to take photos. Please enable it in settings.'**
  String get cameraAccessNeededEnableInSettings;

  /// Error message shown when there are no cameras available
  ///
  /// In en, this message translates to:
  /// **'No cameras available on this device.'**
  String get noCamerasAvailableOnThisDevice;

  /// Error message shown when camera fails to initialize
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize camera. Please try again.'**
  String get failedToInitializeCameraTryAgain;

  /// Error message shown when camera is not ready
  ///
  /// In en, this message translates to:
  /// **'Camera not ready. Please wait.'**
  String get cameraNotReadyPleaseWait;

  /// Error message shown when photo capture fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t capture photo. Try again.'**
  String get couldntCapturePhotoTryAgain;

  /// Generic camera error label
  ///
  /// In en, this message translates to:
  /// **'Camera error'**
  String get cameraError;

  /// Light theme label
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// Dark theme label
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// Drawer menu item: Languages
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// Drawer menu item: Favorites
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Drawer menu item: Rate Us
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rateUs;

  /// Drawer menu item: Privacy Policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Drawer menu item: Share App
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// Drawer menu item: Feedback
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// Drawer menu item: Community Guidelines
  ///
  /// In en, this message translates to:
  /// **'Community Guidelines'**
  String get communityGuidelines;

  /// Drawer menu item: More Apps
  ///
  /// In en, this message translates to:
  /// **'More Apps'**
  String get moreApps;

  /// Bottom navigation item: Creation
  ///
  /// In en, this message translates to:
  /// **'Creation'**
  String get creation;

  /// Bottom navigation item: Tattoo
  ///
  /// In en, this message translates to:
  /// **'Tattoo'**
  String get tattoo;

  /// Bottom navigation item: Flower
  ///
  /// In en, this message translates to:
  /// **'Flower'**
  String get flower;

  /// Generic message when sharing fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t share image. Try again.'**
  String get couldntShareImageTryAgain;

  /// SnackBar message shown when there is no image to save
  ///
  /// In en, this message translates to:
  /// **'No image to save'**
  String get noImageToSave;

  /// SnackBar message shown when an image is saved to gallery (with emphasis)
  ///
  /// In en, this message translates to:
  /// **'Image saved to gallery!'**
  String get imageSavedToGalleryExcited;

  /// Generic message when saving fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save image. Try again.'**
  String get couldntSaveImageTryAgain;

  /// Virtual try-on: capture photo button label
  ///
  /// In en, this message translates to:
  /// **'Capture Photo'**
  String get capturePhoto;

  /// Virtual try-on: apply button label
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Virtual try-on: download button label
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// Virtual try-on screen title
  ///
  /// In en, this message translates to:
  /// **'Virtual Try-On'**
  String get virtualTryOn;

  /// Virtual try-on empty state message
  ///
  /// In en, this message translates to:
  /// **'Capture a photo of your hand\nor body part to try on the tattoo'**
  String get virtualTryOnEmptyState;

  /// Virtual try-on processing status line 1
  ///
  /// In en, this message translates to:
  /// **'Processing tattoo on human skin...'**
  String get virtualTryOnProcessingTitle;

  /// Virtual try-on processing status line 2
  ///
  /// In en, this message translates to:
  /// **'This may take a few moments'**
  String get virtualTryOnProcessingSubtitle;

  /// Label for the prompt section in explore detail
  ///
  /// In en, this message translates to:
  /// **'Prompt'**
  String get promptLabel;

  /// Button text for trying an explore preset
  ///
  /// In en, this message translates to:
  /// **'Try This'**
  String get tryThis;

  /// Home: style prompt for Wolf
  ///
  /// In en, this message translates to:
  /// **'Minimal tribal wolf tattoo drawn with bold white lines , abstract sharp curves, clean line-art, tattoo flash style.'**
  String get tattooStylePromptWolf;

  /// Home: style prompt for Abstract
  ///
  /// In en, this message translates to:
  /// **'Tribal abstract tattoo symbolizing inner strength and resilience, flowing sharp curves rising upward, bold confident line-art, powerful vertical composition, minimalist tribal style, solid white ink'**
  String get tattooStylePromptAbstract;

  /// Home: style prompt for Lion
  ///
  /// In en, this message translates to:
  /// **'Majestic lion tattoo representing courage and leadership, calm powerful expression, detailed mane, strong shading, artistic tattoo design, solid white ink, high contrast'**
  String get tattooStylePromptLion;

  /// Home: style prompt for Eagle
  ///
  /// In en, this message translates to:
  /// **'Eagle tattoo in mid-flight symbolizing freedom and vision, wide wings, sharp feather detail, dynamic motion, bold tattoo art, solid white ink, high contrast'**
  String get tattooStylePromptEagle;

  /// Home: style prompt for Spider
  ///
  /// In en, this message translates to:
  /// **'Detailed spider tattoo symbolizing patience and control, realistic anatomy, clean web elements, dark artistic tattoo style, solid white ink, high contrast'**
  String get tattooStylePromptSpider;

  /// Home: style prompt for Butterfly
  ///
  /// In en, this message translates to:
  /// **'Delicate butterfly tattoo representing transformation and growth, detailed wings, soft shading, elegant tattoo illustration, solid white ink, high contrast.'**
  String get tattooStylePromptButterfly;

  /// Home: style prompt for Dragon
  ///
  /// In en, this message translates to:
  /// **'Fantasy dragon tattoo design, coiled body, dark scales, glowing orange wings, sharp horns, bold clean lines'**
  String get tattooStylePromptDragon;

  /// Home: style prompt for Unicorn
  ///
  /// In en, this message translates to:
  /// **'Unicorn head tattoo design, golden horn, flowing rainbow mane, detailed fantasy illustration'**
  String get tattooStylePromptUnicorn;

  /// Home: style prompt for Floral
  ///
  /// In en, this message translates to:
  /// **'Pastel floral bouquet, peach & blush roses, wildflowers, golden foliage, cascading ribbons, asymmetrical teardrop, romantic vintage, soft lighting, high realism, dark background.'**
  String get tattooStylePromptFloral;

  /// Home: "Describe Your Dream Ink" title
  String get homeDescribeYourDreamInk;

  /// Home: Dream ink input hint
  String get homeDreamInkHint;

  /// Home: Inspiration label
  String get homeInspiration;

  /// Home: "characters remaining" suffix (prepend number in UI)
  String get homeCharactersRemaining;

  /// Home: Tattoo Style section title
  String get homeTattooStyle;

  /// Home: Explore Inspiration section title
  String get homeExploreInspiration;

  /// Home: Generate button label
  String get homeGenerate;

  /// Home: Tutorial overlay text
  String get homeTutorialOverlayText;

  /// Home: Explore item title - Gothqueen
  String get exploreTitleGothqueen;

  /// Home: Explore item prompt - Gothqueen
  String get explorePromptGothqueen;

  /// Home: Explore item title - Floral
  String get exploreTitleFloral;

  /// Home: Explore item prompt - Floral
  String get explorePromptFloral;

  /// Home: Explore item title - Skull with fedora and pipe
  String get exploreTitleSkullWithFedoraAndPipe;

  /// Home: Explore item prompt - Skull with fedora and pipe
  String get explorePromptSkullWithFedoraAndPipe;

  /// Home: Explore item title - Elegant snake tattoo
  String get exploreTitleElegantSnakeTattoo;

  /// Home: Explore item prompt - Elegant snake tattoo
  String get explorePromptElegantSnakeTattoo;

  /// Home: Explore item title - Feather and birds in flight
  String get exploreTitleFeatherAndBirdsInFlight;

  /// Home: Explore item prompt - Feather and birds in flight
  String get explorePromptFeatherAndBirdsInFlight;

  /// Home: Explore item title - Rainy bat with celestial stars
  String get exploreTitleRainyBatWithCelestialStars;

  /// Home: Explore item prompt - Rainy bat with celestial stars
  String get explorePromptRainyBatWithCelestialStars;

  /// Home: Explore item title - Elegant black cat silhouette design
  String get exploreTitleElegantBlackCatSilhouetteDesign;

  /// Home: Explore item prompt - Elegant black cat silhouette design
  String get explorePromptElegantBlackCatSilhouetteDesign;

  /// Home: Explore item title - Red rose tattoo design
  String get exploreTitleRedRoseTattooDesign;

  /// Home: Explore item prompt - Red rose tattoo design
  String get explorePromptRedRoseTattooDesign;

  /// Home: Explore item title - Black infinity arrow tattoo
  String get exploreTitleBlackInfinityArrowTattoo;

  /// Home: Explore item prompt - Black infinity arrow tattoo
  String get explorePromptBlackInfinityArrowTattoo;

  /// Home: Explore item title - Black scorpion tattoo design
  String get exploreTitleBlackScorpionTattooDesign;

  /// Home: Explore item prompt - Black scorpion tattoo design
  String get explorePromptBlackScorpionTattooDesign;

  /// Home: Explore item title - Crescent moon and star tattoo
  String get exploreTitleCrescentMoonAndStarTattoo;

  /// Home: Explore item prompt - Crescent moon and star tattoo
  String get explorePromptCrescentMoonAndStarTattoo;

  /// Home: Explore item title - Sleeping panda tattoo
  String get exploreTitleSleepingPandaTattoo;

  /// Home: Explore item prompt - Sleeping panda tattoo
  String get explorePromptSleepingPandaTattoo;

  /// Generic: Tattoo label (fallback style name)
  String get genericTattoo;

  /// Loading screen: generating message
  String get loadingGeneratingYourTattoo;

  /// Virtual try-on: processing failed message
  String get virtualTryOnProcessingFailedTryAgain;

  /// Result screen: Share button label
  String get resultShare;

  /// Result screen: No image to share message
  String get resultNoImageToShare;

  /// Result screen: Share text with style name
  String resultShareText(String styleName);

  /// Result screen: Share subject with style name
  String resultShareSubject(String styleName);

  /// Result screen: Error sharing message
  String resultErrorSharing(String error);

  /// Result screen: Image saved to gallery message
  String get resultImageSavedToGallery;

  /// Result screen: Error saving message
  String resultErrorSaving(String error);

  /// Flower home: title line 1
  ///
  /// In en, this message translates to:
  /// **'Transform your name'**
  String get flowerHomeTransformYourName;

  /// Flower home: title line 2
  ///
  /// In en, this message translates to:
  /// **'into a bouquet tattoo'**
  String get flowerHomeIntoABouquetTattoo;

  /// Flower home: create button label
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get flowerHomeCreate;

  /// Flower input screen: page title
  ///
  /// In en, this message translates to:
  /// **'Enter Your Name'**
  String get flowerInputEnterYourName;

  /// Flower loading screen: main loading message
  ///
  /// In en, this message translates to:
  /// **'Creating your floral tattoo...'**
  String get flowerLoadingCreatingYourFloralTattoo;

  /// Flower loading screen: subtitle with name placeholder
  ///
  /// In en, this message translates to:
  /// **'Designing "{name}" with beautiful flowers'**
  String flowerLoadingDesigningWithBeautifulFlowers(String name);

  /// Flower result screen: placeholder text with name
  ///
  /// In en, this message translates to:
  /// **'Floral tattoo for "{name}"'**
  String flowerResultFloralTattooFor(String name);

  /// Flower result screen: share text with name placeholder
  ///
  /// In en, this message translates to:
  /// **'Check out my floral tattoo design for "{name}"!'**
  String flowerResultShareText(String name);

  /// Flower result screen: share subject with name placeholder
  ///
  /// In en, this message translates to:
  /// **'Floral Tattoo: {name}'**
  String flowerResultShareSubject(String name);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
