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
  /// **'Flower Tattoos'**
  String get tattooCreation;

  /// Description text for first onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Name into stunning bouquet'**
  String get tattooCreationDescription;

  /// Title for second onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Discover Inspiration'**
  String get customCreation;

  /// Description text for second onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Browse unique tattoo styles.'**
  String get customCreationDescription;

  /// Title for third onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Tattoo Maker'**
  String get tattooMaker;

  /// Title label for Moon Owl onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Moon Owl'**
  String get moonOwl;

  /// Title for Moon Owl AI tattoo generator section
  ///
  /// In en, this message translates to:
  /// **'AI Tattoo Generator'**
  String get moonOwlTitle;

  /// Subtitle for Moon Owl AI tattoo generator section
  ///
  /// In en, this message translates to:
  /// **'Type an idea. See the design.'**
  String get moonOwlSubtitle;

  /// Title for fourth onboarding screen - try-on flow
  ///
  /// In en, this message translates to:
  /// **'Try On AI Tattoos'**
  String get tryOnAiTattoos;

  /// Subtitle for fourth onboarding screen - try-on flow
  ///
  /// In en, this message translates to:
  /// **'See how your tattoo looks on you.'**
  String get tryOnAiTattoosSubtitle;

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

  /// History page title and header button
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Empty state when no history items
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

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

  /// Toast: item added to favorites
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get favoritesAdded;

  /// Toast: item removed from favorites
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get favoritesRemoved;

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

  /// Toast message shown when a history tattoo entry is deleted
  ///
  /// In en, this message translates to:
  /// **'Tattoo deleted'**
  String get tattooDeleted;

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

  /// Virtual try-on: dialog title for camera vs gallery
  ///
  /// In en, this message translates to:
  /// **'Choose photo source'**
  String get choosePhotoSource;

  /// Virtual try-on: pick image from gallery option
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

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
  /// **'Try This Prompt'**
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

  /// Home: style prompt for Dragon — rich Eastern-inspired fiery dragon aesthetic
  ///
  /// In en, this message translates to:
  /// **'Create a tattoo design based on the Dragon Style. Use bold, fiery colors like red, orange, and gold, incorporating intricate scales and fierce lines. Focus on sharp, textured details with dramatic shadows for a dynamic, powerful look. Eastern-inspired aesthetic, emphasizing movement and strength. The subject should have fiery, dragon-like details, scales embedded in the design, sharp fierce lines, and dramatic shading. Flowing, powerful forms that evoke strength and energy, as if breathing fire, with aggressive and mythical elements.'**
  String get tattooStylePromptDragon;

  /// Home: style prompt for Unicorn
  ///
  /// In en, this message translates to:
  /// **'Create a tattoo design based on the Unicorn Style. Use pastel colors such as soft pinks, blues, purples, and silvers. Smooth, flowing lines, sparkles and glows for a magical, whimsical feeling. Soft, airy textures, subtle highlights, whimsical details like stars and light reflections. Dreamlike, emphasizing elegance, grace, and fantasy. The subject should have soft flowing lines, magical accents like stars or sparkles, graceful gentle curves, whimsical highlights, ethereal magical quality, bathed in pastel colors, lightness and enchantment evoking fantasy and dreams.'**
  String get tattooStylePromptUnicorn;

  /// Home: style prompt for Floral
  ///
  /// In en, this message translates to:
  /// **'Create a tattoo design based on the Floral Style. Use muted, natural colors such as blush pinks, soft whites, and earthy greens. The design should incorporate delicate, intricate petals, soft lines, and flowing, graceful curves. Focus on gentle shading with realistic textures to evoke a sense of natural beauty and serenity. The design should have an elegant, organic aesthetic, emphasizing delicacy and peacefulness. Now, incorporate the subject into this style. The subject should have soft, floral details, with petals or leaves subtly woven into the design, graceful curves, and natural textures. The design should reflect calmness and beauty, with a sense of elegance and natural harmony. The subject should be surrounded by floral elements, making it appear delicate, feminine, and natural, with gentle shading and light highlights.'**
  String get tattooStylePromptFloral;

  /// Home: "Describe Your Dream Ink" title
  ///
  /// In en, this message translates to:
  /// **'Describe Your Tattoo Idea'**
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

  /// Home: Any Category section title
  ///
  /// In en, this message translates to:
  /// **'Any Category'**
  String get homeExploreInspiration;

  /// Home: See all link for category row
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// Home: Generate button label
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get homeGenerate;

  /// Creation home: free-user gate dialog main message
  ///
  /// In en, this message translates to:
  /// **'Just one last step before your design is ready!'**
  String get creationFreeGateTitle;

  /// Creation: free gate primary CTA to paywall
  ///
  /// In en, this message translates to:
  /// **'Remove Limits'**
  String get creationFreeGateRemoveLimits;

  /// Creation: free gate secondary CTA to watch ad
  ///
  /// In en, this message translates to:
  /// **'Watch an Ad'**
  String get creationFreeGateWatchAd;

  /// Creation: remaining free generations shown on Watch Ad row
  ///
  /// In en, this message translates to:
  /// **'{remaining}/{total}'**
  String creationFreeGateAdUsesCounter(int remaining, int total);

  /// Creation: toast when free tier exhausted
  ///
  /// In en, this message translates to:
  /// **'You have used all free designs. Remove limits to continue.'**
  String get creationFreeGateNoGenerationsLeft;

  /// Creation: locked grid card subtitle
  ///
  /// In en, this message translates to:
  /// **'Unlock all designs!'**
  String get creationMultiUnlockAllDesigns;

  /// Creation: free multi-result bottom button
  ///
  /// In en, this message translates to:
  /// **'Recreate'**
  String get creationMultiRecreate;

  /// Creation: short Pro label on locked card
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get creationMultiProBadge;

  /// Rewarded ad: shown when the rewarded ad fails to load/show
  ///
  /// In en, this message translates to:
  /// **'Ad not available right now. Please try again.'**
  String get rewardedAdNotAvailableTryAgain;

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

  /// Title for delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Entry'**
  String get deleteConfirmationTitle;

  /// Content for delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this design from your history? This action cannot be undone.'**
  String get deleteConfirmationContent;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

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
  /// **'Successfully Downloaded'**
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
  /// **'Step {currentStep}/4'**
  String onboardingStep(int currentStep);

  /// Toast shown when user tries to favorite after free limit
  ///
  /// In en, this message translates to:
  /// **'Buy Premium to add to favourites'**
  String get buyPremiumToAddToFavourites;

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

  /// Exit confirmation dialog: confirm button
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// History selection mode: title showing count
  ///
  /// In en, this message translates to:
  /// **'{count} Selected'**
  String historySelected(int count);

  /// History selection mode: select all button
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get historySelectAll;

  /// History selection mode: deselect all button
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get historyDeselectAll;

  /// History page: enter selection mode button
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get historySelect;

  /// Toast on home when device has no internet
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Some features may not work.'**
  String get noInternetConnectionSomeFeatures;

  /// Toast during generation when network fails
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get noInternetConnectionPleaseCheckNetwork;

  /// Splash screen notice shown only for second-time users when splash ads may run
  ///
  /// In en, this message translates to:
  /// **'This action may perform an ad.'**
  String get splashAdMayShowNotice;

  /// Explore category: Minimal Tattoos
  ///
  /// In en, this message translates to:
  /// **'Minimal Tattoos'**
  String get exploreCategoryMinimal;

  /// Explore category description: Minimal Tattoos
  ///
  /// In en, this message translates to:
  /// **'Simple, clean lines with minimalist aesthetic. Perfect for subtle, elegant designs.'**
  String get exploreCategoryMinimalDescription;

  /// Explore category: Traditional & Old School
  ///
  /// In en, this message translates to:
  /// **'Traditional & Old School'**
  String get exploreCategoryTraditional;

  /// Explore category description: Traditional & Old School
  ///
  /// In en, this message translates to:
  /// **'Bold lines, vibrant colors, and classic American traditional style.'**
  String get exploreCategoryTraditionalDescription;

  /// Explore category: Japanese Style
  ///
  /// In en, this message translates to:
  /// **'Japanese Style'**
  String get exploreCategoryJapanese;

  /// Explore category description: Japanese Style
  ///
  /// In en, this message translates to:
  /// **'Traditional Japanese irezumi with dragons, koi fish, and cherry blossoms.'**
  String get exploreCategoryJapaneseDescription;

  /// Explore category: Tribal Designs
  ///
  /// In en, this message translates to:
  /// **'Tribal Designs'**
  String get exploreCategoryTribal;

  /// Explore category description: Tribal Designs
  ///
  /// In en, this message translates to:
  /// **'Bold black patterns inspired by Polynesian and tribal art.'**
  String get exploreCategoryTribalDescription;

  /// Explore category: Geometric Tattoos
  ///
  /// In en, this message translates to:
  /// **'Geometric Tattoos'**
  String get exploreCategoryGeometric;

  /// Explore category description: Geometric Tattoos
  ///
  /// In en, this message translates to:
  /// **'Sacred geometry, mandalas, and precise geometric patterns.'**
  String get exploreCategoryGeometricDescription;

  /// Explore category: Realism & Portrait
  ///
  /// In en, this message translates to:
  /// **'Realism & Portrait'**
  String get exploreCategoryRealism;

  /// Explore category description: Realism & Portrait
  ///
  /// In en, this message translates to:
  /// **'Photorealistic portraits and detailed realistic imagery.'**
  String get exploreCategoryRealismDescription;

  /// Explore category: Lettering & Script
  ///
  /// In en, this message translates to:
  /// **'Lettering & Script'**
  String get exploreCategoryLettering;

  /// Explore category description: Lettering & Script
  ///
  /// In en, this message translates to:
  /// **'Beautiful typography, calligraphy, and meaningful quotes.'**
  String get exploreCategoryLetteringDescription;

  /// Explore category: Floral & Nature
  ///
  /// In en, this message translates to:
  /// **'Floral & Nature'**
  String get exploreCategoryFloral;

  /// Explore category description: Floral & Nature
  ///
  /// In en, this message translates to:
  /// **'Flowers, plants, and natural elements in beautiful compositions.'**
  String get exploreCategoryFloralDescription;

  /// Explore category: Mythology & Fantasy
  ///
  /// In en, this message translates to:
  /// **'Mythology & Fantasy'**
  String get exploreCategoryMythology;

  /// Explore category description: Mythology & Fantasy
  ///
  /// In en, this message translates to:
  /// **'Mythical creatures, gods, and fantasy-inspired designs.'**
  String get exploreCategoryMythologyDescription;

  /// Explore category: Custom AI Designs
  ///
  /// In en, this message translates to:
  /// **'Custom AI Designs'**
  String get exploreCategoryCustomAi;

  /// Explore category description: Custom AI Designs
  ///
  /// In en, this message translates to:
  /// **'Unique AI-generated designs combining multiple styles.'**
  String get exploreCategoryCustomAiDescription;

  /// Explore item title: Minimalist Panda
  ///
  /// In en, this message translates to:
  /// **'Minimalist Panda'**
  String get exploreItemMinimalistPanda;

  /// Explore item prompt: Minimalist Panda
  ///
  /// In en, this message translates to:
  /// **'A tiny minimalist  tattoo of a cute panda sitting upright, facing slightly right, drawn with clean black lines and soft micro-shading. The panda holds a thin green stem with small purple lavender flowers, with subtle botanical detail and glossy black ears and arms. The design is centered on ankle skin, photographed in natural light with shallow depth of field and a minimal, professional tattoo reference style in a 1:1 composition.'**
  String get exploreItemMinimalistPandaPrompt;

  /// Explore item title: Fine-Line Bow
  ///
  /// In en, this message translates to:
  /// **'Fine-Line Bow'**
  String get exploreItemFineLineBow;

  /// Explore item prompt: Fine-Line Bow
  ///
  /// In en, this message translates to:
  /// **'A tiny minimalist inner-wrist tattoo of a delicate ribbon bow, drawn with thin black linework and a small center knot. The design is symmetrical, clean, and micro-tattoo style, placed on smooth pale wrist skin. Shot in soft natural light with shallow depth of field, it has a modern minimalist aesthetic and professional tattoo reference look.'**
  String get exploreItemFineLineBowPrompt;

  /// Explore item title: Micro Realism Finger Tattoos
  ///
  /// In en, this message translates to:
  /// **'Micro Realism Finger Tattoos'**
  String get exploreItemMicroRealismFinger;

  /// Explore item prompt: Micro Realism Finger Tattoos
  ///
  /// In en, this message translates to:
  /// **'An ultra-realistic macro shot of a middle finger showing two tiny micro tattoos above the knuckle: a small sitting cat facing right and a delicate butterfly with fine linework and subtle shading. The scene features natural skin texture, warm neutral lighting, shallow depth of field, and a clean beige background, styled like a high-detail professional tattoo reference photo.'**
  String get exploreItemMicroRealismFingerPrompt;

  /// Explore item title: Fine-Line Cat in Circle
  ///
  /// In en, this message translates to:
  /// **'Fine-Line Cat in Circle'**
  String get exploreItemFineLineCatCircle;

  /// Explore item prompt: Fine-Line Cat in Circle
  ///
  /// In en, this message translates to:
  /// **'A minimalist upper-back tattoo below the neck showing a small black silhouette cat sitting and facing away, with a long curved tail. It\'s encircled by a thin, delicate incomplete circle with tiny leaves and a small flower, done in ultra-clean fine-line black ink. The scene features realistic skin texture, soft natural lighting, shallow depth of field, and a modern, photorealistic tattoo reference style.'**
  String get exploreItemFineLineCatCirclePrompt;

  /// Explore item title: Fine-Line Lotus Flower
  ///
  /// In en, this message translates to:
  /// **'Fine-Line Lotus Flower'**
  String get exploreItemFineLineLotusFlower;

  /// Explore item prompt: Fine-Line Lotus Flower
  ///
  /// In en, this message translates to:
  /// **'A minimalist fine-line lotus flower tattoo with delicate layered petals and a thin stem with small leaves and buds, done in clean black ink. Beside it sits a small solid black heart with two tiny dots, all in a micro-tattoo style. The design is centered on smooth skin, photographed in warm natural light with shallow depth of field and a modern, photorealistic tattoo reference aesthetic.'**
  String get exploreItemFineLineLotusFlowerPrompt;

  /// Explore item title: Sleeping Cat in Crescent Moon
  ///
  /// In en, this message translates to:
  /// **'Sleeping Cat in Crescent Moon'**
  String get exploreItemSleepingCatCrescent;

  /// Explore item prompt: Sleeping Cat in Crescent Moon
  ///
  /// In en, this message translates to:
  /// **'A tiny minimalist micro tattoo of a sleeping kitten curled inside a thin crescent moon, with soft black-and-grey shading and delicate sparkles around it. The design features clean fine-line work and subtle fur detail, placed on wrist or forearm skin and photographed in warm natural light with a shallow depth of field for a high-detail, photorealistic tattoo reference look.'**
  String get exploreItemSleepingCatCrescentPrompt;

  /// Explore item title: Fine-Line Heart and Stars
  ///
  /// In en, this message translates to:
  /// **'Fine-Line Heart and Stars'**
  String get exploreItemFineLineHeartStars;

  /// Explore item prompt: Fine-Line Heart and Stars
  ///
  /// In en, this message translates to:
  /// **'A minimalist geometric tattoo featuring a solid black heart with sharp edges, flanked by thin four-point star sparkles above and below. Small black dots and tiny outlined circles form a symmetrical vertical layout around it.  high-detail tattoo reference style white background'**
  String get exploreItemFineLineHeartStarsPrompt;

  /// Explore item title: Fine-Line Compass Star
  ///
  /// In en, this message translates to:
  /// **'Fine-Line Compass Star'**
  String get exploreItemFineLineCompassStar;

  /// Explore item prompt: Fine-Line Compass Star
  ///
  /// In en, this message translates to:
  /// **'A minimalist inner-forearm micro tattoo featuring a centered geometric compass-style 8-point star with sharp, clean black lines and four tiny dots around it. A small outline heart sits directly below the star. The design is ultra-clean and symmetrical, photographed on smooth skin with soft natural lighting and a modern, photorealistic tattoo reference style.'**
  String get exploreItemFineLineCompassStarPrompt;

  /// Explore item title: Minimal Treble Clef Neck
  ///
  /// In en, this message translates to:
  /// **'Minimal Treble Clef Neck'**
  String get exploreItemMinimalTrebleClef;

  /// Explore item prompt: Minimal Treble Clef Neck
  ///
  /// In en, this message translates to:
  /// **'A small glossy black treble clef tattoo with three tiny music notes, . Done in bold, clean lines, it\'s photographed in soft warm lighting with texture  and a shallow depth of field for a detailed, minimal tattoo reference look., tattoo design, inspired by exploreitemminimaltrebleclef style, aesthetic only, stencil-ready design, art print on blank white paper, black and white, line art, minimalist, intricate details, standalone tattoo design, white background, high contrast, 2d only, flat design, isolated artwork, STRICTLY NO human body parts whatsoever: and white background'**
  String get exploreItemMinimalTrebleClefPrompt;

  /// Explore item title: Starry Heart
  ///
  /// In en, this message translates to:
  /// **'Starry Heart'**
  String get exploreItemStarryHeart;

  /// Explore item prompt: Starry Heart
  ///
  /// In en, this message translates to:
  /// **'A minimalist fine-line inner tattoo featuring a medium outlined heart with tiny dotted details inside, surrounded by small stars and solid dots, done in clean black micro-tattoo style on a white background, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, high contrast, 2D only, flat design, isolated artwork.'**
  String get exploreItemStarryHeartPrompt;

  /// Explore item title: Valknut Triangle
  ///
  /// In en, this message translates to:
  /// **'Valknut Triangle'**
  String get exploreItemValknutTriangle;

  /// Explore item prompt: Valknut Triangle
  ///
  /// In en, this message translates to:
  /// **'Photorealistic close-up of a geometric Valknut-style tattoo made of three interlocking triangles in thin black ink, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, high contrast, 2D only, flat design, isolated artwork, soft natural lighting, shallow depth of field.'**
  String get exploreItemValknutTrianglePrompt;

  /// Explore item title: Minimalist Mountain
  ///
  /// In en, this message translates to:
  /// **'Minimalist Mountain'**
  String get exploreItemMinimalistMountain;

  /// Explore item prompt: Minimalist Mountain
  ///
  /// In en, this message translates to:
  /// **'Ultra-realistic close-up of a fine-line mountain tattoo in clean black ink, small minimalist design with soft natural lighting, neutral background and shallow depth of field, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, high contrast, 2D only, flat design, isolated artwork.'**
  String get exploreItemMinimalistMountainPrompt;

  /// Explore item title: Swallow Bird
  ///
  /// In en, this message translates to:
  /// **'Swallow Bird'**
  String get exploreItemSwallowBird;

  /// Explore item prompt: Swallow Bird
  ///
  /// In en, this message translates to:
  /// **'Old school swallow tattoo, wings spread, bold outlines, blue and red classic palette, vintage sailor tattoo flash, simple shading, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemSwallowBirdPrompt;

  /// Explore item title: Dagger Through Heart
  ///
  /// In en, this message translates to:
  /// **'Dagger Through Heart'**
  String get exploreItemDaggerHeart;

  /// Explore item prompt: Dagger Through Heart
  ///
  /// In en, this message translates to:
  /// **'Traditional dagger through heart tattoo, bold outlines, red heart pierced by steel dagger, classic old school flash, strong shading, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemDaggerHeartPrompt;

  /// Explore item title: Skull Classic
  ///
  /// In en, this message translates to:
  /// **'Skull Classic'**
  String get exploreItemSkullClassic;

  /// Explore item prompt: Skull Classic
  ///
  /// In en, this message translates to:
  /// **'Old school skull tattoo, bold black outlines, simple shading, vintage flash design, traditional tattoo style, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemSkullClassicPrompt;

  /// Explore item title: Eagle Spread
  ///
  /// In en, this message translates to:
  /// **'Eagle Spread'**
  String get exploreItemEagleSpread;

  /// Explore item prompt: Eagle Spread
  ///
  /// In en, this message translates to:
  /// **'Traditional eagle tattoo, wings spread wide, bold outlines, red yellow blue palette, vintage American traditional style, strong shading, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemEagleSpreadPrompt;

  /// Explore item title: Snake Coiled
  ///
  /// In en, this message translates to:
  /// **'Snake Coiled'**
  String get exploreItemSnakeCoiled;

  /// Explore item prompt: Snake Coiled
  ///
  /// In en, this message translates to:
  /// **'Old school snake tattoo, coiled serpent, bold outlines, green and red palette, vintage flash style, strong simple shading, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemSnakeCoiledPrompt;

  /// Explore item title: Ship Wheel
  ///
  /// In en, this message translates to:
  /// **'Ship Wheel'**
  String get exploreItemShipWheel;

  /// Explore item prompt: Ship Wheel
  ///
  /// In en, this message translates to:
  /// **'Traditional ship wheel tattoo, nautical theme, bold outlines, brown and gold tones, classic sailor tattoo flash, simple shading, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemShipWheelPrompt;

  /// Explore item title: Cowboy Revolver
  ///
  /// In en, this message translates to:
  /// **'Cowboy Revolver'**
  String get exploreItemCowboyRevolver;

  /// Explore item prompt: Cowboy Revolver
  ///
  /// In en, this message translates to:
  /// **'Traditional old school cowboy revolver tattoo, classic western pistol, bold thick black outlines, vintage tattoo flash style, simple red and gold accents, strong shading, clean vector look, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemCowboyRevolverPrompt;

  /// Explore item title: Panther Head
  ///
  /// In en, this message translates to:
  /// **'Panther Head'**
  String get exploreItemPantherHead;

  /// Explore item prompt: Panther Head
  ///
  /// In en, this message translates to:
  /// **'Old school panther head tattoo, roaring panther, bold black outlines, yellow eyes, red mouth, vintage traditional flash style, strong shading, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemPantherHeadPrompt;

  /// Explore item title: Koi Fish
  ///
  /// In en, this message translates to:
  /// **'Koi Fish'**
  String get exploreItemKoiFish;

  /// Explore item prompt: Koi Fish
  ///
  /// In en, this message translates to:
  /// **'Japanese style koi fish tattoo, traditional irezumi design, flowing koi with curved body, bold outlines, red orange palette, water waves around fish, clean vector look, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemKoiFishPrompt;

  /// Explore item title: Hannya Mask
  ///
  /// In en, this message translates to:
  /// **'Hannya Mask'**
  String get exploreItemHannyaMask;

  /// Explore item prompt: Hannya Mask
  ///
  /// In en, this message translates to:
  /// **'Japanese hannya mask tattoo, traditional irezumi style, demon mask with horns, bold black outlines, red and white tones, dramatic expression, clean vector style, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemHannyaMaskPrompt;

  /// Explore item title: Samurai Helmet
  ///
  /// In en, this message translates to:
  /// **'Samurai Helmet'**
  String get exploreItemSamuraiHelmet;

  /// Explore item prompt: Samurai Helmet
  ///
  /// In en, this message translates to:
  /// **'Japanese samurai helmet tattoo, kabuto helmet front view, traditional irezumi style, bold outlines, gold and red accents, clean vector look, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemSamuraiHelmetPrompt;

  /// Explore item title: Cherry Blossom Branch
  ///
  /// In en, this message translates to:
  /// **'Cherry Blossom Branch'**
  String get exploreItemCherryBlossomBranch;

  /// Explore item prompt: Cherry Blossom Branch
  ///
  /// In en, this message translates to:
  /// **'Japanese cherry blossom tattoo, sakura branch with flowers, traditional irezumi style, soft pink blossoms, bold outlines, elegant composition, centered design, transparent background PNG, high resolution.'**
  String get exploreItemCherryBlossomBranchPrompt;

  /// Explore item title: Japanese Dragon
  ///
  /// In en, this message translates to:
  /// **'Japanese Dragon'**
  String get exploreItemJapaneseDragon;

  /// Explore item prompt: Japanese Dragon
  ///
  /// In en, this message translates to:
  /// **'Japanese dragon tattoo, traditional irezumi dragon, long flowing body, clouds around dragon, bold outlines, green red palette, dynamic pose, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemJapaneseDragonPrompt;

  /// Explore item title: Oni Mask
  ///
  /// In en, this message translates to:
  /// **'Oni Mask'**
  String get exploreItemOniMask;

  /// Explore item prompt: Oni Mask
  ///
  /// In en, this message translates to:
  /// **'Japanese oni mask tattoo, traditional demon mask, bold outlines, red and black palette, fierce expression, irezumi style, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemOniMaskPrompt;

  /// Explore item title: Wave (Hokusai Style)
  ///
  /// In en, this message translates to:
  /// **'Wave (Hokusai Style)'**
  String get exploreItemHokusaiWave;

  /// Explore item prompt: Wave (Hokusai Style)
  ///
  /// In en, this message translates to:
  /// **'Japanese wave tattoo, traditional irezumi ocean wave, bold outlines, blue tones, classic Japanese wave style, clean vector look, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemHokusaiWavePrompt;

  /// Explore item title: Tiger
  ///
  /// In en, this message translates to:
  /// **'Tiger'**
  String get exploreItemJapaneseTiger;

  /// Explore item prompt: Tiger
  ///
  /// In en, this message translates to:
  /// **'Japanese tiger tattoo, traditional irezumi tiger, roaring tiger head, bold outlines, orange black palette, dynamic style, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemJapaneseTigerPrompt;

  /// Explore item title: Lotus Flower
  ///
  /// In en, this message translates to:
  /// **'Lotus Flower'**
  String get exploreItemJapaneseLotus;

  /// Explore item prompt: Lotus Flower
  ///
  /// In en, this message translates to:
  /// **'Japanese lotus tattoo, traditional irezumi lotus flower, bold outlines, pink and red tones, water elements, clean vector look, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemJapaneseLotusPrompt;

  /// Explore item title: Phoenix
  ///
  /// In en, this message translates to:
  /// **'Phoenix'**
  String get exploreItemJapanesePhoenix;

  /// Explore item prompt: Phoenix
  ///
  /// In en, this message translates to:
  /// **'Japanese phoenix tattoo, traditional irezumi phoenix bird, wings spread, bold outlines, red orange yellow palette, flames around bird, centered composition, transparent background PNG, high resolution.'**
  String get exploreItemJapanesePhoenixPrompt;

  /// Explore item title: Polynesian Tribal Tattoo
  ///
  /// In en, this message translates to:
  /// **'Polynesian Tribal Tattoo'**
  String get exploreItemPolynesianTribal;

  /// Explore item prompt: Polynesian Tribal Tattoo
  ///
  /// In en, this message translates to:
  /// **'A bold Polynesian tribal tattoo design featuring sharp black lines, swirling patterns, and geometric elements with smooth curves and sharp angles arranged in a symmetrical flow extending into a pointed tail, deep black ink in traditional Polynesian style, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, high contrast, 2D only, flat design, isolated artwork..'**
  String get exploreItemPolynesianTribalPrompt;

  /// Explore item title: Tribal Spine Spear Tattoo
  ///
  /// In en, this message translates to:
  /// **'Tribal Spine Spear Tattoo'**
  String get exploreItemTribalSpineSpear;

  /// Explore item prompt: Tribal Spine Spear Tattoo
  ///
  /// In en, this message translates to:
  /// **'Centered symmetrical tribal spine tattoo design combining Celtic knotwork and sharp Polynesian-style lines, forming an elongated spear-like shape with bold clean black ink and crisp edges, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, high contrast, 2D only, flat design, isolated artwork.'**
  String get exploreItemTribalSpineSpearPrompt;

  /// Explore item title: Tribal Knotwork Tattoo
  ///
  /// In en, this message translates to:
  /// **'Tribal Knotwork Tattoo'**
  String get exploreItemTribalKnotwork;

  /// Explore item prompt: Tribal Knotwork Tattoo
  ///
  /// In en, this message translates to:
  /// **'Symmetrical tribal tattoo with sharp black geometric lines and curves, featuring an elongated central form that tapers at both ends with intricate interwoven patterns, high contrast, no shading, clean solid ink, modern abstract style with perfect symmetry and minimal background, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, high contrast, 2D only, flat design, isolated artwork.'**
  String get exploreItemTribalKnotworkPrompt;

  /// Explore item title: Tribal Forearm Sleeve Band
  ///
  /// In en, this message translates to:
  /// **'Tribal Forearm Sleeve Band'**
  String get exploreItemTribalForearmSleeve;

  /// Explore item prompt: Tribal Forearm Sleeve Band
  ///
  /// In en, this message translates to:
  /// **'Bold Polynesian-style tribal forearm sleeve design with flowing curved lines, sharp points and circular motifs arranged in a dynamic composition, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, high contrast, 2D only, flat design, isolated artwork.'**
  String get exploreItemTribalForearmSleevePrompt;

  /// Explore item title: Central Spiral
  ///
  /// In en, this message translates to:
  /// **'Central Spiral'**
  String get exploreItemTribalCentralSpiral;

  /// Explore item prompt: Central Spiral
  ///
  /// In en, this message translates to:
  /// **'Bold tribal central spiral tattoo design with sharp flame-like lines and smooth flowing curves arranged in a dynamic symmetrical composition, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, high contrast, 2D only, flat design, isolated artwork.'**
  String get exploreItemTribalCentralSpiralPrompt;

  /// Explore item title: Flame Tribal Forearm Tattoo
  ///
  /// In en, this message translates to:
  /// **'Flame Tribal Forearm Tattoo'**
  String get exploreItemTribalFlameForearm;

  /// Explore item prompt: Flame Tribal Forearm Tattoo
  ///
  /// In en, this message translates to:
  /// **'Bold flame-like tribal forearm tattoo design in thick clean black ink with sharp tapered edges and flowing curves, centered vertical composition, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, high contrast, 2D only, flat design, isolated artwork.'**
  String get exploreItemTribalFlameForearmPrompt;

  /// Explore item title: Spiral with Flame Extensions
  ///
  /// In en, this message translates to:
  /// **'Spiral with Flame Extensions'**
  String get exploreItemTribalSpiralFlame;

  /// Explore item prompt: Spiral with Flame Extensions
  ///
  /// In en, this message translates to:
  /// **'Bold spiral flame tribal tattoo design featuring thick black ink and sharp flame-like extensions radiating from a central swirl, dynamic symmetrical composition, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, high contrast, 2D only, flat design, isolated artwork.'**
  String get exploreItemTribalSpiralFlamePrompt;

  /// Explore item title: Tribal Compass Tattoo
  ///
  /// In en, this message translates to:
  /// **'Tribal Compass Tattoo'**
  String get exploreItemTribalCompass;

  /// Explore item prompt: Tribal Compass Tattoo
  ///
  /// In en, this message translates to:
  /// **'Centered tribal compass tattoo design with sharp symmetrical star points and flame-like extensions in clean solid black ink, high contrast with crisp edges and balanced geometry, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, 2D only, flat design, isolated artwork.'**
  String get exploreItemTribalCompassPrompt;

  /// Explore item title: Modern Geometric Tribal
  ///
  /// In en, this message translates to:
  /// **'Modern Geometric Tribal'**
  String get exploreItemTribalModernGeometric;

  /// Explore item prompt: Modern Geometric Tribal
  ///
  /// In en, this message translates to:
  /// **'Large symmetrical modern geometric tribal tattoo design featuring sharp triangular patterns and a flower-like central motif in thick solid black ink with high contrast and precise symmetry, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, 2D only, flat design, isolated artwork.'**
  String get exploreItemTribalModernGeometricPrompt;

  /// Explore item title: Neo-Tribal Back Tattoo
  ///
  /// In en, this message translates to:
  /// **'Neo-Tribal Back Tattoo'**
  String get exploreItemTribalNeoBack;

  /// Explore item prompt: Neo-Tribal Back Tattoo
  ///
  /// In en, this message translates to:
  /// **'Large neo-tribal back tattoo design featuring bold spiky thorn-like shapes in solid high-contrast black ink with sharp edges and dynamic symmetry, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, 2D only, flat design, isolated artwork.'**
  String get exploreItemTribalNeoBackPrompt;

  /// Explore item title: Flame Tribal
  ///
  /// In en, this message translates to:
  /// **'Flame Tribal'**
  String get exploreItemTribalFlame;

  /// Explore item prompt: Flame Tribal
  ///
  /// In en, this message translates to:
  /// **'Symmetrical tribal flame tattoo design featuring sharp curves and decorative swirls in clean solid black ink with high contrast and precise flowing geometry, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, 2D only, flat design, isolated artwork.'**
  String get exploreItemTribalFlamePrompt;

  /// Explore item title: Sword and Compass Tattoo
  ///
  /// In en, this message translates to:
  /// **'Sword and Compass Tattoo'**
  String get exploreItemTribalSwordCompass;

  /// Explore item prompt: Sword and Compass Tattoo
  ///
  /// In en, this message translates to:
  /// **'Vertical sword and 8-point compass rose tribal tattoo design with fine linework, circular detailing and subtle smoke-like accents in clean high-contrast black ink, symmetrical centered composition, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, 2D only, flat design, isolated artwork.'**
  String get exploreItemTribalSwordCompassPrompt;

  /// Explore item title: Mind–Body–Soul
  ///
  /// In en, this message translates to:
  /// **'Mind–Body–Soul'**
  String get exploreItemGeometricMindBodySoul;

  /// Explore item prompt: Mind–Body–Soul
  ///
  /// In en, this message translates to:
  /// **'Highly detailed sacred geometry tattoo design featuring a vertical composition with a brain transforming into a tree at the top, a meditating figure within geometric mandala shapes in the center, and an anatomical heart with ornamental elements at the bottom, clean linework with intricate dotwork shading and high contrast black ink, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, 2D only, flat design, isolated artwork.'**
  String get exploreItemGeometricMindBodySoulPrompt;

  /// Explore item title: Geometric Blackout Honeycomb Sleeve
  ///
  /// In en, this message translates to:
  /// **'Geometric Blackout Honeycomb Sleeve'**
  String get exploreItemGeometricHoneycombSleeve;

  /// Explore item prompt: Geometric Blackout Honeycomb Sleeve
  ///
  /// In en, this message translates to:
  /// **'Full black geometric sleeve tattoo design featuring a vertical honeycomb hexagon pattern combined with sacred-geometry mandala elements flowing down the arm, clean high-contrast black ink with precise symmetry and crisp linework, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, 2D only, flat design, isolated artwork. wiht ni hand pattern'**
  String get exploreItemGeometricHoneycombSleevePrompt;

  /// Explore item title: Geometric + Illustrative Blackwork
  ///
  /// In en, this message translates to:
  /// **'Geometric + Illustrative Blackwork'**
  String get exploreItemGeometricBlackwork;

  /// Explore item prompt: Geometric + Illustrative Blackwork
  ///
  /// In en, this message translates to:
  /// **'Geometric blackwork sleeve tattoo design featuring 3D cube and hexagon optical-illusion patterns seamlessly fading into a solid black section, precise linework with high-contrast black ink and sharp symmetry, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, 2D only, flat design, isolated artwork.'**
  String get exploreItemGeometricBlackworkPrompt;

  /// Explore item title: Geometric Cube Sleeve
  ///
  /// In en, this message translates to:
  /// **'Geometric Cube Sleeve'**
  String get exploreItemGeometricCubeSleeve;

  /// Explore item prompt: Geometric Cube Sleeve
  ///
  /// In en, this message translates to:
  /// **'Geometric blackwork sleeve tattoo design featuring 3D cube and hexagon optical-illusion patterns seamlessly fading into a solid black section, precise linework with high-contrast black ink and sharp symmetry, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, 2D only, flat design, isolated artwork'**
  String get exploreItemGeometricCubeSleevePrompt;

  /// Explore item title: 3D Cube Geometric Sleeve
  ///
  /// In en, this message translates to:
  /// **'3D Cube Geometric Sleeve'**
  String get exploreItemGeometric3dCubeSleeve;

  /// Explore item prompt: 3D Cube Geometric Sleeve
  ///
  /// In en, this message translates to:
  /// **'Full geometric blackwork sleeve tattoo design featuring interlocking 3D cube optical-illusion patterns transitioning into a dense sacred-geometry star motif, high-contrast black ink with clean sharp linework and intricate dotwork detailing, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, 2D only, flat design, isolated artwork.'**
  String get exploreItemGeometric3dCubeSleevePrompt;

  /// Explore item title: Tree of Life
  ///
  /// In en, this message translates to:
  /// **'Tree of Life'**
  String get exploreItemGeometricTreeOfLife;

  /// Explore item prompt: Tree of Life
  ///
  /// In en, this message translates to:
  /// **'Vertical tree of life tattoo design featuring a central pine tree within a circular mountain landscape, crescent moons above and ornamental roots below, rendered in clean fine-line and blackwork style with smooth high-contrast detailing, clean vector tattoo flash sheet, stencil-ready design, art print on blank white paper, black and white line art, minimalist with intricate details, standalone tattoo design, white background, 2D only, flat design, isolated artwork.'**
  String get exploreItemGeometricTreeOfLifePrompt;

  /// Explore item title: Atlas Bearing the World
  ///
  /// In en, this message translates to:
  /// **'Atlas Bearing the World'**
  String get exploreItemGeometricAtlas;

  /// Explore item prompt: Atlas Bearing the World
  ///
  /// In en, this message translates to:
  /// **'Vertical Atlas tattoo design in black-and-grey fine-line and dotwork style, depicting a classical sculpture-inspired figure kneeling and carrying a globe detailed with continents and a geometric grid, sacred-geometry patterns and a sun symbol above, clean high-contrast stencil-ready composition with intricate minimalist detailing, clean vector tattoo flash sheet, art print on blank white paper, black and white line art, standalone tattoo design, white background, 2D only, flat design, isolated artwork.'**
  String get exploreItemGeometricAtlasPrompt;

  /// Explore item title: Triad of Travel
  ///
  /// In en, this message translates to:
  /// **'Triad of Travel'**
  String get exploreItemGeometricTriadTravel;

  /// Explore item prompt: Triad of Travel
  ///
  /// In en, this message translates to:
  /// **'Minimalist geometric travel tattoo design in fine-line and dotwork style featuring a compass rose with orbital lines, a small airplane on a dotted path, mountains and an ocean wave arranged inside an inverted triangle frame with symmetrical sacred-geometry accents, clean high-contrast stencil-ready vertical composition with ultra-detailed linework, clean vector tattoo flash sheet, art print on blank white paper, black and white line art, standalone tattoo design, white background, 2D only, flat design, isolated artwork.'**
  String get exploreItemGeometricTriadTravelPrompt;

  /// Explore item title: Cycle of Horizons
  ///
  /// In en, this message translates to:
  /// **'Cycle of Horizons'**
  String get exploreItemGeometricHorizons;

  /// Explore item prompt: Cycle of Horizons
  ///
  /// In en, this message translates to:
  /// **'Minimalist geometric horizons tattoo design in fine-line blackwork and dotwork featuring a vertical column of connected hexagons with a sun and sky at the top, mountain landscape with trees in the center, and an ocean wave at the bottom, surrounded by smaller hexagons and sacred-geometry accents linked by thin lines and dotted paths, clean symmetrical high-contrast stencil-ready composition, clean vector tattoo flash sheet, art print on blank white paper, black and white line art, standalone tattoo design, white background, 2D only, flat design, isolated artwork.'**
  String get exploreItemGeometricHorizonsPrompt;

  /// Explore item title: Aligned Triad
  ///
  /// In en, this message translates to:
  /// **'Aligned Triad'**
  String get exploreItemGeometricAlignedTriad;

  /// Explore item prompt: Aligned Triad
  ///
  /// In en, this message translates to:
  /// **'Tiny minimalist finger tattoo in fine-line blackwork, featuring an abstract vertical triangle composition with layered geometric shapes, small diamond and polygon details, and subtle dotwork shading. Modern sacred-geometry style with thin precise lines, clean ornamental accents, and a stencil-ready professional look.'**
  String get exploreItemGeometricAlignedTriadPrompt;

  /// Explore item title: Abstract Geometric Sigi
  ///
  /// In en, this message translates to:
  /// **'Abstract Geometric Sigi'**
  String get exploreItemGeometricSigi;

  /// Explore item prompt: Abstract Geometric Sigi
  ///
  /// In en, this message translates to:
  /// **'Ultra-minimalist geometric finger tattoo in fine-line black ink, featuring a small vertical symbol of overlapping triangles, diamonds, and sharp polygon shapes with subtle dotwork shading and clean negative space. Modern sacred-geometry style with precise thin lines, high-contrast blackwork, and a stencil-ready professional design.'**
  String get exploreItemGeometricSigiPrompt;

  /// Explore item title: Duality Nature Geometry
  ///
  /// In en, this message translates to:
  /// **'Duality Nature Geometry'**
  String get exploreItemGeometricDualityNature;

  /// Explore item prompt: Duality Nature Geometry
  ///
  /// In en, this message translates to:
  /// **'Minimalist blackwork  tattoo in fine-line and dotwork style, featuring two stacked triangles: the top with a mountain scene and rising sun or moon, and the bottom inverted with a large ocean wave. Clean geometric framing, subtle sacred-geometry accents, and dotted motion lines create a balanced, modern nature-themed design that\'s high-contrast, ultra-detailed, and stencil-ready.'**
  String get exploreItemGeometricDualityNaturePrompt;

  /// Explore item title: Gambler in a Fedora
  ///
  /// In en, this message translates to:
  /// **'Gambler in a Fedora'**
  String get exploreItemRealismGamblerFedora;

  /// Explore item prompt: Gambler in a Fedora
  ///
  /// In en, this message translates to:
  /// **'Black & grey realistic tattoo of a faceless gambler in a fedora and suit, head down, arms crossed. Vintage street lamp behind, aces cards fanned out, light smoke on one side, two dice at the bottom. Noir mood, high-contrast shading, fine linework, detailed stippling, clean stencil style, centered symmetrical composition, monochrome, tattoo flash.'**
  String get exploreItemRealismGamblerFedoraPrompt;

  /// Explore item title: Mind Over Heart
  ///
  /// In en, this message translates to:
  /// **'Mind Over Heart'**
  String get exploreItemRealismMindOverHeart;

  /// Explore item prompt: Mind Over Heart
  ///
  /// In en, this message translates to:
  /// **'Black & grey surreal tattoo of a realistic human brain acting like a puppeteer, with detailed hands controlling strings attached to an anatomical heart below. Fine linework, stippling and cross-hatching shading, high contrast, dark symbolic concept (mind controlling heart). Centered vertical composition, minimal background, monochrome, highly detailed, professional tattoo flash.'**
  String get exploreItemRealismMindOverHeartPrompt;

  /// Explore item title: Geometric Split Portrait
  ///
  /// In en, this message translates to:
  /// **'Geometric Split Portrait'**
  String get exploreItemRealismGeometricSplit;

  /// Explore item prompt: Geometric Split Portrait
  ///
  /// In en, this message translates to:
  /// **'Stylized neo-modern tattoo of a female face split into geometric shards. One side realistic black-and-grey portrait, the other side vibrant color with pink hair and a bright blue eye. Sharp abstract shapes cutting through the face, bold clean linework, high contrast shading, minimal background. Neo-traditional / cyber-graphic tattoo style, centered vertical composition, tattoo stencil ready, highly detailed, modern flash design.'**
  String get exploreItemRealismGeometricSplitPrompt;

  /// Explore item title: Fiery and Cosmic Split
  ///
  /// In en, this message translates to:
  /// **'Fiery and Cosmic Split'**
  String get exploreItemRealismFieryCosmic;

  /// Explore item prompt: Fiery and Cosmic Split
  ///
  /// In en, this message translates to:
  /// **'Surreal color tattoo of a female portrait with a split reality concept. One side warm tones with cracked skin texture, the other side cool blue cosmic tones. A magnifying glass over one eye revealing a glowing blue iris and abstract liquid details. Vintage pocket watch/clock at the bottom symbolizing time, subtle galaxy elements in the background. Highly detailed neo-surreal style, vibrant color contrast (orange vs blue), smooth gradients, bold clean linework, centered vertical composition, minimal background, modern tattoo flash design, stencil-ready.'**
  String get exploreItemRealismFieryCosmicPrompt;

  /// Explore item title: Sinister Clown Portrait
  ///
  /// In en, this message translates to:
  /// **'Sinister Clown Portrait'**
  String get exploreItemRealismSinisterClown;

  /// Explore item prompt: Sinister Clown Portrait
  ///
  /// In en, this message translates to:
  /// **'Dark gothic clown-style female face tattoo with sharp black makeup lines, dramatic eyeliner and dripping eye accents, glowing orange eyes, small star symbol on forehead. Smooth black and grey shading with subtle color in the eyes only, high contrast, fine linework and stippling, clean edges, centered vertical tattoo design. Isolated tattoo artwork only on plain white background, no arm or skin, stencil-ready, professional tattoo flash style.'**
  String get exploreItemRealismSinisterClownPrompt;

  /// Explore item title: Butterfly and Woman
  ///
  /// In en, this message translates to:
  /// **'Butterfly and Woman'**
  String get exploreItemRealismButterflyWoman;

  /// Explore item prompt: Butterfly and Woman
  ///
  /// In en, this message translates to:
  /// **'Black & grey tattoo design of a realistic female side profile blended with large detailed butterfly wings emerging from her head. Soft feminine facial features, smooth shading, fine linework, high contrast, delicate wing patterns with stippling and gradient shading. Elegant, surreal composition, centered vertical layout, minimal background, monochrome, clean stencil-ready tattoo flash style, highly detailed.'**
  String get exploreItemRealismButterflyWomanPrompt;

  /// Explore item title: Flaming Skull
  ///
  /// In en, this message translates to:
  /// **'Flaming Skull'**
  String get exploreItemRealismFlamingSkull;

  /// Explore item prompt: Flaming Skull
  ///
  /// In en, this message translates to:
  /// **'Fiery skull tattoo design with a realistic human skull engulfed in dynamic flames. Intense glowing fire inside the eye sockets and mouth, sharp teeth details, high contrast shading, bold clean linework. Realism + dark fantasy style, dramatic lighting, vibrant orange and red flames with black/grey skull tones. Centered vertical composition, isolated on white background, stencil-ready, highly detailed professional tattoo flash.'**
  String get exploreItemRealismFlamingSkullPrompt;

  /// Explore item title: Fierce Wolf
  ///
  /// In en, this message translates to:
  /// **'Fierce Wolf'**
  String get exploreItemRealismFierceWolf;

  /// Explore item prompt: Fierce Wolf
  ///
  /// In en, this message translates to:
  /// **'Vibrant and colorful tattoo design featuring a fierce wolf\'s face with piercing blue eyes, surrounded by a winding snake. The snake wraps around the wolf\'s head, slithering towards a cluster of blooming orange flowers. The tattoo is adorned with soft watercolor splashes in pink, purple, and blue hues, with a dripping paint effect. Rich detail in the fur, scales, and petals, high contrast between dark and light areas. Watercolor style with fine linework, modern nature and wildlife symbolism. Centered composition, vivid and dynamic, tattoo stencil-ready.'**
  String get exploreItemRealismFierceWolfPrompt;

  /// Explore item title: Red Rose and Butterfly
  ///
  /// In en, this message translates to:
  /// **'Red Rose and Butterfly'**
  String get exploreItemRealismRedRoseButterfly;

  /// Explore item prompt: Red Rose and Butterfly
  ///
  /// In en, this message translates to:
  /// **'Elegant black and red tattoo design featuring a bold butterfly with dark wings, paired with a vivid red rose. The butterfly\'s wings have a smooth gradient from black to red, while the rose is deeply detailed with soft shading to enhance its petals. The design includes delicate red leaves and branches flowing outward, creating a balanced, flowing composition. The black ink contrasts sharply with the vibrant red, adding a dramatic, fluid appearance. Modern, clean linework with a slightly abstract touch. Tattoo stencil-ready with high contrast, perfect for an arm or thigh placement.'**
  String get exploreItemRealismRedRoseButterflyPrompt;

  /// Explore item title: Vibrant Peacock
  ///
  /// In en, this message translates to:
  /// **'Vibrant Peacock'**
  String get exploreItemRealismVibrantPeacock;

  /// Explore item prompt: Vibrant Peacock
  ///
  /// In en, this message translates to:
  /// **'Vibrant and colorful tattoo design of a peacock with a bright yellow-orange sun in the background. The peacock\'s feathers display stunning shades of blue, green, and purple, while its body is elegantly shaded with turquoise and teal. Bold pink flowers and green leaves frame the design, with fine linework to accentuate the shapes and textures. Modern and stylized with clean, bold outlines and rich, vibrant colors. Ideal for a larger area, with no background distractions, creating a focal piece perfect for placement anywhere on the body.'**
  String get exploreItemRealismVibrantPeacockPrompt;

  /// Explore item title: Playful Character
  ///
  /// In en, this message translates to:
  /// **'Playful Character'**
  String get exploreItemRealismPlayfulCharacter;

  /// Explore item prompt: Playful Character
  ///
  /// In en, this message translates to:
  /// **'Cute, colorful tattoo design of a playful character holding a large pink flower. The character features large, expressive eyes, blue fur, and a light blue belly. The vibrant flower is framed by green leaves, adding a natural touch to the design. The style is bold and cartoonish with smooth shading, clean lines, and vibrant colors, giving the tattoo a joyful and whimsical look. The design is ideal for a smaller area of the body, with no background distractions, emphasizing the character and flower as the focal points.'**
  String get exploreItemRealismPlayfulCharacterPrompt;

  /// Explore item title: Cute Pink Fish
  ///
  /// In en, this message translates to:
  /// **'Cute Pink Fish'**
  String get exploreItemRealismCutePinkFish;

  /// Explore item prompt: Cute Pink Fish
  ///
  /// In en, this message translates to:
  /// **'Playful and vibrant tattoo design of a cute pink fish with a smiling expression. The fish features soft gradients of pink, with smooth shading that creates a lively, cartoonish look. Water splashes in shades of blue and turquoise surround the fish, adding dynamic movement. Small bubbles and light accents enhance the aquatic theme. Modern, clean lines with a playful touch, perfect for a small area on the body. The tattoo design focuses on the fish and water, with no background distractions, and has a joyful, whimsical vibe.'**
  String get exploreItemRealismCutePinkFishPrompt;

  /// Explore item title: Trust No One
  ///
  /// In en, this message translates to:
  /// **'Trust No One'**
  String get exploreItemLetteringTrustNoOne;

  /// Explore item prompt: Trust No One
  ///
  /// In en, this message translates to:
  /// **'Create a detailed gothic-style tattoo design with the phrase \'Trust no One\'. The text should be bold and dramatic, with sharp, angular edges. Add shading effects to give the text a three-dimensional look, and incorporate some ink splatter or shadow around the text for a gritty, intense vibe. The font should evoke a dark, mysterious atmosphere with an edgy, rebellious tone.'**
  String get exploreItemLetteringTrustNoOnePrompt;

  /// Explore item title: Blessed
  ///
  /// In en, this message translates to:
  /// **'Blessed'**
  String get exploreItemLetteringBlessed;

  /// Explore item prompt: Blessed
  ///
  /// In en, this message translates to:
  /// **'High-contrast black and white graffiti tattoo design, word \"Blessed\" in bold hand-lettering calligraphy, smooth flowing script with thick strokes, subtle halo above letter, street-style spray paint glow around text, paint drips and ink splatter, clean vector lines, centered composition, stencil-ready tattoo flash, minimal background, sharp edges, professional tattoo design, black ink only.'**
  String get exploreItemLetteringBlessedPrompt;

  /// Explore item title: Hakuna Matata
  ///
  /// In en, this message translates to:
  /// **'Hakuna Matata'**
  String get exploreItemLetteringHakunaMatata;

  /// Explore item prompt: Hakuna Matata
  ///
  /// In en, this message translates to:
  /// **'Bold black and white graffiti tattoo design with the words \"Hakuna Matata\", strong street-style block lettering, rough dry-brush strokes, high contrast ink, paint splatter and subtle drip details, urban graffiti wall aesthetic, thick clean outlines, centered composition, professional tattoo flash, stencil-ready, vector style, monochrome, white background, highly detailed, sharp edges.'**
  String get exploreItemLetteringHakunaMatataPrompt;

  /// Explore item title: Dream
  ///
  /// In en, this message translates to:
  /// **'Dream'**
  String get exploreItemLetteringDream;

  /// Explore item prompt: Dream
  ///
  /// In en, this message translates to:
  /// **'Vibrant graffiti tattoo design with the word \"DREAM\", bold 3D street lettering, thick black outlines, colorful paint splashes and ink drips, urban spray-paint style, high contrast, layered graffiti wall aesthetic, dynamic composition, clean sharp edges, professional tattoo flash, stencil-ready, highly detailed, vector style.'**
  String get exploreItemLetteringDreamPrompt;

  /// Explore item title: Boom
  ///
  /// In en, this message translates to:
  /// **'Boom'**
  String get exploreItemLetteringBoom;

  /// Explore item prompt: Boom
  ///
  /// In en, this message translates to:
  /// **'Comic pop-art tattoo design with the word \"BOOM\", bold cartoon lettering, thick black outlines, vibrant pink and yellow colors, explosive comic burst background, glossy highlights, playful graffiti style, high contrast, clean smooth edges, centered composition, professional tattoo flash, stencil-ready, highly detailed vector style.'**
  String get exploreItemLetteringBoomPrompt;

  /// Explore item title: Work Hard Dream Big
  ///
  /// In en, this message translates to:
  /// **'Work Hard Dream Big'**
  String get exploreItemLetteringWorkHardDreamBig;

  /// Explore item prompt: Work Hard Dream Big
  ///
  /// In en, this message translates to:
  /// **'Bold colorful graffiti tattoo design with the phrase \"Work Hard Dream Big\", dynamic street lettering, 3D layered typography, thick black outlines, vibrant gradient colors (orange, red, yellow), paint drips and ink splatter, urban graffiti wall style, high contrast, glossy highlights, centered composition, professional tattoo flash, stencil-ready, highly detailed, vector style, clean background.'**
  String get exploreItemLetteringWorkHardDreamBigPrompt;

  /// Explore item title: Letter RN
  ///
  /// In en, this message translates to:
  /// **'Letter RN'**
  String get exploreItemLetteringRn;

  /// Explore item prompt: Letter RN
  ///
  /// In en, this message translates to:
  /// **'Dark gothic tattoo design, stylized monogram letters \"RN\", sharp aggressive calligraphy with horned and spiked edges, black ink only, high contrast, heavy shadowing, grunge ink splatter, ornamental gothic typography, symmetrical composition, tattoo flash style, clean stencil-ready lines, monochrome, white background, highly detailed, professional tattoo design.'**
  String get exploreItemLetteringRnPrompt;

  /// Explore item title: Letter C
  ///
  /// In en, this message translates to:
  /// **'Letter C'**
  String get exploreItemLetteringC;

  /// Explore item prompt: Letter C
  ///
  /// In en, this message translates to:
  /// **'Dark gothic tattoo design featuring the letter \"C\" with a detailed royal crown on top, bold curved lettering with sharp edges, black and grey realism, high contrast shading, subtle ink splatter and drip effects, luxury gothic style, strong depth and shadow, centered composition, clean stencil-ready outlines, professional tattoo flash, monochrome, highly detailed vector tattoo style.'**
  String get exploreItemLetteringCPrompt;

  /// Explore item title: Peace & Positivity
  ///
  /// In en, this message translates to:
  /// **'Peace & Positivity'**
  String get exploreItemLetteringPeacePositivity;

  /// Explore item prompt: Peace & Positivity
  ///
  /// In en, this message translates to:
  /// **'Bold colorful graffiti tattoo design with the phrase \"Peace & Positivity\", dynamic street-style lettering, large 3D typography, thick black outlines, vibrant gradient colors (yellow, orange, blue, green), paint splashes and dripping ink, urban spray-paint graffiti aesthetic, high contrast, glossy highlights, centered composition, professional tattoo flash, stencil-ready, highly detailed vector style.'**
  String get exploreItemLetteringPeacePositivityPrompt;

  /// Explore item title: Dream Big
  ///
  /// In en, this message translates to:
  /// **'Dream Big'**
  String get exploreItemLetteringDreamBig;

  /// Explore item prompt: Dream Big
  ///
  /// In en, this message translates to:
  /// **'Colorful dreamy tattoo design with the words \"Dream Big\", soft bubble calligraphy lettering, glossy 3D gradient colors (rainbow tones), smooth rounded strokes, cute celestial elements like stars, sparkles and glowing sun, vibrant fantasy aesthetic, high contrast, clean bold outlines, centered composition, professional tattoo flash, stencil-ready, highly detailed vector style.'**
  String get exploreItemLetteringDreamBigPrompt;

  /// Explore item title: Desire
  ///
  /// In en, this message translates to:
  /// **'Desire'**
  String get exploreItemLetteringDesire;

  /// Explore item prompt: Desire
  ///
  /// In en, this message translates to:
  /// **'Dark gothic tattoo design with the word \"Desire\", sharp aggressive black metal calligraphy, spiked thorn-like lettering, symmetrical composition, black and grey realism, metallic dark texture, high contrast shading, sinister ornamental details, clean stencil-ready outlines, professional tattoo flash, monochrome, ultra detailed, edgy gothic style.'**
  String get exploreItemLetteringDesirePrompt;

  /// Explore item title: Beautiful
  ///
  /// In en, this message translates to:
  /// **'Beautiful'**
  String get exploreItemLetteringBeautiful;

  /// Explore item prompt: Beautiful
  ///
  /// In en, this message translates to:
  /// **'Stylish colorful tattoo design with the word \"Beautiful\", smooth flowing script lettering, bold modern calligraphy, glossy 3D gradient colors (pink, orange, yellow), thick black outline, soft highlights and depth, feminine elegant style, clean curves and swashes, centered composition, professional tattoo flash, stencil-ready, highly detailed vector style.'**
  String get exploreItemLetteringBeautifulPrompt;

  /// Explore item title: Minimalist Four-Leaf Clover
  ///
  /// In en, this message translates to:
  /// **'Minimalist Four-Leaf Clover'**
  String get exploreItemFloralFourLeafClover;

  /// Explore item prompt: Minimalist Four-Leaf Clover
  ///
  /// In en, this message translates to:
  /// **'Minimal fine-line four-leaf clover tattoo design, cute and delicate style, soft pastel green leaves with smooth gradient, thin black stem and clean outlines, small red heart detail inside one leaf, symmetrical composition, feminine minimalist tattoo flash, high contrast linework, subtle color fill, crisp vector-style edges, professional tattoo stencil design, centered composition.'**
  String get exploreItemFloralFourLeafCloverPrompt;

  /// Explore item title: Cherry Blossom Branch
  ///
  /// In en, this message translates to:
  /// **'Cherry Blossom Branch'**
  String get exploreItemFloralCherryBlossom;

  /// Explore item prompt: Cherry Blossom Branch
  ///
  /// In en, this message translates to:
  /// **'Elegant cherry blossom branch tattoo design, fine-line botanical style, flowing sakura branch with multiple pink blossoms and small buds, gradient pink petals with delicate shading, thin black branch and clean outlines, subtle petal fall details, feminine composition, high-detail floral tattoo flash, balanced vertical layout, professional tattoo stencil design, minimal background, high contrast, centered composition.'**
  String get exploreItemFloralCherryBlossomPrompt;

  /// Explore item title: Mountain Landscape
  ///
  /// In en, this message translates to:
  /// **'Mountain Landscape'**
  String get exploreItemFloralMountainLandscape;

  /// Explore item prompt: Mountain Landscape
  ///
  /// In en, this message translates to:
  /// **'Minimal fine-line mountain landscape tattoo design, small centered composition, detailed mountain peaks with pine trees, flowing waterfall descending from the center, circular moon above the mountains, delicate dotwork shading and stippling, clean black ink linework, geometric balance, subtle texture, high contrast, professional tattoo flash style, crisp outlines, minimalist nature scene, transparent background.'**
  String get exploreItemFloralMountainLandscapePrompt;

  /// Explore item title: Heart-Shaped Sunset
  ///
  /// In en, this message translates to:
  /// **'Heart-Shaped Sunset'**
  String get exploreItemFloralHeartSunset;

  /// Explore item prompt: Heart-Shaped Sunset
  ///
  /// In en, this message translates to:
  /// **'Small heart-shaped sunset tattoo design, vibrant warm color palette, glowing orange and red sunset inside a clean heart outline, ocean horizon with soft reflections, painterly clouds with subtle splatter details, minimal black base shadow under the heart, fine-line and micro-realism style, smooth gradient color blending, high contrast, centered composition, professional tattoo flash design, crisp edges, no text, transparent background.'**
  String get exploreItemFloralHeartSunsetPrompt;

  /// Explore item title: Sea Turtle
  ///
  /// In en, this message translates to:
  /// **'Sea Turtle'**
  String get exploreItemFloralSeaTurtle;

  /// Explore item prompt: Sea Turtle
  ///
  /// In en, this message translates to:
  /// **'Vibrant geometric sea turtle tattoo design, two sea turtles swimming side by side, faceted crystal-style shells with rainbow prism colors, polygonal pattern texture, high-detail scales and flippers, glossy gemstone effect, bold saturation with deep blues, purples, greens and warm highlights, micro-realism meets geometric style, clean sharp outlines, subtle shadow under figures, high contrast, centered composition, professional tattoo flash design, isolated artwork, transparent background.'**
  String get exploreItemFloralSeaTurtlePrompt;

  /// Explore item title: Hibiscus Flower
  ///
  /// In en, this message translates to:
  /// **'Hibiscus Flower'**
  String get exploreItemFloralHibiscus;

  /// Explore item prompt: Hibiscus Flower
  ///
  /// In en, this message translates to:
  /// **'Vibrant hibiscus flower tattoo design, bold tropical floral composition, large detailed hibiscus bloom with warm red, orange and yellow gradient petals, smooth color blending, clean black outlines, soft shading for depth, surrounding green leaves with fine vein detail, small decorative ink splatter dots, modern neo-traditional tattoo style, high contrast, centered composition, crisp edges, professional tattoo flash, isolated artwork, transparent background.'**
  String get exploreItemFloralHibiscusPrompt;

  /// Explore item title: Butterfly and Lily
  ///
  /// In en, this message translates to:
  /// **'Butterfly and Lily'**
  String get exploreItemFloralButterflyLily;

  /// Explore item prompt: Butterfly and Lily
  ///
  /// In en, this message translates to:
  /// **'Realistic monarch butterfly and lily flower tattoo design, vibrant orange and black butterfly with detailed wing patterns, perched beside a large yellow lily bloom, smooth color gradients and soft realistic shading, crisp black outlines with subtle depth, rich green leaves with fine vein detail, neo-traditional realism style, high contrast colors, balanced composition, professional tattoo flash design, clean edges, isolated artwork, transparent background.'**
  String get exploreItemFloralButterflyLilyPrompt;

  /// Explore item title: Butterfly
  ///
  /// In en, this message translates to:
  /// **'Butterfly'**
  String get exploreItemFloralButterfly;

  /// Explore item prompt: Butterfly
  ///
  /// In en, this message translates to:
  /// **'Realistic monarch butterfly tattoo design, vibrant orange wings with deep black borders and white dot accents, symmetrical open-wing pose, smooth gradient color blending, glossy highlights and soft shadow for depth, clean bold outlines, high-detail wing texture, neo-traditional realism style, high contrast, centered composition, professional tattoo flash, crisp edges, isolated artwork, transparent background.'**
  String get exploreItemFloralButterflyPrompt;

  /// Explore item title: Hummingbird and Cherry Blossom
  ///
  /// In en, this message translates to:
  /// **'Hummingbird and Cherry Blossom'**
  String get exploreItemFloralHummingbirdCherry;

  /// Explore item prompt: Hummingbird and Cherry Blossom
  ///
  /// In en, this message translates to:
  /// **'Delicate hummingbird and cherry blossom tattoo design, fine-line realism style, small hummingbird in mid-flight with detailed feathers and soft shading, thin curved branch with pink cherry blossoms and tiny buds, elegant botanical composition, subtle color accents on flowers with mostly black ink bird, clean crisp outlines, micro-realism tattoo flash style, high detail, balanced composition, high contrast, professional tattoo design, isolated artwork, transparent background.'**
  String get exploreItemFloralHummingbirdCherryPrompt;

  /// Explore item title: Butterfly Bracelet
  ///
  /// In en, this message translates to:
  /// **'Butterfly Bracelet'**
  String get exploreItemFloralButterflyBracelet;

  /// Explore item prompt: Butterfly Bracelet
  ///
  /// In en, this message translates to:
  /// **'Elegant blue butterfly bracelet tattoo design, delicate chain-style composition wrapping in a flowing curve, two detailed blue butterflies with gradient wings and fine line texture, small star charms and tiny floral accents connected by thin ornamental chains, feminine micro-realism style, crisp black outlines with vibrant blue highlights, subtle dotwork details, light and airy composition, high contrast, professional tattoo flash design, centered and balanced layout, isolated artwork, transparent background.'**
  String get exploreItemFloralButterflyBraceletPrompt;

  /// Explore item title: Baby Panda
  ///
  /// In en, this message translates to:
  /// **'Baby Panda'**
  String get exploreItemFloralBabyPanda;

  /// Explore item prompt: Baby Panda
  ///
  /// In en, this message translates to:
  /// **'Cute baby panda tattoo design, sitting panda holding a small bamboo stick, soft rounded cartoon style with semi-realistic fur texture, gentle blush on cheeks, big expressive eyes and friendly smile, black and white panda with subtle grey shading, small bamboo leaves around the character, light watercolor splash background in pastel tones, clean bold outlines with soft shading, kawaii tattoo style, high contrast, centered composition, professional tattoo flash design, isolated artwork, transparent background.'**
  String get exploreItemFloralBabyPandaPrompt;

  /// Explore item title: Sun Moon
  ///
  /// In en, this message translates to:
  /// **'Sun Moon'**
  String get exploreItemFloralSunMoon;

  /// Explore item prompt: Sun Moon
  ///
  /// In en, this message translates to:
  /// **'Sun and crescent moon watercolor tattoo design, vibrant celestial composition, glowing orange sun with flowing rays surrounding a large crescent moon, moon filled with galaxy-style colors in blue, purple and pink, soft watercolor splashes and ink drips, delicate star details and sparkles, fine clean outlines with smooth color gradients, modern celestial tattoo style, high contrast, balanced centered composition, professional tattoo flash design, isolated artwork, transparent background.'**
  String get exploreItemFloralSunMoonPrompt;

  /// Explore item title: Warrior and Serpents
  ///
  /// In en, this message translates to:
  /// **'Warrior and Serpents'**
  String get exploreItemMythologyWarriorSerpents;

  /// Explore item prompt: Warrior and Serpents
  ///
  /// In en, this message translates to:
  /// **'A muscular classical Greek statue-style male warrior wrapped tightly by multiple serpents, one snake coiling around torso and arms, another rising with open mouth, warrior holding a dagger downward in one hand, dramatic mythological struggle pose, inspired by ancient sculpture and renaissance engraving, highly detailed black ink tattoo design, fine line engraving style, cross-hatching shading, clean linework, centered vertical composition, high contrast, white background, parchment texture, realistic anatomy, dark fantasy tattoo flash, symmetrical balanced layout.'**
  String get exploreItemMythologyWarriorSerpentsPrompt;

  /// Explore item title: Phoenix Rising
  ///
  /// In en, this message translates to:
  /// **'Phoenix Rising'**
  String get exploreItemMythologyPhoenixRising;

  /// Explore item prompt: Phoenix Rising
  ///
  /// In en, this message translates to:
  /// **'Vibrant phoenix tattoo design, wings fully spread upward, long flowing tail feathers, dynamic rising pose, fiery color palette with red, orange, yellow and hints of blue, ultra detailed feathers, clean bold outlines, modern neo-traditional tattoo style, high contrast, glowing ember effects, subtle ink splatter accents, symmetrical composition, sharp linework, rich gradient coloring, dramatic lighting, professional tattoo flash illustration, centered composition, plain background.'**
  String get exploreItemMythologyPhoenixRisingPrompt;

  /// Explore item title: Medusa
  ///
  /// In en, this message translates to:
  /// **'Medusa'**
  String get exploreItemMythologyMedusa;

  /// Explore item prompt: Medusa
  ///
  /// In en, this message translates to:
  /// **'Medusa inspired tattoo design, mysterious female face with multiple serpents coiling and intertwining through the hair, several snake heads facing different directions, one snake with open mouth and fangs visible, intense glowing eyes, cracked marble skin texture, mythological dark fantasy theme, ultra detailed scales and hair strands, bold clean linework, neo-traditional tattoo style, rich green and earthy tones, high contrast shading, smooth gradients, dramatic composition, centered tattoo flash illustration, sharp outlines, professional tattoo design.'**
  String get exploreItemMythologyMedusaPrompt;

  /// Explore item title: Dragon Coiled Around Sword
  ///
  /// In en, this message translates to:
  /// **'Dragon Coiled Around Sword'**
  String get exploreItemMythologyDragonSword;

  /// Explore item prompt: Dragon Coiled Around Sword
  ///
  /// In en, this message translates to:
  /// **'Dark fantasy dragon wrapped around an ornate medieval sword, dragon body coiling tightly along the blade, detailed scales and sharp claws, fierce dragon head with open mouth and visible fangs near the hilt, gothic engraved sword design, symmetrical vertical composition, black and grey tattoo style, ultra detailed linework, high contrast shading, fine line engraving technique, dramatic shadows, sharp clean outlines, fantasy tattoo flash, centered composition, minimal plain background, professional tattoo illustration.'**
  String get exploreItemMythologyDragonSwordPrompt;

  /// Explore item title: Three-Headed Hydra
  ///
  /// In en, this message translates to:
  /// **'Three-Headed Hydra'**
  String get exploreItemMythologyThreeHeadedHydra;

  /// Explore item prompt: Three-Headed Hydra
  ///
  /// In en, this message translates to:
  /// **'Three-headed hydra dragon tattoo design, massive serpentine dragon body with three fierce dragon heads emerging from one neck, mouths open with sharp fangs, aggressive expressions, overlapping scales and armored plates, dark fantasy creature, ultra detailed black and grey tattoo style, heavy shading, high contrast lighting, intricate scale texture, sharp horns and spikes, smoke drifting from mouths, dramatic vertical composition, clean bold outlines, professional tattoo flash illustration, centered composition.'**
  String get exploreItemMythologyThreeHeadedHydraPrompt;

  /// Explore item title: Octopus
  ///
  /// In en, this message translates to:
  /// **'Octopus'**
  String get exploreItemMythologyOctopus;

  /// Explore item prompt: Octopus
  ///
  /// In en, this message translates to:
  /// **'Detailed octopus tattoo design, large octopus with curling tentacles spreading outward in a balanced composition, tentacles twisting and overlapping with visible suction cups, intense eyes and textured head, dark ocean creature theme, black and grey tattoo style, ultra fine linework, engraving and dotwork shading, high contrast shadows, realistic texture, symmetrical centered layout, bold clean outlines, professional tattoo flash illustration.'**
  String get exploreItemMythologyOctopusPrompt;

  /// Explore item title: Japanese Style Dragon
  ///
  /// In en, this message translates to:
  /// **'Japanese Style Dragon'**
  String get exploreItemMythologyJapaneseDragon;

  /// Explore item prompt: Japanese Style Dragon
  ///
  /// In en, this message translates to:
  /// **'Japanese style dragon tattoo design, powerful eastern dragon with long serpentine body coiling in an S-shaped composition, detailed layered scales, sharp horns and whiskers, fierce open mouth with fangs, claws extended, flowing mane and tail, surrounded by stylized clouds and flame elements, vibrant red, orange and gold color palette, bold clean outlines, neo-traditional japanese tattoo style, smooth gradient shading, high contrast, dynamic movement, professional tattoo flash illustration.'**
  String get exploreItemMythologyJapaneseDragonPrompt;

  /// Explore item title: Dark Fantasy Eye
  ///
  /// In en, this message translates to:
  /// **'Dark Fantasy Eye'**
  String get exploreItemMythologyDarkFantasyEye;

  /// Explore item prompt: Dark Fantasy Eye
  ///
  /// In en, this message translates to:
  /// **'Dark fantasy tattoo design featuring a central eye surrounded by multiple smaller eyes, all radiating a glowing red energy, large detailed wings extending from the center, with sharp feather tips and deep shadows, veins of red lightning running through the design, high contrast black and grey shading with fiery accents, intricate and symmetrical composition, modern gothic style, fine line detailing, powerful and intense mystical theme, dramatic atmosphere, professional tattoo flash illustration, minimal background with focus on the design.'**
  String get exploreItemMythologyDarkFantasyEyePrompt;

  /// Explore item title: Mermaid
  ///
  /// In en, this message translates to:
  /// **'Mermaid'**
  String get exploreItemMythologyMermaid;

  /// Explore item prompt: Mermaid
  ///
  /// In en, this message translates to:
  /// **'Vibrant, horror-themed mermaid tattoo design, grotesque mermaid with a skeletal, gnarled face, long wild hair in dark shades of black and deep purple, sharp claws, and twisted, muscular body, transitioning from human form to a fish tail with iridescent scales in shades of teal, blue, and green, eerie underwater creature vibe with glowing elements, fiery orange and red highlights on the tail and eyes, dramatic shading with contrasting dark tones, high detail, horror fantasy tattoo style with rich colors, professional flash tattoo, clean bold outlines, vivid contrasts.'**
  String get exploreItemMythologyMermaidPrompt;

  /// Explore item title: Dynamic Dragon
  ///
  /// In en, this message translates to:
  /// **'Dynamic Dragon'**
  String get exploreItemMythologyDynamicDragon;

  /// Explore item prompt: Dynamic Dragon
  ///
  /// In en, this message translates to:
  /// **'Vibrant and dynamic dragon tattoo design, serpent-like body with smooth scales transitioning from deep green to teal, fiery orange and golden wings stretching outward, feathered wings with a gradient of warm tones from orange to light yellow, sleek sinuous tail with fiery accents, detailed head with sharp features and subtle horns, dragon exuding energy and motion, dramatic shading to highlight the curves and texture of the body, fantasy style with vivid color palette, high contrast, professional tattoo illustration with clean bold outlines.'**
  String get exploreItemMythologyDynamicDragonPrompt;

  /// Explore item title: Trident
  ///
  /// In en, this message translates to:
  /// **'Trident'**
  String get exploreItemMythologyTrident;

  /// Explore item prompt: Trident
  ///
  /// In en, this message translates to:
  /// **'Gothic trident tattoo design with sharp, intricate details, the trident head adorned with dark, thorn-like spines and elegant curves, a serpent wrapping around the trident shaft, the body of the serpent with smooth scales and subtle shading, floral vine elements twisting around the trident, delicate yet powerful, dark and eerie black and grey shading with high contrast, dramatic shadow play, sharp outlines, and fine detail, professional tattoo flash, minimal background with focus on the weapon and serpent, symmetrical design.'**
  String get exploreItemMythologyTridentPrompt;

  /// Explore item title: Warrior
  ///
  /// In en, this message translates to:
  /// **'Warrior'**
  String get exploreItemMythologyWarrior;

  /// Explore item prompt: Warrior
  ///
  /// In en, this message translates to:
  /// **'Powerful fantasy warrior tattoo design, dragon-like figure with scales covering the face and neck, glowing blue eyes, long, detailed beard and sharp features, fiery orange and blue flame accents swirling around the character, sharp spiked armor and fins protruding from the back, holding a trident in one hand, dramatic shading with high contrast, detailed textures on the skin and weapon, vivid colors of fire and ice, strong mythical atmosphere, bold clean outlines, professional tattoo flash illustration, minimal background with focus on the character and flames.'**
  String get exploreItemMythologyWarriorPrompt;

  /// Pro access title first word
  ///
  /// In en, this message translates to:
  /// **'Get'**
  String get proAccessTitleGet;

  /// Pro access title highlighted word
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get proAccessTitlePro;

  /// Pro access title last word
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get proAccessTitleAccess;

  /// Pro access subtitle
  ///
  /// In en, this message translates to:
  /// **'Preview Tattoos On Yourself Instantly'**
  String get proAccessSubtitle;

  /// Pro access feature: unlimited tattoo creation
  ///
  /// In en, this message translates to:
  /// **'Unlimited Prompt Generation'**
  String get proAccessFeatureUnlimitedTattooCreation;

  /// Pro access feature: fast processing
  ///
  /// In en, this message translates to:
  /// **'Access All Tattoo Styles'**
  String get proAccessFeatureFastProcessing;

  /// Pro access feature: unlock all styles
  ///
  /// In en, this message translates to:
  /// **' Unlimited Try-On\'s'**
  String get proAccessFeatureUnlockAllStyles;

  /// Pro access feature: remove watermarks
  ///
  /// In en, this message translates to:
  /// **'No Watermarks'**
  String get proAccessFeatureRemoveWatermarks;

  /// Pro access free trial plan label
  ///
  /// In en, this message translates to:
  /// **'Free Trial'**
  String get proAccessPlanFreeTrial;

  /// Pro access weekly plan label
  ///
  /// In en, this message translates to:
  /// **'WEEKLY'**
  String get proAccessPlanWeekly;

  /// Pro access weekly plan price
  ///
  /// In en, this message translates to:
  /// **'--'**
  String get proAccessPlanWeeklyPrice;

  /// Pro access auto-renew text
  ///
  /// In en, this message translates to:
  /// **'Auto-renewable, Cancel anytime'**
  String get proAccessAutoRenewableCancelAnytime;

  /// Pro access helper text for lifetime plan
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime'**
  String get proAccessCancelAnytime;

  /// Label shown when trial toggle is off
  ///
  /// In en, this message translates to:
  /// **'Enable Trial'**
  String get proAccessEnableTrial;

  /// Label shown when trial toggle is on
  ///
  /// In en, this message translates to:
  /// **'Trial Enabled'**
  String get proAccessTrialEnabled;

  /// Subtitle shown under weekly plan title
  ///
  /// In en, this message translates to:
  /// **'3 days free trial'**
  String get proAccessWeeklyTrialSubtitle;

  /// Weekly price with period suffix
  ///
  /// In en, this message translates to:
  /// **'{price}/week'**
  String proAccessWeeklyPriceWithPeriod(Object price);

  /// Discount badge text shown on lifetime plan
  ///
  /// In en, this message translates to:
  /// **'87%'**
  String get proAccessLifetimeDiscountBadge;

  /// Pro access legal subscription note
  ///
  /// In en, this message translates to:
  /// **'After 3 days free - then weekly subscription for {price} will start. Cancel anytime 24 hours before renewal'**
  String proAccessLegalNote(Object price);

  /// Pro access lifetime plan label
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get proAccessPlanLifetimeSubscription;

  /// Pro access CTA for free trial plan
  ///
  /// In en, this message translates to:
  /// **'Continue for free'**
  String get proAccessContinueForFree;

  /// Pro access lifetime note without price
  ///
  /// In en, this message translates to:
  /// **'Skip the weekly fee - own it for life'**
  String get proAccessLifetimeLegalNoPrice;

  /// Pro access lifetime note with price
  ///
  /// In en, this message translates to:
  /// **'Lifetime subscription for {price} will start'**
  String proAccessLifetimeLegalWithPrice(Object price);
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
