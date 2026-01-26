import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

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

  /// Virtual try-on: processing failed message
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t process image. Try again.'**
  String get virtualTryOnProcessingFailedTryAgain;

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
  ///
  /// In en, this message translates to:
  /// **'Describe Your Dream Ink'**
  String get homeDescribeYourDreamInk;

  /// Home: Dream ink input hint
  ///
  /// In en, this message translates to:
  /// **'Tell us what you envision...'**
  String get homeDreamInkHint;

  /// Home: Inspiration label
  ///
  /// In en, this message translates to:
  /// **'Inspiration'**
  String get homeInspiration;

  /// Home: "characters remaining" suffix (prepend number in UI)
  ///
  /// In en, this message translates to:
  /// **'characters remaining'**
  String get homeCharactersRemaining;

  /// Home: Tattoo Style section title
  ///
  /// In en, this message translates to:
  /// **'Tattoo Style'**
  String get homeTattooStyle;

  /// Home: Explore Inspiration section title
  ///
  /// In en, this message translates to:
  /// **'Explore Inspiration'**
  String get homeExploreInspiration;

  /// Home: Generate button label
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get homeGenerate;

  /// Home: Tutorial overlay text
  ///
  /// In en, this message translates to:
  /// **'Describe the tattoo you have in mind, or tap \'Inspiration\' for ideas'**
  String get homeTutorialOverlayText;

  /// Home: Explore item title - Gothqueen
  ///
  /// In en, this message translates to:
  /// **'Gothqueen'**
  String get exploreTitleGothqueen;

  /// Home: Explore item prompt - Gothqueen
  ///
  /// In en, this message translates to:
  /// **'Black and grey gothic queen tattoo, bald female face, ornate crown, geometric linework, realistic shading, symmetrical, high detail'**
  String get explorePromptGothqueen;

  /// Home: Explore item title - Floral
  ///
  /// In en, this message translates to:
  /// **'Floral'**
  String get exploreTitleFloral;

  /// Home: Explore item prompt - Floral
  ///
  /// In en, this message translates to:
  /// **'Beautiful floral tattoo design with intricate petals and leaves, natural flowing curves, botanical tattoo style, detailed line-work, solid white ink, high contrast'**
  String get explorePromptFloral;

  /// Home: Explore item title - Skull with fedora and pipe
  ///
  /// In en, this message translates to:
  /// **'Skull with fedora and pipe'**
  String get exploreTitleSkullWithFedoraAndPipe;

  /// Home: Explore item prompt - Skull with fedora and pipe
  ///
  /// In en, this message translates to:
  /// **'Realistic black & grey skull tattoo, side-profile skull wearing a classic fedora, smoking a curved pipe with soft upward smoke, vintage noir style, detailed bone & teeth texture, smooth gradient shading with dotwork and soft realism, fine-needle detailing, high-contrast blacks, professional tattoo artwork.'**
  String get explorePromptSkullWithFedoraAndPipe;

  /// Home: Explore item title - Elegant snake tattoo
  ///
  /// In en, this message translates to:
  /// **'Elegant snake tattoo'**
  String get exploreTitleElegantSnakeTattoo;

  /// Home: Explore item prompt - Elegant snake tattoo
  ///
  /// In en, this message translates to:
  /// **'Ultra-detailed black & white aggressive snake tattoo, open mouth with long fangs and forked tongue, flowing coiled body, fine-line detailed scales, deep black shading, strong contrast, realistic depth, clean negative space, traditional engraving × modern realism, razor-sharp outlines, monochrome ink, no background, professional tattoo flash, forearm or sleeve ready.'**
  String get explorePromptElegantSnakeTattoo;

  /// Home: Explore item title - Feather and birds in flight
  ///
  /// In en, this message translates to:
  /// **'Feather and birds in flight'**
  String get exploreTitleFeatherAndBirdsInFlight;

  /// Home: Explore item prompt - Feather and birds in flight
  ///
  /// In en, this message translates to:
  /// **'Ultra-detailed black & white feather tattoo, elegant realistic feather with fine linework, symmetrical barbs and sharp spine, smooth dotwork gradient shading, minimal premium fineline style, small bird silhouettes flowing upward, balanced composition, razor-sharp outlines, high-contrast black ink, modern tattoo realism, monochrome only, no background on white canvas, professional flash, stencil-ready.'**
  String get explorePromptFeatherAndBirdsInFlight;

  /// Home: Explore item title - Rainy bat with celestial stars
  ///
  /// In en, this message translates to:
  /// **'Rainy bat with celestial stars'**
  String get exploreTitleRainyBatWithCelestialStars;

  /// Home: Explore item prompt - Rainy bat with celestial stars
  ///
  /// In en, this message translates to:
  /// **'Symmetrical bat tattoo with fully spread wings, solid black body, wings filled with smooth rainbow gradient (purple to blue, green, yellow, orange), clean bold outlines with fine linework, subtle dotwork shading, surrounded by small stars and dots, two four-pointed stars above and below, mystical celestial vibe, modern neo-traditional style, high contrast, sharp detail.'**
  String get explorePromptRainyBatWithCelestialStars;

  /// Home: Explore item title - Elegant black cat silhouette design
  ///
  /// In en, this message translates to:
  /// **'Elegant black cat silhouette design'**
  String get exploreTitleElegantBlackCatSilhouetteDesign;

  /// Home: Explore item prompt - Elegant black cat silhouette design
  ///
  /// In en, this message translates to:
  /// **'A minimalist black cat tattoo design in elegant abstract style, side-profile sitting cat with a long flowing curved tail, smooth sweeping lines and sharp tapered edges, solid black ink with subtle gradient shading for depth, geometric and fluid shapes forming the body, delicate whisker lines extending from the face, modern fine-line tattoo style, high contrast, clean negative space, sophisticated and artistic look, tattoo flash art'**
  String get explorePromptElegantBlackCatSilhouetteDesign;

  /// Home: Explore item title - Red rose tattoo design
  ///
  /// In en, this message translates to:
  /// **'Red rose tattoo design'**
  String get exploreTitleRedRoseTattooDesign;

  /// Home: Explore item prompt - Red rose tattoo design
  ///
  /// In en, this message translates to:
  /// **'Realistic red rose tattoo, single blooming rose with layered petals, rich deep red color, fine detailed petal texture, subtle gradient shading, natural green stem with small thorns and two detailed leaves, clean crisp outlines, soft realism tattoo style, high contrast, smooth color blending, professional tattoo flash quality, isolated rose only'**
  String get explorePromptRedRoseTattooDesign;

  /// Home: Explore item title - Black infinity arrow tattoo
  ///
  /// In en, this message translates to:
  /// **'Black infinity arrow tattoo'**
  String get exploreTitleBlackInfinityArrowTattoo;

  /// Home: Explore item prompt - Black infinity arrow tattoo
  ///
  /// In en, this message translates to:
  /// **'Realistic Minimalist black infinity arrow tattoo, smooth continuous loop with sharp arrow, clean bold linework, high-contrast solid black ink, modern minimal style, monochrome, stencil-ready.'**
  String get explorePromptBlackInfinityArrowTattoo;

  /// Home: Explore item title - Black scorpion tattoo design
  ///
  /// In en, this message translates to:
  /// **'Black scorpion tattoo design'**
  String get exploreTitleBlackScorpionTattooDesign;

  /// Home: Explore item prompt - Black scorpion tattoo design
  ///
  /// In en, this message translates to:
  /// **'Realistic minimalist black scorpion tattoo design, bold solid black ink, sharp clean linework, symmetrical tribal-inspired detailing, high contrast, smooth curves, modern tattoo style, stencil-ready, isolated on plain background, ultra-detailed, professional tattoo flash'**
  String get explorePromptBlackScorpionTattooDesign;

  /// Home: Explore item title - Crescent moon and star tattoo
  ///
  /// In en, this message translates to:
  /// **'Crescent moon and star tattoo'**
  String get exploreTitleCrescentMoonAndStarTattoo;

  /// Home: Explore item prompt - Crescent moon and star tattoo
  ///
  /// In en, this message translates to:
  /// **'Minimalist black ink tattoo, fine-line style, upward crescent moon with solid black fill, small four-point star above aligned vertically, subtle dot accents, celestial and mystical aesthetic, simple geometry, balanced spacing, clean background, precise linework, high contrast, timeless minimal tattoo design'**
  String get explorePromptCrescentMoonAndStarTattoo;

  /// Home: Explore item title - Sleeping panda tattoo
  ///
  /// In en, this message translates to:
  /// **'Sleeping panda tattoo'**
  String get exploreTitleSleepingPandaTattoo;

  /// Home: Explore item prompt - Sleeping panda tattoo
  ///
  /// In en, this message translates to:
  /// **'Minimalist cute panda tattoo, tiny sleeping panda lying on its side, simple rounded shape, solid black and white ink, soft smooth fills, minimal facial details, clean edges, modern minimalist tattoo style, monochrome, no background, white canvas, stencil-ready.'**
  String get explorePromptSleepingPandaTattoo;

  /// Generic: Tattoo label (fallback style name)
  ///
  /// In en, this message translates to:
  /// **'Tattoo'**
  String get genericTattoo;

  /// Loading screen: generating message
  ///
  /// In en, this message translates to:
  /// **'Generating your tattoo..'**
  String get loadingGeneratingYourTattoo;

  /// Result screen: Share button label
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get resultShare;

  /// Result screen: No image to share message
  ///
  /// In en, this message translates to:
  /// **'No image to share'**
  String get resultNoImageToShare;

  /// Result screen: Share text with style name
  ///
  /// In en, this message translates to:
  /// **'Check out my {styleName} tattoo design!'**
  String resultShareText(String styleName);

  /// Result screen: Share subject with style name
  ///
  /// In en, this message translates to:
  /// **'{styleName} Tattoo Design'**
  String resultShareSubject(String styleName);

  /// Result screen: Error sharing message
  ///
  /// In en, this message translates to:
  /// **'Error sharing: {error}'**
  String resultErrorSharing(String error);

  /// Result screen: Image saved to gallery message
  ///
  /// In en, this message translates to:
  /// **'Image saved to gallery'**
  String get resultImageSavedToGallery;

  /// Result screen: Error saving message
  ///
  /// In en, this message translates to:
  /// **'Error saving image: {error}'**
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
  /// **'Designing \"{name}\" with beautiful flowers'**
  String flowerLoadingDesigningWithBeautifulFlowers(String name);

  /// Flower result screen: placeholder text with name
  ///
  /// In en, this message translates to:
  /// **'Floral tattoo for \"{name}\"'**
  String flowerResultFloralTattooFor(String name);

  /// Flower result screen: share text with name placeholder
  ///
  /// In en, this message translates to:
  /// **'Check out my floral tattoo design for \"{name}\"!'**
  String flowerResultShareText(String name);

  /// Flower result screen: share subject with name placeholder
  ///
  /// In en, this message translates to:
  /// **'Floral Tattoo: {name}'**
  String flowerResultShareSubject(String name);

  /// Tattoo page: welcome text line 1
  ///
  /// In en, this message translates to:
  /// **'Turn your name into a'**
  String get tattooPageTurnYourNameIntoA;

  /// Tattoo page: welcome text line 2
  ///
  /// In en, this message translates to:
  /// **'one-of-a-kind tattoo'**
  String get tattooPageOneOfAKindTattoo;

  /// Step birthday page: question text
  ///
  /// In en, this message translates to:
  /// **'What\'s your birthday?'**
  String get stepBirthdayWhatsYourBirthday;

  /// Month name: January
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJanuary;

  /// Month name: February
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFebruary;

  /// Month name: March
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMarch;

  /// Month name: April
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApril;

  /// Month name: May
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// Month name: June
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJune;

  /// Month name: July
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJuly;

  /// Month name: August
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAugust;

  /// Month name: September
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSeptember;

  /// Month name: October
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOctober;

  /// Month name: November
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNovember;

  /// Month name: December
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDecember;

  /// Step name page: question text
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get stepNameWhatsYourName;

  /// Step name page: input hint text
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get stepNameHint;

  /// Step location page: question text
  ///
  /// In en, this message translates to:
  /// **'Where you born?'**
  String get stepLocationWhereYouBorn;

  /// Step location page: input hint text
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get stepLocationHint;

  /// Step style selection page: question text
  ///
  /// In en, this message translates to:
  /// **'Pick your title style'**
  String get stepStylePickYourTitleStyle;

  /// Step tattoo idea page: question text
  ///
  /// In en, this message translates to:
  /// **'What your tattoo idea?'**
  String get stepTattooIdeaWhatYourTattooIdea;

  /// Step tattoo idea page: input hint text
  ///
  /// In en, this message translates to:
  /// **'Describe your tattoo idea...'**
  String get stepTattooIdeaHint;

  /// Zodiac sign name: Capricorn
  ///
  /// In en, this message translates to:
  /// **'Capricorn'**
  String get zodiacCapricornName;

  /// Zodiac sign date range: Capricorn
  ///
  /// In en, this message translates to:
  /// **'December 22 – January 19'**
  String get zodiacCapricornDateRange;

  /// Zodiac sign description: Capricorn
  ///
  /// In en, this message translates to:
  /// **'Disciplined and ambitious, with a grounded and responsible nature. They value success and prefer building their future through patience and hard work.'**
  String get zodiacCapricornDescription;

  /// Zodiac sign name: Aquarius
  ///
  /// In en, this message translates to:
  /// **'Aquarius'**
  String get zodiacAquariusName;

  /// Zodiac sign date range: Aquarius
  ///
  /// In en, this message translates to:
  /// **'January 20 – February 18'**
  String get zodiacAquariusDateRange;

  /// Zodiac sign description: Aquarius
  ///
  /// In en, this message translates to:
  /// **'Independent and creative, with a free-spirited and original nature. They value freedom and prefer expressing their individuality with unique ideas.'**
  String get zodiacAquariusDescription;

  /// Zodiac sign name: Pisces
  ///
  /// In en, this message translates to:
  /// **'Pisces'**
  String get zodiacPiscesName;

  /// Zodiac sign date range: Pisces
  ///
  /// In en, this message translates to:
  /// **'February 19 – March 20'**
  String get zodiacPiscesDateRange;

  /// Zodiac sign description: Pisces
  ///
  /// In en, this message translates to:
  /// **'Gentle and dreamy, with a sensitive and compassionate nature. They value emotions and prefer living through imagination, kindness, and deep understanding.'**
  String get zodiacPiscesDescription;

  /// Zodiac sign name: Aries
  ///
  /// In en, this message translates to:
  /// **'Aries'**
  String get zodiacAriesName;

  /// Zodiac sign date range: Aries
  ///
  /// In en, this message translates to:
  /// **'March 21 – April 19'**
  String get zodiacAriesDateRange;

  /// Zodiac sign description: Aries
  ///
  /// In en, this message translates to:
  /// **'Bold and energetic, with a confident and fearless nature. They love taking initiative and prefer leading with passion and determination.'**
  String get zodiacAriesDescription;

  /// Zodiac sign name: Taurus
  ///
  /// In en, this message translates to:
  /// **'Taurus'**
  String get zodiacTaurusName;

  /// Zodiac sign date range: Taurus
  ///
  /// In en, this message translates to:
  /// **'April 20 – May 20'**
  String get zodiacTaurusDateRange;

  /// Zodiac sign description: Taurus
  ///
  /// In en, this message translates to:
  /// **'Bold and energetic, with a confident and fearless nature. They love taking initiative and prefer leading with passion and determination.'**
  String get zodiacTaurusDescription;

  /// Zodiac sign name: Gemini
  ///
  /// In en, this message translates to:
  /// **'Gemini'**
  String get zodiacGeminiName;

  /// Zodiac sign date range: Gemini
  ///
  /// In en, this message translates to:
  /// **'May 21 – June 20'**
  String get zodiacGeminiDateRange;

  /// Zodiac sign description: Gemini
  ///
  /// In en, this message translates to:
  /// **'Curious and lively, with a quick-minded and adaptable nature. They enjoy communication and prefer exploring new ideas with excitement.'**
  String get zodiacGeminiDescription;

  /// Zodiac sign name: Cancer
  ///
  /// In en, this message translates to:
  /// **'Cancer'**
  String get zodiacCancerName;

  /// Zodiac sign date range: Cancer
  ///
  /// In en, this message translates to:
  /// **'June 21 – July 22'**
  String get zodiacCancerDateRange;

  /// Zodiac sign description: Cancer
  ///
  /// In en, this message translates to:
  /// **'Sensitive and caring, with a deeply emotional and protective nature. They value close connections and prefer nurturing others with warmth and loyalty.'**
  String get zodiacCancerDescription;

  /// Zodiac sign name: Leo
  ///
  /// In en, this message translates to:
  /// **'Leo'**
  String get zodiacLeoName;

  /// Zodiac sign date range: Leo
  ///
  /// In en, this message translates to:
  /// **'July 23 – August 22'**
  String get zodiacLeoDateRange;

  /// Zodiac sign description: Leo
  ///
  /// In en, this message translates to:
  /// **'Confident and charismatic, with a bold and generous nature. They enjoy being admired and prefer expressing themselves with creativity and pride.'**
  String get zodiacLeoDescription;

  /// Zodiac sign name: Virgo
  ///
  /// In en, this message translates to:
  /// **'Virgo'**
  String get zodiacVirgoName;

  /// Zodiac sign date range: Virgo
  ///
  /// In en, this message translates to:
  /// **'August 23 – September 22'**
  String get zodiacVirgoDateRange;

  /// Zodiac sign description: Virgo
  ///
  /// In en, this message translates to:
  /// **'Practical and thoughtful, with a detail-focused and hardworking nature. They value discipline and prefer bringing order and care into everything they do.'**
  String get zodiacVirgoDescription;

  /// Zodiac sign name: Libra
  ///
  /// In en, this message translates to:
  /// **'Libra'**
  String get zodiacLibraName;

  /// Zodiac sign date range: Libra
  ///
  /// In en, this message translates to:
  /// **'September 23 – October 22'**
  String get zodiacLibraDateRange;

  /// Zodiac sign description: Libra
  ///
  /// In en, this message translates to:
  /// **'Charming and balanced, with a peaceful and fair-minded nature. They value harmony and prefer building connections through kindness and understanding.'**
  String get zodiacLibraDescription;

  /// Zodiac sign name: Scorpio
  ///
  /// In en, this message translates to:
  /// **'Scorpio'**
  String get zodiacScorpioName;

  /// Zodiac sign date range: Scorpio
  ///
  /// In en, this message translates to:
  /// **'October 23 – November 21'**
  String get zodiacScorpioDateRange;

  /// Zodiac sign description: Scorpio
  ///
  /// In en, this message translates to:
  /// **'Intense and passionate, with a powerful and mysterious nature. They value loyalty and prefer deep connections built on trust and strength.'**
  String get zodiacScorpioDescription;

  /// Zodiac sign name: Sagittarius
  ///
  /// In en, this message translates to:
  /// **'Sagittarius'**
  String get zodiacSagittariusName;

  /// Zodiac sign date range: Sagittarius
  ///
  /// In en, this message translates to:
  /// **'November 22 – December 21'**
  String get zodiacSagittariusDateRange;

  /// Zodiac sign description: Sagittarius
  ///
  /// In en, this message translates to:
  /// **'Adventurous and optimistic, with a free-loving and curious nature. They value exploration and prefer chasing new experiences with excitement and independence.'**
  String get zodiacSagittariusDescription;

  /// Tattoo style label: Dragon
  ///
  /// In en, this message translates to:
  /// **'Dragon'**
  String get styleDragon;

  /// Tattoo style label: Unicorn
  ///
  /// In en, this message translates to:
  /// **'Unicorn'**
  String get styleUnicorn;

  /// Tattoo style label: Floral
  ///
  /// In en, this message translates to:
  /// **'Floral'**
  String get styleFloral;

  /// Tattoo style label: Abstract
  ///
  /// In en, this message translates to:
  /// **'Abstract'**
  String get styleAbstract;

  /// Tattoo style label: Butterfly
  ///
  /// In en, this message translates to:
  /// **'Butterfly'**
  String get styleButterfly;

  /// Tattoo style label: Eagle
  ///
  /// In en, this message translates to:
  /// **'Eagle'**
  String get styleEagle;

  /// Tattoo style label: Lion
  ///
  /// In en, this message translates to:
  /// **'Lion'**
  String get styleLion;

  /// Tattoo style label: Spider
  ///
  /// In en, this message translates to:
  /// **'Spider'**
  String get styleSpider;

  /// Tattoo style label: Wolf
  ///
  /// In en, this message translates to:
  /// **'Wolf'**
  String get styleWolf;

  /// Onboarding header: step indicator text
  ///
  /// In en, this message translates to:
  /// **'Step {currentStep}/5'**
  String onboardingStep(int currentStep);

  /// Onboarding next button: text for final step
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// Ad badge label in drawer menu
  ///
  /// In en, this message translates to:
  /// **'Ad'**
  String get ad;

  /// Language name: English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Language name: Spanish
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// Language name: French
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// Language name: German
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// Language name: Italian
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get languageItalian;

  /// Language name: Portuguese
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// Language name: Russian
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// Language name: Chinese
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// Language name: Japanese
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get languageJapanese;

  /// Language name: Korean
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get languageKorean;

  /// Language name: Arabic
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// Exit confirmation dialog: title
  ///
  /// In en, this message translates to:
  /// **'Exit App?'**
  String get exitAppTitle;

  /// Exit confirmation dialog: message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get exitAppMessage;

  /// Exit confirmation dialog: exit button label
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
