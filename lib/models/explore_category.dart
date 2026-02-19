import '../l10n/app_localizations.dart';

class ExploreCategory {
  final String id;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) prompt;
  final String bigImagePath;
  final String? smallImagePath;
  final String? smallImagePathDark;
  final List<ExploreCategoryItem> items;

  const ExploreCategory({
    required this.id,
    required this.title,
    required this.prompt,
    required this.bigImagePath,
    this.smallImagePath,
    this.smallImagePathDark,
    required this.items,
  });
}

class ExploreCategoryItem {
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) prompt;
  final String bigImagePath;
  final String? smallImagePath;
  final String? smallImagePathDark;

  const ExploreCategoryItem({
    required this.title,
    required this.prompt,
    required this.bigImagePath,
    this.smallImagePath,
    this.smallImagePathDark,
  });
}

// Dummy data for 10 categories
class ExploreData {
  static final List<ExploreCategory> _baseCategories = [
    ExploreCategory(
      id: 'minimal',
      title: (l10n) => l10n.exploreCategoryMinimal,
      prompt: (l10n) => l10n.exploreCategoryMinimalDescription,
      bigImagePath: 'assets/minimal/pandabig.png',
      smallImagePath: 'assets/minimal/pandasmalllight.png',
      smallImagePathDark: 'assets/minimal/pandamalldark.png',
      items: [
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMinimalistPanda,
          prompt: (l10n) => l10n.exploreItemMinimalistPandaPrompt,
          bigImagePath: 'assets/minimal/pandabig.png',
          smallImagePath: 'assets/minimal/pandasmalllight.png',
          smallImagePathDark: 'assets/minimal/pandamalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFineLineBow,
          prompt: (l10n) => l10n.exploreItemFineLineBowPrompt,
          bigImagePath: 'assets/minimal/bowbig.png',
          smallImagePath: 'assets/minimal/bowsmalllight.png',
          smallImagePathDark: 'assets/minimal/bowdarksmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMicroRealismFinger,
          prompt: (l10n) => l10n.exploreItemMicroRealismFingerPrompt,
          bigImagePath: 'assets/minimal/microrealsimbig.png',
          smallImagePath: 'assets/minimal/microrealsimsmalllight.png',
          smallImagePathDark: 'assets/minimal/microrealsimsmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFineLineCatCircle,
          prompt: (l10n) => l10n.exploreItemFineLineCatCirclePrompt,
          bigImagePath: 'assets/minimal/catbig.png',
          smallImagePath: 'assets/minimal/catsmalllight.png',
          smallImagePathDark: 'assets/minimal/catsmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFineLineLotusFlower,
          prompt: (l10n) => l10n.exploreItemFineLineLotusFlowerPrompt,
          bigImagePath: 'assets/minimal/finrlinelotusbig.png',
          smallImagePath: 'assets/minimal/finrlinelotussmalllight.png',
          smallImagePathDark: 'assets/minimal/finelinelotussmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemSleepingCatCrescent,
          prompt: (l10n) => l10n.exploreItemSleepingCatCrescentPrompt,
          bigImagePath: 'assets/minimal/sleepingcatbig.png',
          smallImagePath: 'assets/minimal/sleepingcatsmalllight.png',
          smallImagePathDark: 'assets/minimal/sleepingcatdarksmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFineLineHeartStars,
          prompt: (l10n) => l10n.exploreItemFineLineHeartStarsPrompt,
          bigImagePath: 'assets/minimal/finelineheartbig.png',
          smallImagePath: 'assets/minimal/finelineheartsmalllight.png',
          smallImagePathDark: 'assets/minimal/finelineheartsmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFineLineCompassStar,
          prompt: (l10n) => l10n.exploreItemFineLineCompassStarPrompt,
          bigImagePath: 'assets/minimal/compassbig.png',
          smallImagePath: 'assets/minimal/compasslightsmall.png',
          smallImagePathDark: 'assets/minimal/compasssmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMinimalTrebleClef,
          prompt: (l10n) => l10n.exploreItemMinimalTrebleClefPrompt,
          bigImagePath: 'assets/minimal/clefneckbig.png',
          smallImagePath: 'assets/minimal/clefnecklightsmall.png',
          smallImagePathDark: 'assets/minimal/clefnecksmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemStarryHeart,
          prompt: (l10n) => l10n.exploreItemStarryHeartPrompt,
          bigImagePath: 'assets/minimal/staryyheartbig.png',
          smallImagePath: 'assets/minimal/staryyheartsmalllight.png',
          smallImagePathDark: 'assets/minimal/staryyheartsmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemValknutTriangle,
          prompt: (l10n) => l10n.exploreItemValknutTrianglePrompt,
          bigImagePath: 'assets/minimal/valknutbig.png',
          smallImagePath: 'assets/minimal/valknutsmalllight.png',
          smallImagePathDark: 'assets/minimal/valknutsmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMinimalistMountain,
          prompt: (l10n) => l10n.exploreItemMinimalistMountainPrompt,
          bigImagePath: 'assets/minimal/mountainbig.png',
          smallImagePath: 'assets/minimal/mountainsmalllight.png',
          smallImagePathDark: 'assets/minimal/mountainsmalldark.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'traditional',
      title: (l10n) => l10n.exploreCategoryTraditional,
      prompt: (l10n) => l10n.exploreCategoryTraditionalDescription,
      bigImagePath: 'assets/oldschool/swallowbird.png',
      smallImagePath: 'assets/oldschool/swallowbird.png',
      items: [
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemSwallowBird,
          prompt: (l10n) => l10n.exploreItemSwallowBirdPrompt,
          bigImagePath: 'assets/oldschool/swallowbird.png',
          smallImagePath: 'assets/oldschool/swallowbird.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemDaggerHeart,
          prompt: (l10n) => l10n.exploreItemDaggerHeartPrompt,
          bigImagePath: 'assets/oldschool/daggerheart.png',
          smallImagePath: 'assets/oldschool/daggerheart.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemSkullClassic,
          prompt: (l10n) => l10n.exploreItemSkullClassicPrompt,
          bigImagePath: 'assets/oldschool/skullclassic.png',
          smallImagePath: 'assets/oldschool/skullclassic.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemEagleSpread,
          prompt: (l10n) => l10n.exploreItemEagleSpreadPrompt,
          bigImagePath: 'assets/oldschool/eaglespread.png',
          smallImagePath: 'assets/oldschool/eaglespread.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemSnakeCoiled,
          prompt: (l10n) => l10n.exploreItemSnakeCoiledPrompt,
          bigImagePath: 'assets/oldschool/snakecoiled.png',
          smallImagePath: 'assets/oldschool/snakecoiled.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemShipWheel,
          prompt: (l10n) => l10n.exploreItemShipWheelPrompt,
          bigImagePath: 'assets/oldschool/shipwheel.png',
          smallImagePath: 'assets/oldschool/shipwheel.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemCowboyRevolver,
          prompt: (l10n) => l10n.exploreItemCowboyRevolverPrompt,
          bigImagePath: 'assets/oldschool/cowboy.png',
          smallImagePath: 'assets/oldschool/cowboy.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemPantherHead,
          prompt: (l10n) => l10n.exploreItemPantherHeadPrompt,
          bigImagePath: 'assets/oldschool/panther.png',
          smallImagePath: 'assets/oldschool/panther.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'japanese',
      title: (l10n) => l10n.exploreCategoryJapanese,
      prompt: (l10n) => l10n.exploreCategoryJapaneseDescription,
      bigImagePath: 'assets/japanese/koi_fish.png',
      smallImagePath: 'assets/japanese/koi_fish.png',
      items: [
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemKoiFish,
          prompt: (l10n) => l10n.exploreItemKoiFishPrompt,
          bigImagePath: 'assets/japanese/koi_fish.png',
          smallImagePath: 'assets/japanese/koi_fish.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemHannyaMask,
          prompt: (l10n) => l10n.exploreItemHannyaMaskPrompt,
          bigImagePath: 'assets/japanese/hannyamask.png',
          smallImagePath: 'assets/japanese/hannyamask.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemSamuraiHelmet,
          prompt: (l10n) => l10n.exploreItemSamuraiHelmetPrompt,
          bigImagePath: 'assets/japanese/samuraihelmet.png',
          smallImagePath: 'assets/japanese/samuraihelmet.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemCherryBlossomBranch,
          prompt: (l10n) => l10n.exploreItemCherryBlossomBranchPrompt,
          bigImagePath: 'assets/japanese/cherryblossombranch.png',
          smallImagePath: 'assets/japanese/cherryblossombranch.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemJapaneseDragon,
          prompt: (l10n) => l10n.exploreItemJapaneseDragonPrompt,
          bigImagePath: 'assets/japanese/japanesedragon.png',
          smallImagePath: 'assets/japanese/japanesedragon.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemOniMask,
          prompt: (l10n) => l10n.exploreItemOniMaskPrompt,
          bigImagePath: 'assets/japanese/onimask.png',
          smallImagePath: 'assets/japanese/onimask.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemHokusaiWave,
          prompt: (l10n) => l10n.exploreItemHokusaiWavePrompt,
          bigImagePath: 'assets/japanese/wave.png',
          smallImagePath: 'assets/japanese/wave.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemJapaneseTiger,
          prompt: (l10n) => l10n.exploreItemJapaneseTigerPrompt,
          bigImagePath: 'assets/japanese/tiger.png',
          smallImagePath: 'assets/japanese/tiger.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemJapaneseLotus,
          prompt: (l10n) => l10n.exploreItemJapaneseLotusPrompt,
          bigImagePath: 'assets/japanese/lotus.png',
          smallImagePath: 'assets/japanese/lotus.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemJapanesePhoenix,
          prompt: (l10n) => l10n.exploreItemJapanesePhoenixPrompt,
          bigImagePath: 'assets/japanese/phoenix.png',
          smallImagePath: 'assets/japanese/phoenix.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'tribal',
      title: (l10n) => l10n.exploreCategoryTribal,
      prompt: (l10n) => l10n.exploreCategoryTribalDescription,
      bigImagePath: 'assets/tribal_designs/polynesianbig.png',
      smallImagePath: 'assets/tribal_designs/polynesiansmalllight.png',
      smallImagePathDark: 'assets/tribal_designs/polynesiansmalldark.png',
      items: [
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemPolynesianTribal,
          prompt: (l10n) => l10n.exploreItemPolynesianTribalPrompt,
          bigImagePath: 'assets/tribal_designs/polynesianbig.png',
          smallImagePath: 'assets/tribal_designs/polynesiansmalllight.png',
          smallImagePathDark: 'assets/tribal_designs/polynesiansmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemTribalSpineSpear,
          prompt: (l10n) => l10n.exploreItemTribalSpineSpearPrompt,
          bigImagePath: 'assets/tribal_designs/spearbig.png',
          smallImagePath: 'assets/tribal_designs/spearsmalllight.png',
          smallImagePathDark: 'assets/tribal_designs/spearsmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemTribalKnotwork,
          prompt: (l10n) => l10n.exploreItemTribalKnotworkPrompt,
          bigImagePath: 'assets/tribal_designs/knotworkbig.png',
          smallImagePath: 'assets/tribal_designs/knotworksmalllight.png',
          smallImagePathDark: 'assets/tribal_designs/knotworksmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemTribalForearmSleeve,
          prompt: (l10n) => l10n.exploreItemTribalForearmSleevePrompt,
          bigImagePath: 'assets/tribal_designs/tribalsleevebig.png',
          smallImagePath: 'assets/tribal_designs/tribalsleevesmalllight.png',
          smallImagePathDark: 'assets/tribal_designs/tribalsleevesmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemTribalCentralSpiral,
          prompt: (l10n) => l10n.exploreItemTribalCentralSpiralPrompt,
          bigImagePath: 'assets/tribal_designs/centralspiralbig.png',
          smallImagePath: 'assets/tribal_designs/centralsmalllight.png',
          smallImagePathDark:
              'assets/tribal_designs/centralspiralsmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemTribalFlameForearm,
          prompt: (l10n) => l10n.exploreItemTribalFlameForearmPrompt,
          bigImagePath: 'assets/tribal_designs/flameforearmbig.png',
          smallImagePath: 'assets/tribal_designs/flameforearmsmalllight.png',
          smallImagePathDark: 'assets/tribal_designs/flameforearmsmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemTribalSpiralFlame,
          prompt: (l10n) => l10n.exploreItemTribalSpiralFlamePrompt,
          bigImagePath: 'assets/tribal_designs/spiralbig.png',
          smallImagePath: 'assets/tribal_designs/spirallightsmall.png',
          smallImagePathDark: 'assets/tribal_designs/spiralsmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemTribalCompass,
          prompt: (l10n) => l10n.exploreItemTribalCompassPrompt,
          bigImagePath: 'assets/tribal_designs/tribalbig.png',
          smallImagePath: 'assets/tribal_designs/tribalsmalllight.png',
          smallImagePathDark: 'assets/tribal_designs/tribalsmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemTribalModernGeometric,
          prompt: (l10n) => l10n.exploreItemTribalModernGeometricPrompt,
          bigImagePath: 'assets/tribal_designs/modernbig.png',
          smallImagePath: 'assets/tribal_designs/modernsmalllight.png',
          smallImagePathDark: 'assets/tribal_designs/modernsmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemTribalNeoBack,
          prompt: (l10n) => l10n.exploreItemTribalNeoBackPrompt,
          bigImagePath: 'assets/tribal_designs/neobig.png',
          smallImagePath: 'assets/tribal_designs/neosmalllight.png',
          smallImagePathDark: 'assets/tribal_designs/neosmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemTribalFlame,
          prompt: (l10n) => l10n.exploreItemTribalFlamePrompt,
          bigImagePath: 'assets/tribal_designs/flamebig.png',
          smallImagePath: 'assets/tribal_designs/flamelightsmall.png',
          smallImagePathDark: 'assets/tribal_designs/flamesmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemTribalSwordCompass,
          prompt: (l10n) => l10n.exploreItemTribalSwordCompassPrompt,
          bigImagePath: 'assets/tribal_designs/swordbig.png',
          smallImagePath: 'assets/tribal_designs/swordlightsmall.png',
          smallImagePathDark: 'assets/tribal_designs/swordsmalldark.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'geometric',
      title: (l10n) => l10n.exploreCategoryGeometric,
      prompt: (l10n) => l10n.exploreCategoryGeometricDescription,
      bigImagePath: 'assets/geometrical/mindbodybig.png',
      smallImagePath: 'assets/geometrical/mindbodysmalllight.png',
      smallImagePathDark: 'assets/geometrical/mindbodysmalldark.png',
      items: [
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemGeometricMindBodySoul,
          prompt: (l10n) => l10n.exploreItemGeometricMindBodySoulPrompt,
          bigImagePath: 'assets/geometrical/mindbodybig.png',
          smallImagePath: 'assets/geometrical/mindbodysmalllight.png',
          smallImagePathDark: 'assets/geometrical/mindbodysmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemGeometricHoneycombSleeve,
          prompt: (l10n) => l10n.exploreItemGeometricHoneycombSleevePrompt,
          bigImagePath: 'assets/geometrical/honeycombbig.png',
          smallImagePath: 'assets/geometrical/honeycomblightsmall.png',
          smallImagePathDark: 'assets/geometrical/honeycombsmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemGeometricBlackwork,
          prompt: (l10n) => l10n.exploreItemGeometricBlackworkPrompt,
          bigImagePath: 'assets/geometrical/blackworkbig.png',
          smallImagePath: 'assets/geometrical/blackworksmalllight.png',
          smallImagePathDark: 'assets/geometrical/blackworksmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemGeometricCubeSleeve,
          prompt: (l10n) => l10n.exploreItemGeometricCubeSleevePrompt,
          bigImagePath: 'assets/geometrical/cubesleevebig.png',
          smallImagePath: 'assets/geometrical/cubesleevesmallight.png',
          smallImagePathDark: 'assets/geometrical/cubesleevesmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemGeometric3dCubeSleeve,
          prompt: (l10n) => l10n.exploreItemGeometric3dCubeSleevePrompt,
          bigImagePath: 'assets/geometrical/geometricsleevebig.png',
          smallImagePath: 'assets/geometrical/geometricsleevesmalllight.png',
          smallImagePathDark: 'assets/geometrical/geometricsleevesmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemGeometricTreeOfLife,
          prompt: (l10n) => l10n.exploreItemGeometricTreeOfLifePrompt,
          bigImagePath: 'assets/geometrical/treeoflifebig.png',
          smallImagePath: 'assets/geometrical/treeoflifelight.png',
          smallImagePathDark: 'assets/geometrical/treeoflifesmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemGeometricAtlas,
          prompt: (l10n) => l10n.exploreItemGeometricAtlasPrompt,
          bigImagePath: 'assets/geometrical/atlasbig.png',
          smallImagePath: 'assets/geometrical/atlassmalllight.png',
          smallImagePathDark: 'assets/geometrical/atlassmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemGeometricTriadTravel,
          prompt: (l10n) => l10n.exploreItemGeometricTriadTravelPrompt,
          bigImagePath: 'assets/geometrical/triadbig.png',
          smallImagePath: 'assets/geometrical/triadsmalllight.png',
          smallImagePathDark: 'assets/geometrical/triadsmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemGeometricHorizons,
          prompt: (l10n) => l10n.exploreItemGeometricHorizonsPrompt,
          bigImagePath: 'assets/geometrical/horizonsbig.png',
          smallImagePath: 'assets/geometrical/horizonssmalllight.png',
          smallImagePathDark: 'assets/geometrical/horizonssmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemGeometricAlignedTriad,
          prompt: (l10n) => l10n.exploreItemGeometricAlignedTriadPrompt,
          bigImagePath: 'assets/geometrical/alignedtriadbig.png',
          smallImagePath: 'assets/geometrical/alignedtriadsmalllight.png',
          smallImagePathDark: 'assets/geometrical/alignedsmalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemGeometricSigi,
          prompt: (l10n) => l10n.exploreItemGeometricSigiPrompt,
          bigImagePath: 'assets/geometrical/sigibig.png',
          smallImagePath: 'assets/geometrical/sigismalllight.png',
          smallImagePathDark: 'assets/geometrical/sigismalldark.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemGeometricDualityNature,
          prompt: (l10n) => l10n.exploreItemGeometricDualityNaturePrompt,
          bigImagePath: 'assets/geometrical/dualitynaturebig.png',
          smallImagePath: 'assets/geometrical/dualitynaturesmalllight.png',
          smallImagePathDark: 'assets/geometrical/dualitynaturesmalldark.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'realism',
      title: (l10n) => l10n.exploreCategoryRealism,
      prompt: (l10n) => l10n.exploreCategoryRealismDescription,
      bigImagePath: 'assets/realism_and_portrait/gambler_big.png',
      smallImagePath: 'assets/realism_and_portrait/gambler_small.png',
      items: [
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemRealismGamblerFedora,
          prompt: (l10n) => l10n.exploreItemRealismGamblerFedoraPrompt,
          bigImagePath: 'assets/realism_and_portrait/gambler_big.png',
          smallImagePath: 'assets/realism_and_portrait/gambler_small.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemRealismMindOverHeart,
          prompt: (l10n) => l10n.exploreItemRealismMindOverHeartPrompt,
          bigImagePath: 'assets/realism_and_portrait/mindoverheartbig.png',
          smallImagePath: 'assets/realism_and_portrait/mindoverheartsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemRealismGeometricSplit,
          prompt: (l10n) => l10n.exploreItemRealismGeometricSplitPrompt,
          bigImagePath: 'assets/realism_and_portrait/geometricsplit_big.png',
          smallImagePath:
              'assets/realism_and_portrait/geometricsplit_small.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemRealismFieryCosmic,
          prompt: (l10n) => l10n.exploreItemRealismFieryCosmicPrompt,
          bigImagePath:
              'assets/realism_and_portrait/fiery andcosmicsplit_large.png',
          smallImagePath:
              'assets/realism_and_portrait/fiery andcosmicsplit_small.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemRealismSinisterClown,
          prompt: (l10n) => l10n.exploreItemRealismSinisterClownPrompt,
          bigImagePath:
              'assets/realism_and_portrait/sinister _clown_portrait_large.png',
          smallImagePath:
              'assets/realism_and_portrait/sinister _clown_portrait_small.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemRealismButterflyWoman,
          prompt: (l10n) => l10n.exploreItemRealismButterflyWomanPrompt,
          bigImagePath:
              'assets/realism_and_portrait/butterflyandwoman_large.png',
          smallImagePath:
              'assets/realism_and_portrait/butterflyandwoman_small.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemRealismFlamingSkull,
          prompt: (l10n) => l10n.exploreItemRealismFlamingSkullPrompt,
          bigImagePath: 'assets/realism_and_portrait/flamingskull_large.png',
          smallImagePath: 'assets/realism_and_portrait/flamingskull_small.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemRealismFierceWolf,
          prompt: (l10n) => l10n.exploreItemRealismFierceWolfPrompt,
          bigImagePath: 'assets/realism_and_portrait/fiercewolf_large.png',
          smallImagePath: 'assets/realism_and_portrait/fiercewolf_small .png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemRealismRedRoseButterfly,
          prompt: (l10n) => l10n.exploreItemRealismRedRoseButterflyPrompt,
          bigImagePath:
              'assets/realism_and_portrait/redrosebutterfly_large.png',
          smallImagePath:
              'assets/realism_and_portrait/redrosebutterfly_small.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemRealismVibrantPeacock,
          prompt: (l10n) => l10n.exploreItemRealismVibrantPeacockPrompt,
          bigImagePath: 'assets/realism_and_portrait/vibrant_peacock_large.png',
          smallImagePath:
              'assets/realism_and_portrait/vibrant_peacock_small.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemRealismPlayfulCharacter,
          prompt: (l10n) => l10n.exploreItemRealismPlayfulCharacterPrompt,
          bigImagePath: 'assets/realism_and_portrait/playful_character_big.png',
          smallImagePath:
              'assets/realism_and_portrait/playful_character_small.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemRealismCutePinkFish,
          prompt: (l10n) => l10n.exploreItemRealismCutePinkFishPrompt,
          bigImagePath: 'assets/realism_and_portrait/cute_pink_fish_large.png',
          smallImagePath:
              'assets/realism_and_portrait/cute_pink_fish_small.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'lettering',
      title: (l10n) => l10n.exploreCategoryLettering,
      prompt: (l10n) => l10n.exploreCategoryLetteringDescription,
      bigImagePath: 'assets/letters/trutnoonebig.png',
      smallImagePath: 'assets/letters/trustnoone_small.png',
      items: [
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemLetteringTrustNoOne,
          prompt: (l10n) => l10n.exploreItemLetteringTrustNoOnePrompt,
          bigImagePath: 'assets/letters/trutnoonebig.png',
          smallImagePath: 'assets/letters/trustnoone_small.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemLetteringBlessed,
          prompt: (l10n) => l10n.exploreItemLetteringBlessedPrompt,
          bigImagePath: 'assets/letters/blessedbig.png',
          smallImagePath: 'assets/letters/blessedsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemLetteringHakunaMatata,
          prompt: (l10n) => l10n.exploreItemLetteringHakunaMatataPrompt,
          bigImagePath: 'assets/letters/hakunamatatabig.png',
          smallImagePath: 'assets/letters/hakunamatatasmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemLetteringDream,
          prompt: (l10n) => l10n.exploreItemLetteringDreamPrompt,
          bigImagePath: 'assets/letters/dreambig.png',
          smallImagePath: 'assets/letters/dreamsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemLetteringBoom,
          prompt: (l10n) => l10n.exploreItemLetteringBoomPrompt,
          bigImagePath: 'assets/letters/boombig.png',
          smallImagePath: 'assets/letters/boomsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemLetteringWorkHardDreamBig,
          prompt: (l10n) => l10n.exploreItemLetteringWorkHardDreamBigPrompt,
          bigImagePath: 'assets/letters/workhardbig.png',
          smallImagePath: 'assets/letters/workhardsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemLetteringRn,
          prompt: (l10n) => l10n.exploreItemLetteringRnPrompt,
          bigImagePath: 'assets/letters/rnbig.png',
          smallImagePath: 'assets/letters/rnsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemLetteringC,
          prompt: (l10n) => l10n.exploreItemLetteringCPrompt,
          bigImagePath: 'assets/letters/cbig.png',
          smallImagePath: 'assets/letters/csmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemLetteringPeacePositivity,
          prompt: (l10n) => l10n.exploreItemLetteringPeacePositivityPrompt,
          bigImagePath: 'assets/letters/peacebig.png',
          smallImagePath: 'assets/letters/peacesmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemLetteringDreamBig,
          prompt: (l10n) => l10n.exploreItemLetteringDreamBigPrompt,
          bigImagePath: 'assets/letters/dreambig_big.png',
          smallImagePath: 'assets/letters/dreambig_small.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemLetteringDesire,
          prompt: (l10n) => l10n.exploreItemLetteringDesirePrompt,
          bigImagePath: 'assets/letters/desirebig.png',
          smallImagePath: 'assets/letters/desiresmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemLetteringBeautiful,
          prompt: (l10n) => l10n.exploreItemLetteringBeautifulPrompt,
          bigImagePath: 'assets/letters/beautifullarge.png',
          smallImagePath: 'assets/letters/beautifulsmall.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'floral',
      title: (l10n) => l10n.exploreCategoryFloral,
      prompt: (l10n) => l10n.exploreCategoryFloralDescription,
      bigImagePath: 'assets/floral/Minimalistfourleafcloverwithheartbig.png',
      smallImagePath:
          'assets/floral/Minimalistfourleafcloverwithheartsmall.png',
      items: [
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFloralFourLeafClover,
          prompt: (l10n) => l10n.exploreItemFloralFourLeafCloverPrompt,
          bigImagePath:
              'assets/floral/Minimalistfourleafcloverwithheartbig.png',
          smallImagePath:
              'assets/floral/Minimalistfourleafcloverwithheartsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFloralCherryBlossom,
          prompt: (l10n) => l10n.exploreItemFloralCherryBlossomPrompt,
          bigImagePath: 'assets/floral/Cherryblossombranchbig.png',
          smallImagePath: 'assets/floral/Cherryblossombranchsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFloralMountainLandscape,
          prompt: (l10n) => l10n.exploreItemFloralMountainLandscapePrompt,
          bigImagePath: 'assets/floral/mountainlandscapebig.png',
          smallImagePath: 'assets/floral/mountainlandscapesmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFloralHeartSunset,
          prompt: (l10n) => l10n.exploreItemFloralHeartSunsetPrompt,
          bigImagePath: 'assets/floral/Heartshaped sunsetbig.png',
          smallImagePath: 'assets/floral/Heartshaped sunsetsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFloralSeaTurtle,
          prompt: (l10n) => l10n.exploreItemFloralSeaTurtlePrompt,
          bigImagePath: 'assets/floral/seaturtlebig.png',
          smallImagePath: 'assets/floral/seaturtlesmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFloralHibiscus,
          prompt: (l10n) => l10n.exploreItemFloralHibiscusPrompt,
          bigImagePath: 'assets/floral/Hibiscusflowerbig.png',
          smallImagePath: 'assets/floral/Hibiscusflowersmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFloralButterflyLily,
          prompt: (l10n) => l10n.exploreItemFloralButterflyLilyPrompt,
          bigImagePath: 'assets/floral/butterflyandlilyflowersbig.png',
          smallImagePath: 'assets/floral/butterflyandlilyflowersmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFloralButterfly,
          prompt: (l10n) => l10n.exploreItemFloralButterflyPrompt,
          bigImagePath: 'assets/floral/Butterfly_big.png',
          smallImagePath: 'assets/floral/Butterfly_small.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFloralHummingbirdCherry,
          prompt: (l10n) => l10n.exploreItemFloralHummingbirdCherryPrompt,
          bigImagePath: 'assets/floral/Hummingbirdandcherryblossombig.png',
          smallImagePath: 'assets/floral/Hummingbirdandcherryblossomsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFloralButterflyBracelet,
          prompt: (l10n) => l10n.exploreItemFloralButterflyBraceletPrompt,
          bigImagePath: 'assets/floral/Butterflybraceletbig.png',
          smallImagePath: 'assets/floral/Butterflybraceletsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFloralBabyPanda,
          prompt: (l10n) => l10n.exploreItemFloralBabyPandaPrompt,
          bigImagePath: 'assets/floral/babypandabig.png',
          smallImagePath: 'assets/floral/babypandasmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemFloralSunMoon,
          prompt: (l10n) => l10n.exploreItemFloralSunMoonPrompt,
          bigImagePath: 'assets/floral/sunmoonbig.png',
          smallImagePath: 'assets/floral/sunmoonsmall.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'mythology',
      title: (l10n) => l10n.exploreCategoryMythology,
      prompt: (l10n) => l10n.exploreCategoryMythologyDescription,
      bigImagePath: 'assets/myths/warriorandserpentsbig.png',
      smallImagePath: 'assets/myths/warriorandserpentsmall.png',
      items: [
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMythologyWarriorSerpents,
          prompt: (l10n) => l10n.exploreItemMythologyWarriorSerpentsPrompt,
          bigImagePath: 'assets/myths/warriorandserpentsbig.png',
          smallImagePath: 'assets/myths/warriorandserpentsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMythologyPhoenixRising,
          prompt: (l10n) => l10n.exploreItemMythologyPhoenixRisingPrompt,
          bigImagePath: 'assets/myths/phoenixrisingbig.png',
          smallImagePath: 'assets/myths/phoenixrisingsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMythologyMedusa,
          prompt: (l10n) => l10n.exploreItemMythologyMedusaPrompt,
          bigImagePath: 'assets/myths/medusabig.png',
          smallImagePath: 'assets/myths/medusasmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMythologyDragonSword,
          prompt: (l10n) => l10n.exploreItemMythologyDragonSwordPrompt,
          bigImagePath: 'assets/myths/dragoncoiledlarge.png',
          smallImagePath: 'assets/myths/dragoncoiledsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMythologyThreeHeadedHydra,
          prompt: (l10n) => l10n.exploreItemMythologyThreeHeadedHydraPrompt,
          bigImagePath: 'assets/myths/hydrabig.png',
          smallImagePath: 'assets/myths/hydrasmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMythologyOctopus,
          prompt: (l10n) => l10n.exploreItemMythologyOctopusPrompt,
          bigImagePath: 'assets/myths/octopusbig.png',
          smallImagePath: 'assets/myths/octopussmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMythologyJapaneseDragon,
          prompt: (l10n) => l10n.exploreItemMythologyJapaneseDragonPrompt,
          bigImagePath: 'assets/myths/japanesedragonbig.png',
          smallImagePath: 'assets/myths/japanesedragonsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMythologyDarkFantasyEye,
          prompt: (l10n) => l10n.exploreItemMythologyDarkFantasyEyePrompt,
          bigImagePath: 'assets/myths/darkfantasyeyesbig.png',
          smallImagePath: 'assets/myths/darkfantasyeyesmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMythologyMermaid,
          prompt: (l10n) => l10n.exploreItemMythologyMermaidPrompt,
          bigImagePath: 'assets/myths/mermaidbig.png',
          smallImagePath: 'assets/myths/mermaidsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMythologyDynamicDragon,
          prompt: (l10n) => l10n.exploreItemMythologyDynamicDragonPrompt,
          bigImagePath: 'assets/myths/dynamicdragonbig.png',
          smallImagePath: 'assets/myths/dynamicdragonsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMythologyTrident,
          prompt: (l10n) => l10n.exploreItemMythologyTridentPrompt,
          bigImagePath: 'assets/myths/tridentbig.png',
          smallImagePath: 'assets/myths/tridentsmall.png',
        ),
        ExploreCategoryItem(
          title: (l10n) => l10n.exploreItemMythologyWarrior,
          prompt: (l10n) => l10n.exploreItemMythologyWarriorPrompt,
          bigImagePath: 'assets/myths/warriorbig.png',
          smallImagePath: 'assets/myths/warriorsmall.png',
        ),
      ],
    ),
  ];

  static List<ExploreCategory> get categories {
    // Aggregating all items from base categories
    final List<ExploreCategoryItem> allItems = [];
    for (final category in _baseCategories) {
      allItems.addAll(category.items);
    }

    // Shuffle to show random order each time
    allItems.shuffle();

    final     customAi = ExploreCategory(
      id: 'custom_ai',
      title: (l10n) => l10n.exploreCategoryCustomAi,
      prompt: (l10n) => l10n.exploreCategoryCustomAiDescription,
      // Use the image of the first item as the cover, or a fixed one.
      // Keeping fixed one for consistency or maybe random?
      // Let's keep the fixed panda one to avoid broken paths if random item doesn't have one.
      bigImagePath: 'assets/minimal/pandabig.png',
      smallImagePath: 'assets/minimal/pandasmalllight.png',
      smallImagePathDark: 'assets/minimal/pandamalldark.png',
      items: allItems,
    );

    return [..._baseCategories, customAi];
  }
}
