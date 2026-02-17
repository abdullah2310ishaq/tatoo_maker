class ExploreCategory {
  final String id;
  final String title;
  final String prompt;
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
  final String title;
  final String prompt;
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
  static const List<ExploreCategory> categories = [
    ExploreCategory(
      id: 'minimal',
      title: 'Minimal Tattoos',
      prompt:
          'Simple, clean lines with minimalist aesthetic. Perfect for subtle, elegant designs.',
      bigImagePath: 'assets/minimal/pandabig.png',
      smallImagePath: 'assets/minimal/pandasmalllight.png',
      smallImagePathDark: 'assets/minimal/pandamalldark.png',
      items: [
        ExploreCategoryItem(
          title: 'Minimalist Panda',
          prompt:
              'A tiny minimalist ankle tattoo of a cute panda sitting upright, facing slightly right, drawn with clean black lines and soft micro-shading. The panda holds a thin green stem with small purple lavender flowers, with subtle botanical detail and glossy black ears and arms. The design is centered on ankle skin, photographed in natural light with shallow depth of field and a minimal, professional tattoo reference style in a 1:1 composition.',
          bigImagePath: 'assets/minimal/pandabig.png',
          smallImagePath: 'assets/minimal/pandasmalllight.png',
          smallImagePathDark: 'assets/minimal/pandamalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Fine-Line Bow',
          prompt:
              'A tiny minimalist inner-wrist tattoo of a delicate ribbon bow, drawn with thin black linework and a small center knot. The design is symmetrical, clean, and micro-tattoo style, placed on smooth pale wrist skin. Shot in soft natural light with shallow depth of field, it has a modern minimalist aesthetic and professional tattoo reference look.',
          bigImagePath: 'assets/minimal/bowbig.png',
          smallImagePath: 'assets/minimal/bowsmalllight.png',
          smallImagePathDark: 'assets/minimal/bowdarksmall.png',
        ),
        ExploreCategoryItem(
          title: 'Micro Realism Finger Tattoos',
          prompt:
              'An ultra-realistic macro shot of a middle finger showing two tiny micro tattoos above the knuckle: a small sitting cat facing right and a delicate butterfly with fine linework and subtle shading. The scene features natural skin texture, warm neutral lighting, shallow depth of field, and a clean beige background, styled like a high-detail professional tattoo reference photo.',
          bigImagePath: 'assets/minimal/microrealsimbig.png',
          smallImagePath: 'assets/minimal/microrealsimsmalllight.png',
          smallImagePathDark: 'assets/minimal/microrealsimsmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Fine-Line Cat in Circle',
          prompt:
              'A minimalist upper-back tattoo below the neck showing a small black silhouette cat sitting and facing away, with a long curved tail. It\'s encircled by a thin, delicate incomplete circle with tiny leaves and a small flower, done in ultra-clean fine-line black ink. The scene features realistic skin texture, soft natural lighting, shallow depth of field, and a modern, photorealistic tattoo reference style.',
          bigImagePath: 'assets/minimal/catbig.png',
          smallImagePath: 'assets/minimal/catsmalllight.png',
          smallImagePathDark: 'assets/minimal/catsmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Fine-Line Lotus Flower',
          prompt:
              'A minimalist fine-line lotus flower tattoo with delicate layered petals and a thin stem with small leaves and buds, done in clean black ink. Beside it sits a small solid black heart with two tiny dots, all in a micro-tattoo style. The design is centered on smooth skin, photographed in warm natural light with shallow depth of field and a modern, photorealistic tattoo reference aesthetic.',
          bigImagePath: 'assets/minimal/finrlinelotusbig.png',
          smallImagePath: 'assets/minimal/finrlinelotussmalllight.png',
          smallImagePathDark: 'assets/minimal/finelinelotussmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Sleeping Cat in Crescent Moon',
          prompt:
              'A tiny minimalist micro tattoo of a sleeping kitten curled inside a thin crescent moon, with soft black-and-grey shading and delicate sparkles around it. The design features clean fine-line work and subtle fur detail, placed on wrist or forearm skin and photographed in warm natural light with a shallow depth of field for a high-detail, photorealistic tattoo reference look.',
          bigImagePath: 'assets/minimal/sleepingcatbig.png',
          smallImagePath: 'assets/minimal/sleepingcatsmalllight.png',
          smallImagePathDark: 'assets/minimal/sleepingcatdarksmall.png',
        ),
        ExploreCategoryItem(
          title: 'Fine-Line Heart and Stars',
          prompt:
              'A minimalist geometric forearm tattoo featuring a solid black heart with sharp edges, flanked by thin four-point star sparkles above and below. Small black dots and tiny outlined circles form a symmetrical vertical layout around it. Done in clean fine-line black ink on smooth skin, photographed in soft natural light with a modern, high-detail tattoo reference style.',
          bigImagePath: 'assets/minimal/finelineheartbig.png',
          smallImagePath: 'assets/minimal/finelineheartsmalllight.png',
          smallImagePathDark: 'assets/minimal/finelineheartsmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Fine-Line Compass Star',
          prompt:
              'A minimalist inner-forearm micro tattoo featuring a centered geometric compass-style 8-point star with sharp, clean black lines and four tiny dots around it. A small outline heart sits directly below the star. The design is ultra-clean and symmetrical, photographed on smooth skin with soft natural lighting and a modern, photorealistic tattoo reference style.',
          bigImagePath: 'assets/minimal/compassbig.png',
          smallImagePath: 'assets/minimal/compasslightsmall.png',
          smallImagePathDark: 'assets/minimal/compasssmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Minimal Treble Clef Neck',
          prompt:
              'A small glossy black treble clef tattoo with three tiny music notes, placed behind the ear on the side of the neck. Done in bold, clean lines, it\'s photographed in soft warm lighting with realistic skin texture, a visible ear with a silver stud earring, and a shallow depth of field for a detailed, minimal tattoo reference look.',
          bigImagePath: 'assets/minimal/clefneckbig.png',
          smallImagePath: 'assets/minimal/clefnecklightsmall.png',
          smallImagePathDark: 'assets/minimal/clefnecksmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Starry Heart',
          prompt:
              'A minimalist fine-line inner-forearm tattoo featuring a medium outlined heart with tiny dotted details inside, surrounded by small stars and solid dots. Done in clean black micro-tattoo style, it\'s photographed on realistic skin in soft outdoor light, with a white sleeve, light blue jeans, and a subtle bracelet visible against a softly blurred street background.',
          bigImagePath: 'assets/minimal/staryyheartbig.png',
          smallImagePath: 'assets/minimal/staryyheartsmalllight.png',
          smallImagePathDark: 'assets/minimal/staryyheartsmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Valknut Triangle',
          prompt:
              'Photorealistic close-up of a hand near a jeans pocket with a small minimalist geometric Valknut-style tattoo made of three interlocking triangles in thin black ink. Visible skin texture and veins, black sleeve and silver ring, denim background, soft natural lighting, and shallow depth of field.',
          bigImagePath: 'assets/minimal/valknutbig.png',
          smallImagePath: 'assets/minimal/valknutsmalllight.png',
          smallImagePathDark: 'assets/minimal/valknutsmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Minimalist Mountain',
          prompt:
              'Ultra-realistic close-up of an inner wrist with a tiny fine-line mountain tattoo in clean black ink. Small minimalist design centered on the wrist, visible skin texture and veins, sleeve slightly rolled up, soft natural lighting, neutral background, and shallow depth of field.',
          bigImagePath: 'assets/minimal/mountainbig.png',
          smallImagePath: 'assets/minimal/mountainsmalllight.png',
          smallImagePathDark: 'assets/minimal/mountainsmalldark.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'traditional',
      title: 'Traditional & Old School',
      prompt:
          'Bold lines, vibrant colors, and classic American traditional style.',
      bigImagePath: 'assets/explore/traditional_big.png',
      smallImagePath: 'assets/explore/traditional_small.png',
      items: [
        ExploreCategoryItem(
          title: 'Classic Anchor',
          prompt:
              'Traditional American style anchor with bold lines and vibrant colors',
          bigImagePath: 'assets/explore/traditional_big.png',
          smallImagePath: 'assets/explore/traditional_small.png',
        ),
        ExploreCategoryItem(
          title: 'Old School Rose',
          prompt: 'Vintage rose tattoo with traditional bold outlines',
          bigImagePath: 'assets/explore/traditional_big.png',
          smallImagePath: 'assets/explore/traditional_small.png',
        ),
        ExploreCategoryItem(
          title: 'Sailor Swallow',
          prompt: 'Classic swallow bird in traditional American style',
          bigImagePath: 'assets/explore/traditional_big.png',
          smallImagePath: 'assets/explore/traditional_small.png',
        ),
        ExploreCategoryItem(
          title: 'Pin-Up Girl',
          prompt: 'Vintage pin-up girl with bold colors',
          bigImagePath: 'assets/explore/traditional_big.png',
          smallImagePath: 'assets/explore/traditional_small.png',
        ),
        ExploreCategoryItem(
          title: 'Dagger & Snake',
          prompt: 'Traditional dagger with snake wrapped around it',
          bigImagePath: 'assets/explore/traditional_big.png',
          smallImagePath: 'assets/explore/traditional_small.png',
        ),
        ExploreCategoryItem(
          title: 'Eagle Head',
          prompt: 'Bold American eagle head in traditional style',
          bigImagePath: 'assets/explore/traditional_big.png',
          smallImagePath: 'assets/explore/traditional_small.png',
        ),
        ExploreCategoryItem(
          title: 'Nautical Star',
          prompt: 'Classic nautical star with bold outlines',
          bigImagePath: 'assets/explore/traditional_big.png',
          smallImagePath: 'assets/explore/traditional_small.png',
        ),
        ExploreCategoryItem(
          title: 'Lucky Horseshoe',
          prompt: 'Traditional horseshoe with vintage styling',
          bigImagePath: 'assets/explore/traditional_big.png',
          smallImagePath: 'assets/explore/traditional_small.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'japanese',
      title: 'Japanese Style',
      prompt:
          'Traditional Japanese irezumi with dragons, koi fish, and cherry blossoms.',
      bigImagePath: 'assets/japanese/koi_fish.png',
      smallImagePath: 'assets/japanese/koi_fish.png',
      items: [
        ExploreCategoryItem(
          title: 'Koi Fish',
          prompt:
              'Japanese style koi fish tattoo, traditional irezumi design, flowing koi with curved body, bold outlines, red orange palette, water waves around fish, clean vector look, centered composition, transparent background PNG, high resolution.',
          bigImagePath: 'assets/japanese/koi_fish.png',
          smallImagePath: 'assets/japanese/koi_fish.png',
        ),
        ExploreCategoryItem(
          title: 'Hannya Mask',
          prompt:
              'Japanese hannya mask tattoo, traditional irezumi style, demon mask with horns, bold black outlines, red and white tones, dramatic expression, clean vector style, centered composition, transparent background PNG, high resolution.',
          bigImagePath: 'assets/japanese/hannyamask.png',
          smallImagePath: 'assets/japanese/hannyamask.png',
        ),
        ExploreCategoryItem(
          title: 'Samurai Helmet',
          prompt:
              'Japanese samurai helmet tattoo, kabuto helmet front view, traditional irezumi style, bold outlines, gold and red accents, clean vector look, centered composition, transparent background PNG, high resolution.',
          bigImagePath: 'assets/japanese/samuraihelmet.png',
          smallImagePath: 'assets/japanese/samuraihelmet.png',
        ),
        ExploreCategoryItem(
          title: 'Cherry Blossom Branch',
          prompt:
              'Japanese cherry blossom tattoo, sakura branch with flowers, traditional irezumi style, soft pink blossoms, bold outlines, elegant composition, centered design, transparent background PNG, high resolution.',
          bigImagePath: 'assets/japanese/cherryblossombranch.png',
          smallImagePath: 'assets/japanese/cherryblossombranch.png',
        ),
        ExploreCategoryItem(
          title: 'Japanese Dragon',
          prompt:
              'Japanese dragon tattoo, traditional irezumi dragon, long flowing body, clouds around dragon, bold outlines, green red palette, dynamic pose, centered composition, transparent background PNG, high resolution.',
          bigImagePath: 'assets/japanese/japanesedragon.png',
          smallImagePath: 'assets/japanese/japanesedragon.png',
        ),
        ExploreCategoryItem(
          title: 'Oni Mask',
          prompt:
              'Japanese oni mask tattoo, traditional demon mask, bold outlines, red and black palette, fierce expression, irezumi style, centered composition, transparent background PNG, high resolution.',
          bigImagePath: 'assets/japanese/onimask.png',
          smallImagePath: 'assets/japanese/onimask.png',
        ),
        ExploreCategoryItem(
          title: 'Wave (Hokusai Style)',
          prompt:
              'Japanese wave tattoo, traditional irezumi ocean wave, bold outlines, blue tones, classic Japanese wave style, clean vector look, centered composition, transparent background PNG, high resolution.',
          bigImagePath: 'assets/japanese/wave.png',
          smallImagePath: 'assets/japanese/wave.png',
        ),
        ExploreCategoryItem(
          title: 'Tiger',
          prompt:
              'Japanese tiger tattoo, traditional irezumi tiger, roaring tiger head, bold outlines, orange black palette, dynamic style, centered composition, transparent background PNG, high resolution.',
          bigImagePath: 'assets/japanese/tiger.png',
          smallImagePath: 'assets/japanese/tiger.png',
        ),
        ExploreCategoryItem(
          title: 'Lotus Flower',
          prompt:
              'Japanese lotus tattoo, traditional irezumi lotus flower, bold outlines, pink and red tones, water elements, clean vector look, centered composition, transparent background PNG, high resolution.',
          bigImagePath: 'assets/japanese/lotus.png',
          smallImagePath: 'assets/japanese/lotus.png',
        ),
        ExploreCategoryItem(
          title: 'Phoenix',
          prompt:
              'Japanese phoenix tattoo, traditional irezumi phoenix bird, wings spread, bold outlines, red orange yellow palette, flames around bird, centered composition, transparent background PNG, high resolution.',
          bigImagePath: 'assets/japanese/phoenix.png',
          smallImagePath: 'assets/japanese/phoenix.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'tribal',
      title: 'Tribal Designs',
      prompt: 'Bold black patterns inspired by Polynesian and tribal art.',
      bigImagePath: 'assets/explore/tribal_big.png',
      smallImagePath: 'assets/explore/tribal_small.png',
      items: [
        ExploreCategoryItem(
          title: 'Polynesian Band',
          prompt: 'Tribal armband with traditional Polynesian patterns',
          bigImagePath: 'assets/explore/tribal_big.png',
          smallImagePath: 'assets/explore/tribal_small.png',
        ),
        ExploreCategoryItem(
          title: 'Maori Design',
          prompt: 'Intricate Maori tribal pattern with symbolic meaning',
          bigImagePath: 'assets/explore/tribal_big.png',
          smallImagePath: 'assets/explore/tribal_small.png',
        ),
        ExploreCategoryItem(
          title: 'Samoan Sleeve',
          prompt: 'Traditional Samoan tribal sleeve design',
          bigImagePath: 'assets/explore/tribal_big.png',
          smallImagePath: 'assets/explore/tribal_small.png',
        ),
        ExploreCategoryItem(
          title: 'Aztec Symbol',
          prompt: 'Ancient Aztec tribal symbol with bold lines',
          bigImagePath: 'assets/explore/tribal_big.png',
          smallImagePath: 'assets/explore/tribal_small.png',
        ),
        ExploreCategoryItem(
          title: 'Celtic Knot',
          prompt: 'Intricate Celtic knot work in tribal style',
          bigImagePath: 'assets/explore/tribal_big.png',
          smallImagePath: 'assets/explore/tribal_small.png',
        ),
        ExploreCategoryItem(
          title: 'Tribal Sun',
          prompt: 'Bold tribal sun with radiating patterns',
          bigImagePath: 'assets/explore/tribal_big.png',
          smallImagePath: 'assets/explore/tribal_small.png',
        ),
        ExploreCategoryItem(
          title: 'Warrior Mask',
          prompt: 'Tribal warrior mask with fierce expression',
          bigImagePath: 'assets/explore/tribal_big.png',
          smallImagePath: 'assets/explore/tribal_small.png',
        ),
        ExploreCategoryItem(
          title: 'Spearhead Pattern',
          prompt: 'Traditional spearhead tribal pattern',
          bigImagePath: 'assets/explore/tribal_big.png',
          smallImagePath: 'assets/explore/tribal_small.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'geometric',
      title: 'Geometric Tattoos',
      prompt: 'Sacred geometry, mandalas, and precise geometric patterns.',
      bigImagePath: 'assets/geometrical/mindbodybig.png',
      smallImagePath: 'assets/geometrical/mindbodysmalllight.png',
      smallImagePathDark: 'assets/geometrical/mindbodysmalldark.png',
      items: [
        ExploreCategoryItem(
          title: 'Mind–Body–Soul',
          prompt:
              'Highly detailed black-and-grey sacred geometry forearm tattoo with a vertical design: a brain transforming into a tree at the top, a meditating figure within geometric mandala shapes in the center, and an anatomical heart with ornamental elements at the bottom. Clean linework, dotwork shading, high contrast, and photorealistic studio presentation.',
          bigImagePath: 'assets/geometrical/mindbodybig.png',
          smallImagePath: 'assets/geometrical/mindbodysmalllight.png',
          smallImagePathDark: 'assets/geometrical/mindbodysmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Geometric Blackout Honeycomb Sleeve',
          prompt:
              'Ultra-realistic studio photo of a shirtless athletic man showing a full black geometric sleeve tattoo, with a honeycomb hexagon pattern on the shoulder and sacred-geometry mandala designs down the arm. Clean high-contrast ink, natural skin texture, neutral background, soft lighting, and shallow depth of field.',
          bigImagePath: 'assets/geometrical/honeycombbig.png',
          smallImagePath: 'assets/geometrical/honeycomblightsmall.png',
          smallImagePathDark: 'assets/geometrical/honeycombsmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Geometric + Illustrative Blackwork',
          prompt:
              'Ultra-realistic photo of a shirtless man with a black-and-grey geometric shoulder and upper-arm tattoo featuring honeycomb hexagons containing detailed forest and mountain scenes. High-contrast ink with shading and dotwork, natural skin texture, soft studio lighting, neutral background, and shallow depth of field.',
          bigImagePath: 'assets/geometrical/blackworkbig.png',
          smallImagePath: 'assets/geometrical/blackworksmalllight.png',
          smallImagePathDark: 'assets/geometrical/blackworksmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Geometric Cube Sleeve',
          prompt:
              'Ultra-realistic photo of an extended male forearm with a geometric blackwork tattoo featuring 3D cube and hexagon optical-illusion patterns, fading into a solid black wrist band. Precise linework, high-contrast ink, visible skin texture and veins, neutral studio background, soft lighting, and shallow depth of field.',
          bigImagePath: 'assets/geometrical/cubesleevebig.png',
          smallImagePath: 'assets/geometrical/cubesleevesmallight.png',
          smallImagePathDark: 'assets/geometrical/cubesleevesmalldark.png',
        ),
        ExploreCategoryItem(
          title: '3D Cube Geometric Sleeve',
          prompt:
              'Ultra-realistic photo of a forearm with a full geometric blackwork sleeve featuring interlocking 3D cube optical-illusion patterns that transition into a dense sacred-geometry star design near the wrist. High-contrast ink, clean sharp linework, dotwork shading, white rolled-up shirt, soft studio lighting, and shallow depth of field.',
          bigImagePath: 'assets/geometrical/geometricsleevebig.png',
          smallImagePath: 'assets/geometrical/geometricsleevesmalllight.png',
          smallImagePathDark: 'assets/geometrical/geometricsleevesmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Tree of Life',
          prompt:
              'Ultra-realistic vertical photo of an inner forearm with a black-and-grey nature tattoo featuring a central pine tree, circular mountain landscape, crescent moons, and ornamental roots. Clean fine-line and blackwork style, smooth shading, natural skin texture, soft studio lighting, neutral background, and shallow depth of field.',
          bigImagePath: 'assets/geometrical/treeoflifebig.png',
          smallImagePath: 'assets/geometrical/treeoflifelight.png',
          smallImagePathDark: 'assets/geometrical/treeoflifesmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Atlas Bearing the World',
          prompt:
              'Black-and-grey fine-line and dotwork tattoo of Atlas kneeling and carrying a globe, rendered like a classical Renaissance sculpture with realistic anatomy and shading. The Earth shows continents and a geometric grid, with sacred-geometry patterns and a sun symbol above. Clean, high-contrast, stencil-ready vertical design for an upper-arm tattoo, ultra-detailed and minimalistic.',
          bigImagePath: 'assets/geometrical/atlasbig.png',
          smallImagePath: 'assets/geometrical/atlassmalllight.png',
          smallImagePathDark: 'assets/geometrical/atlassmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Triad of Travel',
          prompt:
              'Minimalist blackwork forearm tattoo in fine-line and dotwork style, featuring a compass rose with geometric orbit lines, a small airplane on a dotted path, mountains, and an ocean wave, all arranged inside an inverted triangle frame with symmetrical sacred-geometry accents. Clean, high-contrast, stencil-ready vertical design with modern travel theme and ultra-detailed linework.',
          bigImagePath: 'assets/geometrical/triadbig.png',
          smallImagePath: 'assets/geometrical/triadsmalllight.png',
          smallImagePathDark: 'assets/geometrical/triadsmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Cycle of Horizons',
          prompt:
              'Minimalist geometric forearm tattoo in fine-line blackwork and dotwork, featuring a vertical column of connected hexagons. The top shows sun and sky, the center a mountain landscape with trees, and the bottom an ocean wave, with smaller surrounding hexagons and sacred-geometry accents linked by thin lines and dotted paths. Clean, symmetrical, high-contrast, stencil-ready nature-themed design.',
          bigImagePath: 'assets/geometrical/horizonsbig.png',
          smallImagePath: 'assets/geometrical/horizonssmalllight.png',
          smallImagePathDark: 'assets/geometrical/horizonssmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Aligned Triad',
          prompt:
              'Tiny minimalist finger tattoo in fine-line blackwork, featuring an abstract vertical triangle composition with layered geometric shapes, small diamond and polygon details, and subtle dotwork shading. Modern sacred-geometry style with thin precise lines, clean ornamental accents, and a stencil-ready professional look.',
          bigImagePath: 'assets/geometrical/alignedtriadbig.png',
          smallImagePath: 'assets/geometrical/alignedtriadsmalllight.png',
          smallImagePathDark: 'assets/geometrical/alignedsmalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Abstract Geometric Sigi',
          prompt:
              'Ultra-minimalist geometric finger tattoo in fine-line black ink, featuring a small vertical symbol of overlapping triangles, diamonds, and sharp polygon shapes with subtle dotwork shading and clean negative space. Modern sacred-geometry style with precise thin lines, high-contrast blackwork, and a stencil-ready professional design.',
          bigImagePath: 'assets/geometrical/sigibig.png',
          smallImagePath: 'assets/geometrical/sigismalllight.png',
          smallImagePathDark: 'assets/geometrical/sigismalldark.png',
        ),
        ExploreCategoryItem(
          title: 'Duality Nature Geometry',
          prompt:
              'Minimalist blackwork forearm tattoo in fine-line and dotwork style, featuring two stacked triangles: the top with a mountain scene and rising sun or moon, and the bottom inverted with a large ocean wave. Clean geometric framing, subtle sacred-geometry accents, and dotted motion lines create a balanced, modern nature-themed design that\'s high-contrast, ultra-detailed, and stencil-ready.',
          bigImagePath: 'assets/geometrical/dualitynaturebig.png',
          smallImagePath: 'assets/geometrical/dualitynaturesmalllight.png',
          smallImagePathDark: 'assets/geometrical/dualitynaturesmalldark.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'realism',
      title: 'Realism & Portrait',
      prompt: 'Photorealistic portraits and detailed realistic imagery.',
      bigImagePath: 'assets/realism_and_portrait/gambler_big.png',
      smallImagePath: 'assets/realism_and_portrait/gambler_small.png',
      items: [
        ExploreCategoryItem(
          title: 'Gambler in a Fedora',
          prompt:
              'Black & grey realistic tattoo of a faceless gambler in a fedora and suit, head down, arms crossed. Vintage street lamp behind, aces cards fanned out, light smoke on one side, two dice at the bottom. Noir mood, high-contrast shading, fine linework, detailed stippling, clean stencil style, centered symmetrical composition, monochrome, tattoo flash.',
          bigImagePath: 'assets/realism_and_portrait/gambler_big.png',
          smallImagePath: 'assets/realism_and_portrait/gambler_small.png',
        ),
        ExploreCategoryItem(
          title: 'Mind Over Heart',
          prompt:
              'Black & grey surreal tattoo of a realistic human brain acting like a puppeteer, with detailed hands controlling strings attached to an anatomical heart below. Fine linework, stippling and cross-hatching shading, high contrast, dark symbolic concept (mind controlling heart). Centered vertical composition, minimal background, tattoo stencil style, monochrome, highly detailed, professional tattoo flash.',
          bigImagePath: 'assets/realism_and_portrait/mindoverheartbig.png',
          smallImagePath: 'assets/realism_and_portrait/mindoverheartsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Geometric Split Portrait',
          prompt:
              'Stylized neo-modern tattoo of a female face split into geometric shards. One side realistic black-and-grey portrait, the other side vibrant color with pink hair and a bright blue eye. Sharp abstract shapes cutting through the face, bold clean linework, high contrast shading, minimal background. Neo-traditional / cyber-graphic tattoo style, centered vertical composition, tattoo stencil ready, highly detailed, modern flash design.',
          bigImagePath: 'assets/realism_and_portrait/geometricsplit_big.png',
          smallImagePath:
              'assets/realism_and_portrait/geometricsplit_small.png',
        ),
        ExploreCategoryItem(
          title: 'Fiery and Cosmic Split',
          prompt:
              'Surreal color tattoo of a female portrait with a split reality concept. One side warm tones with cracked skin texture, the other side cool blue cosmic tones. A magnifying glass over one eye revealing a glowing blue iris and abstract liquid details. Vintage pocket watch/clock at the bottom symbolizing time, subtle galaxy elements in the background. Highly detailed neo-surreal style, vibrant color contrast (orange vs blue), smooth gradients, bold clean linework, centered vertical composition, minimal background, modern tattoo flash design, stencil-ready.',
          bigImagePath:
              'assets/realism_and_portrait/fiery andcosmicsplit_large.png',
          smallImagePath:
              'assets/realism_and_portrait/fiery andcosmicsplit_small.png',
        ),
        ExploreCategoryItem(
          title: 'Sinister Clown Portrait',
          prompt:
              'Dark gothic clown-style female face tattoo with sharp black makeup lines, dramatic eyeliner and dripping eye accents, glowing orange eyes, small star symbol on forehead. Smooth black and grey shading with subtle color in the eyes only, high contrast, fine linework and stippling, clean edges, centered vertical tattoo design. Isolated tattoo artwork only on plain white background, no arm or skin, stencil-ready, professional tattoo flash style.',
          bigImagePath:
              'assets/realism_and_portrait/sinister _clown_portrait_large.png',
          smallImagePath:
              'assets/realism_and_portrait/sinister _clown_portrait_small.png',
        ),
        ExploreCategoryItem(
          title: 'Butterfly and Woman',
          prompt:
              'Black & grey tattoo design of a realistic female side profile blended with large detailed butterfly wings emerging from her head. Soft feminine facial features, smooth shading, fine linework, high contrast, delicate wing patterns with stippling and gradient shading. Elegant, surreal composition, centered vertical layout, minimal background, monochrome, clean stencil-ready tattoo flash style, highly detailed.',
          bigImagePath:
              'assets/realism_and_portrait/butterflyandwoman_large.png',
          smallImagePath:
              'assets/realism_and_portrait/butterflyandwoman_small.png',
        ),
        ExploreCategoryItem(
          title: 'Flaming Skull',
          prompt:
              'Fiery skull tattoo design with a realistic human skull engulfed in dynamic flames. Intense glowing fire inside the eye sockets and mouth, sharp teeth details, high contrast shading, bold clean linework. Realism + dark fantasy style, dramatic lighting, vibrant orange and red flames with black/grey skull tones. Centered vertical composition, isolated on white background, stencil-ready, highly detailed professional tattoo flash.',
          bigImagePath: 'assets/realism_and_portrait/flamingskull_large.png',
          smallImagePath: 'assets/realism_and_portrait/flamingskull_small.png',
        ),
        ExploreCategoryItem(
          title: 'Fierce Wolf',
          prompt:
              'Vibrant and colorful tattoo design featuring a fierce wolf\'s face with piercing blue eyes, surrounded by a winding snake. The snake wraps around the wolf\'s head, slithering towards a cluster of blooming orange flowers. The tattoo is adorned with soft watercolor splashes in pink, purple, and blue hues, with a dripping paint effect. Rich detail in the fur, scales, and petals, high contrast between dark and light areas. Watercolor style with fine linework, modern nature and wildlife symbolism. Centered composition, vivid and dynamic, tattoo stencil-ready.',
          bigImagePath: 'assets/realism_and_portrait/fiercewolf_large.png',
          smallImagePath: 'assets/realism_and_portrait/fiercewolf_small .png',
        ),
        ExploreCategoryItem(
          title: 'Red Rose and Butterfly',
          prompt:
              'Elegant black and red tattoo design featuring a bold butterfly with dark wings, paired with a vivid red rose. The butterfly\'s wings have a smooth gradient from black to red, while the rose is deeply detailed with soft shading to enhance its petals. The design includes delicate red leaves and branches flowing outward, creating a balanced, flowing composition. The black ink contrasts sharply with the vibrant red, adding a dramatic, fluid appearance. Modern, clean linework with a slightly abstract touch. Tattoo stencil-ready with high contrast, perfect for an arm or thigh placement.',
          bigImagePath:
              'assets/realism_and_portrait/redrosebutterfly_large.png',
          smallImagePath:
              'assets/realism_and_portrait/redrosebutterfly_small.png',
        ),
        ExploreCategoryItem(
          title: 'Vibrant Peacock',
          prompt:
              'Vibrant and colorful tattoo design of a peacock with a bright yellow-orange sun in the background. The peacock\'s feathers display stunning shades of blue, green, and purple, while its body is elegantly shaded with turquoise and teal. Bold pink flowers and green leaves frame the design, with fine linework to accentuate the shapes and textures. Modern and stylized with clean, bold outlines and rich, vibrant colors. Ideal for a larger area, with no background distractions, creating a focal piece perfect for placement anywhere on the body.',
          bigImagePath: 'assets/realism_and_portrait/vibrant_peacock_large.png',
          smallImagePath:
              'assets/realism_and_portrait/vibrant_peacock_small.png',
        ),
        ExploreCategoryItem(
          title: 'Playful Character',
          prompt:
              'Cute, colorful tattoo design of a playful character holding a large pink flower. The character features large, expressive eyes, blue fur, and a light blue belly. The vibrant flower is framed by green leaves, adding a natural touch to the design. The style is bold and cartoonish with smooth shading, clean lines, and vibrant colors, giving the tattoo a joyful and whimsical look. The design is ideal for a smaller area of the body, with no background distractions, emphasizing the character and flower as the focal points.',
          bigImagePath: 'assets/realism_and_portrait/playful_character_big.png',
          smallImagePath:
              'assets/realism_and_portrait/playful_character_small.png',
        ),
        ExploreCategoryItem(
          title: 'Cute Pink Fish',
          prompt:
              'Playful and vibrant tattoo design of a cute pink fish with a smiling expression. The fish features soft gradients of pink, with smooth shading that creates a lively, cartoonish look. Water splashes in shades of blue and turquoise surround the fish, adding dynamic movement. Small bubbles and light accents enhance the aquatic theme. Modern, clean lines with a playful touch, perfect for a small area on the body. The tattoo design focuses on the fish and water, with no background distractions, and has a joyful, whimsical vibe.',
          bigImagePath: 'assets/realism_and_portrait/cute_pink_fish_large.png',
          smallImagePath:
              'assets/realism_and_portrait/cute_pink_fish_small.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'lettering',
      title: 'Lettering & Script',
      prompt: 'Beautiful typography, calligraphy, and meaningful quotes.',
      bigImagePath: 'assets/letters/trutnoonebig.png',
      smallImagePath: 'assets/letters/trustnoone_small.png',
      items: [
        ExploreCategoryItem(
          title: 'Trust No One',
          prompt:
              'Create a detailed gothic-style tattoo design with the phrase \'Trust no One\'. The text should be bold and dramatic, with sharp, angular edges. Add shading effects to give the text a three-dimensional look, and incorporate some ink splatter or shadow around the text for a gritty, intense vibe. The font should evoke a dark, mysterious atmosphere with an edgy, rebellious tone.',
          bigImagePath: 'assets/letters/trutnoonebig.png',
          smallImagePath: 'assets/letters/trustnoone_small.png',
        ),
        ExploreCategoryItem(
          title: 'Blessed',
          prompt:
              'High-contrast black and white graffiti tattoo design, word "Blessed" in bold hand-lettering calligraphy, smooth flowing script with thick strokes, subtle halo above letter, street-style spray paint glow around text, paint drips and ink splatter, clean vector lines, centered composition, stencil-ready tattoo flash, minimal background, sharp edges, professional tattoo design, black ink only.',
          bigImagePath: 'assets/letters/blessedbig.png',
          smallImagePath: 'assets/letters/blessedsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Hakuna Matata',
          prompt:
              'Bold black and white graffiti tattoo design with the words "Hakuna Matata", strong street-style block lettering, rough dry-brush strokes, high contrast ink, paint splatter and subtle drip details, urban graffiti wall aesthetic, thick clean outlines, centered composition, professional tattoo flash, stencil-ready, vector style, monochrome, white background, highly detailed, sharp edges.',
          bigImagePath: 'assets/letters/hakunamatatabig.png',
          smallImagePath: 'assets/letters/hakunamatatasmall.png',
        ),
        ExploreCategoryItem(
          title: 'Dream',
          prompt:
              'Vibrant graffiti tattoo design with the word "DREAM", bold 3D street lettering, thick black outlines, colorful paint splashes and ink drips, urban spray-paint style, high contrast, layered graffiti wall aesthetic, dynamic composition, clean sharp edges, professional tattoo flash, stencil-ready, highly detailed, vector style.',
          bigImagePath: 'assets/letters/dreambig.png',
          smallImagePath: 'assets/letters/dreamsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Boom',
          prompt:
              'Comic pop-art tattoo design with the word "BOOM", bold cartoon lettering, thick black outlines, vibrant pink and yellow colors, explosive comic burst background, glossy highlights, playful graffiti style, high contrast, clean smooth edges, centered composition, professional tattoo flash, stencil-ready, highly detailed vector style.',
          bigImagePath: 'assets/letters/boombig.png',
          smallImagePath: 'assets/letters/boomsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Work Hard Dream Big',
          prompt:
              'Bold colorful graffiti tattoo design with the phrase "Work Hard Dream Big", dynamic street lettering, 3D layered typography, thick black outlines, vibrant gradient colors (orange, red, yellow), paint drips and ink splatter, urban graffiti wall style, high contrast, glossy highlights, centered composition, professional tattoo flash, stencil-ready, highly detailed, vector style, clean background.',
          bigImagePath: 'assets/letters/workhardbig.png',
          smallImagePath: 'assets/letters/workhardsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Letter RN',
          prompt:
              'Dark gothic tattoo design, stylized monogram letters "RN", sharp aggressive calligraphy with horned and spiked edges, black ink only, high contrast, heavy shadowing, grunge ink splatter, ornamental gothic typography, symmetrical composition, tattoo flash style, clean stencil-ready lines, monochrome, white background, highly detailed, professional tattoo design.',
          bigImagePath: 'assets/letters/rnbig.png',
          smallImagePath: 'assets/letters/rnsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Letter C',
          prompt:
              'Dark gothic tattoo design featuring the letter "C" with a detailed royal crown on top, bold curved lettering with sharp edges, black and grey realism, high contrast shading, subtle ink splatter and drip effects, luxury gothic style, strong depth and shadow, centered composition, clean stencil-ready outlines, professional tattoo flash, monochrome, highly detailed vector tattoo style.',
          bigImagePath: 'assets/letters/cbig.png',
          smallImagePath: 'assets/letters/csmall.png',
        ),
        ExploreCategoryItem(
          title: 'Peace & Positivity',
          prompt:
              'Bold colorful graffiti tattoo design with the phrase "Peace & Positivity", dynamic street-style lettering, large 3D typography, thick black outlines, vibrant gradient colors (yellow, orange, blue, green), paint splashes and dripping ink, urban spray-paint graffiti aesthetic, high contrast, glossy highlights, centered composition, professional tattoo flash, stencil-ready, highly detailed vector style.',
          bigImagePath: 'assets/letters/peacebig.png',
          smallImagePath: 'assets/letters/peacesmall.png',
        ),
        ExploreCategoryItem(
          title: 'Dream Big',
          prompt:
              'Colorful dreamy tattoo design with the words "Dream Big", soft bubble calligraphy lettering, glossy 3D gradient colors (rainbow tones), smooth rounded strokes, cute celestial elements like stars, sparkles and glowing sun, vibrant fantasy aesthetic, high contrast, clean bold outlines, centered composition, professional tattoo flash, stencil-ready, highly detailed vector style.',
          bigImagePath: 'assets/letters/dreambig_big.png',
          smallImagePath: 'assets/letters/dreambig_small.png',
        ),
        ExploreCategoryItem(
          title: 'Desire',
          prompt:
              'Dark gothic tattoo design with the word "Desire", sharp aggressive black metal calligraphy, spiked thorn-like lettering, symmetrical composition, black and grey realism, metallic dark texture, high contrast shading, sinister ornamental details, clean stencil-ready outlines, professional tattoo flash, monochrome, ultra detailed, edgy gothic style.',
          bigImagePath: 'assets/letters/desirebig.png',
          smallImagePath: 'assets/letters/desiresmall.png',
        ),
        ExploreCategoryItem(
          title: 'Beautiful',
          prompt:
              'Stylish colorful tattoo design with the word "Beautiful", smooth flowing script lettering, bold modern calligraphy, glossy 3D gradient colors (pink, orange, yellow), thick black outline, soft highlights and depth, feminine elegant style, clean curves and swashes, centered composition, professional tattoo flash, stencil-ready, highly detailed vector style.',
          bigImagePath: 'assets/letters/beautifullarge.png',
          smallImagePath: 'assets/letters/beautifulsmall.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'floral',
      title: 'Floral & Nature',
      prompt:
          'Flowers, plants, and natural elements in beautiful compositions.',
      bigImagePath: 'assets/floral/Minimalistfourleafclover withheartbig.png',
      smallImagePath:
          'assets/floral/Minimalistfourleafclover withheartsmall.png',
      items: [
        ExploreCategoryItem(
          title: 'Minimalist Four-Leaf Clover',
          prompt:
              'Minimal fine-line four-leaf clover tattoo design, cute and delicate style, soft pastel green leaves with smooth gradient, thin black stem and clean outlines, small red heart detail inside one leaf, symmetrical composition, feminine minimalist tattoo flash, high contrast linework, subtle color fill, crisp vector-style edges, professional tattoo stencil design, centered composition.',
          bigImagePath:
              'assets/floral/Minimalist fourleafclover withheartbig.png',
          smallImagePath:
              'assets/floral/Minimalist fourleafclover withheartsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Cherry Blossom Branch',
          prompt:
              'Elegant cherry blossom branch tattoo design, fine-line botanical style, flowing sakura branch with multiple pink blossoms and small buds, gradient pink petals with delicate shading, thin black branch and clean outlines, subtle petal fall details, feminine composition, high-detail floral tattoo flash, balanced vertical layout, professional tattoo stencil design, minimal background, high contrast, centered composition.',
          bigImagePath: 'assets/floral/Cherryblossombranchbig.png',
          smallImagePath: 'assets/floral/Cherryblossombranchsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Mountain Landscape',
          prompt:
              'Minimal fine-line mountain landscape tattoo design, small centered composition, detailed mountain peaks with pine trees, flowing waterfall descending from the center, circular moon above the mountains, delicate dotwork shading and stippling, clean black ink linework, geometric balance, subtle texture, high contrast, professional tattoo flash style, crisp outlines, minimalist nature scene, transparent background.',
          bigImagePath: 'assets/floral/mountainlandscapebig.png',
          smallImagePath: 'assets/floral/mountainlandscapesmall.png',
        ),
        ExploreCategoryItem(
          title: 'Heart-Shaped Sunset',
          prompt:
              'Small heart-shaped sunset tattoo design, vibrant warm color palette, glowing orange and red sunset inside a clean heart outline, ocean horizon with soft reflections, painterly clouds with subtle splatter details, minimal black base shadow under the heart, fine-line and micro-realism style, smooth gradient color blending, high contrast, centered composition, professional tattoo flash design, crisp edges, no text, transparent background.',
          bigImagePath: 'assets/floral/Heartshaped sunsetbig.png',
          smallImagePath: 'assets/floral/Heartshaped sunsetsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Sea Turtle',
          prompt:
              'Vibrant geometric sea turtle tattoo design, two sea turtles swimming side by side, faceted crystal-style shells with rainbow prism colors, polygonal pattern texture, high-detail scales and flippers, glossy gemstone effect, bold saturation with deep blues, purples, greens and warm highlights, micro-realism meets geometric style, clean sharp outlines, subtle shadow under figures, high contrast, centered composition, professional tattoo flash design, isolated artwork, transparent background.',
          bigImagePath: 'assets/floral/seaturtlebig.png',
          smallImagePath: 'assets/floral/seaturtlesmall.png',
        ),
        ExploreCategoryItem(
          title: 'Hibiscus Flower',
          prompt:
              'Vibrant hibiscus flower tattoo design, bold tropical floral composition, large detailed hibiscus bloom with warm red, orange and yellow gradient petals, smooth color blending, clean black outlines, soft shading for depth, surrounding green leaves with fine vein detail, small decorative ink splatter dots, modern neo-traditional tattoo style, high contrast, centered composition, crisp edges, professional tattoo flash, isolated artwork, transparent background.',
          bigImagePath: 'assets/floral/Hibiscusflowerbig.png',
          smallImagePath: 'assets/floral/Hibiscusflowersmall.png',
        ),
        ExploreCategoryItem(
          title: 'Butterfly and Lily',
          prompt:
              'Realistic monarch butterfly and lily flower tattoo design, vibrant orange and black butterfly with detailed wing patterns, perched beside a large yellow lily bloom, smooth color gradients and soft realistic shading, crisp black outlines with subtle depth, rich green leaves with fine vein detail, neo-traditional realism style, high contrast colors, balanced composition, professional tattoo flash design, clean edges, isolated artwork, transparent background.',
          bigImagePath: 'assets/floral/butterflyandlilyflowersbig.png',
          smallImagePath: 'assets/floral/butterflyandlilyflowersmall.png',
        ),
        ExploreCategoryItem(
          title: 'Butterfly',
          prompt:
              'Realistic monarch butterfly tattoo design, vibrant orange wings with deep black borders and white dot accents, symmetrical open-wing pose, smooth gradient color blending, glossy highlights and soft shadow for depth, clean bold outlines, high-detail wing texture, neo-traditional realism style, high contrast, centered composition, professional tattoo flash, crisp edges, isolated artwork, transparent background.',
          bigImagePath: 'assets/floral/Butterfly_big.png',
          smallImagePath: 'assets/floral/Butterfly_small.png',
        ),
        ExploreCategoryItem(
          title: 'Hummingbird and Cherry Blossom',
          prompt:
              'Delicate hummingbird and cherry blossom tattoo design, fine-line realism style, small hummingbird in mid-flight with detailed feathers and soft shading, thin curved branch with pink cherry blossoms and tiny buds, elegant botanical composition, subtle color accents on flowers with mostly black ink bird, clean crisp outlines, micro-realism tattoo flash style, high detail, balanced composition, high contrast, professional tattoo design, isolated artwork, transparent background.',
          bigImagePath: 'assets/floral/Hummingbirdandcherryblossombig.png',
          smallImagePath: 'assets/floral/Hummingbirdandcherryblossomsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Butterfly Bracelet',
          prompt:
              'Elegant blue butterfly bracelet tattoo design, delicate chain-style composition wrapping in a flowing curve, two detailed blue butterflies with gradient wings and fine line texture, small star charms and tiny floral accents connected by thin ornamental chains, feminine micro-realism style, crisp black outlines with vibrant blue highlights, subtle dotwork details, light and airy composition, high contrast, professional tattoo flash design, centered and balanced layout, isolated artwork, transparent background.',
          bigImagePath: 'assets/floral/Butterflybraceletbig.png',
          smallImagePath: 'assets/floral/Butterflybraceletsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Baby Panda',
          prompt:
              'Cute baby panda tattoo design, sitting panda holding a small bamboo stick, soft rounded cartoon style with semi-realistic fur texture, gentle blush on cheeks, big expressive eyes and friendly smile, black and white panda with subtle grey shading, small bamboo leaves around the character, light watercolor splash background in pastel tones, clean bold outlines with soft shading, kawaii tattoo style, high contrast, centered composition, professional tattoo flash design, isolated artwork, transparent background.',
          bigImagePath: 'assets/floral/babypandabig.png',
          smallImagePath: 'assets/floral/babypandasmall.png',
        ),
        ExploreCategoryItem(
          title: 'Sun Moon',
          prompt:
              'Sun and crescent moon watercolor tattoo design, vibrant celestial composition, glowing orange sun with flowing rays surrounding a large crescent moon, moon filled with galaxy-style colors in blue, purple and pink, soft watercolor splashes and ink drips, delicate star details and sparkles, fine clean outlines with smooth color gradients, modern celestial tattoo style, high contrast, balanced centered composition, professional tattoo flash design, isolated artwork, transparent background.',
          bigImagePath: 'assets/floral/sunmoonbig.png',
          smallImagePath: 'assets/floral/sunmoonsmall.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'mythology',
      title: 'Mythology & Fantasy',
      prompt: 'Mythical creatures, gods, and fantasy-inspired designs.',
      bigImagePath: 'assets/myths/warriorandserpentsbig.png',
      smallImagePath: 'assets/myths/warriorandserpentsmall.png',
      items: [
        ExploreCategoryItem(
          title: 'Warrior and Serpents',
          prompt:
              'A muscular classical Greek statue-style male warrior wrapped tightly by multiple serpents, one snake coiling around torso and arms, another rising with open mouth, warrior holding a dagger downward in one hand, dramatic mythological struggle pose, inspired by ancient sculpture and renaissance engraving, highly detailed black ink tattoo design, fine line engraving style, cross-hatching shading, clean linework, centered vertical composition, high contrast, white background, parchment texture, realistic anatomy, dark fantasy tattoo flash, symmetrical balanced layout.',
          bigImagePath: 'assets/myths/warriorandserpentsbig.png',
          smallImagePath: 'assets/myths/warriorandserpentsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Phoenix Rising',
          prompt:
              'Vibrant phoenix tattoo design, wings fully spread upward, long flowing tail feathers, dynamic rising pose, fiery color palette with red, orange, yellow and hints of blue, ultra detailed feathers, clean bold outlines, modern neo-traditional tattoo style, high contrast, glowing ember effects, subtle ink splatter accents, symmetrical composition, sharp linework, rich gradient coloring, dramatic lighting, professional tattoo flash illustration, centered composition, plain background.',
          bigImagePath: 'assets/myths/phoenixrisingbig.png',
          smallImagePath: 'assets/myths/phoenixrisingsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Medusa',
          prompt:
              'Medusa inspired tattoo design, mysterious female face with multiple serpents coiling and intertwining through the hair, several snake heads facing different directions, one snake with open mouth and fangs visible, intense glowing eyes, cracked marble skin texture, mythological dark fantasy theme, ultra detailed scales and hair strands, bold clean linework, neo-traditional tattoo style, rich green and earthy tones, high contrast shading, smooth gradients, dramatic composition, centered tattoo flash illustration, sharp outlines, professional tattoo design.',
          bigImagePath: 'assets/myths/medusabig.png',
          smallImagePath: 'assets/myths/medusasmall.png',
        ),
        ExploreCategoryItem(
          title: 'Dragon Coiled Around Sword',
          prompt:
              'Dark fantasy dragon wrapped around an ornate medieval sword, dragon body coiling tightly along the blade, detailed scales and sharp claws, fierce dragon head with open mouth and visible fangs near the hilt, gothic engraved sword design, symmetrical vertical composition, black and grey tattoo style, ultra detailed linework, high contrast shading, fine line engraving technique, dramatic shadows, sharp clean outlines, fantasy tattoo flash, centered composition, minimal plain background, professional tattoo illustration.',
          bigImagePath: 'assets/myths/dragoncoiledlarge.png',
          smallImagePath: 'assets/myths/dragoncoiledsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Three-Headed Hydra',
          prompt:
              'Three-headed hydra dragon tattoo design, massive serpentine dragon body with three fierce dragon heads emerging from one neck, mouths open with sharp fangs, aggressive expressions, overlapping scales and armored plates, dark fantasy creature, ultra detailed black and grey tattoo style, heavy shading, high contrast lighting, intricate scale texture, sharp horns and spikes, smoke drifting from mouths, dramatic vertical composition, clean bold outlines, professional tattoo flash illustration, centered composition.',
          bigImagePath: 'assets/myths/hydrabig.png',
          smallImagePath: 'assets/myths/hydrasmall.png',
        ),
        ExploreCategoryItem(
          title: 'Octopus',
          prompt:
              'Detailed octopus tattoo design, large octopus with curling tentacles spreading outward in a balanced composition, tentacles twisting and overlapping with visible suction cups, intense eyes and textured head, dark ocean creature theme, black and grey tattoo style, ultra fine linework, engraving and dotwork shading, high contrast shadows, realistic texture, symmetrical centered layout, bold clean outlines, professional tattoo flash illustration.',
          bigImagePath: 'assets/myths/octopusbig.png',
          smallImagePath: 'assets/myths/octopussmall.png',
        ),
        ExploreCategoryItem(
          title: 'Japanese Style Dragon',
          prompt:
              'Japanese style dragon tattoo design, powerful eastern dragon with long serpentine body coiling in an S-shaped composition, detailed layered scales, sharp horns and whiskers, fierce open mouth with fangs, claws extended, flowing mane and tail, surrounded by stylized clouds and flame elements, vibrant red, orange and gold color palette, bold clean outlines, neo-traditional japanese tattoo style, smooth gradient shading, high contrast, dynamic movement, professional tattoo flash illustration.',
          bigImagePath: 'assets/myths/japanesedragonbig.png',
          smallImagePath: 'assets/myths/japanesedragonsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Dark Fantasy Eye',
          prompt:
              'Dark fantasy tattoo design featuring a central eye surrounded by multiple smaller eyes, all radiating a glowing red energy, large detailed wings extending from the center, with sharp feather tips and deep shadows, veins of red lightning running through the design, high contrast black and grey shading with fiery accents, intricate and symmetrical composition, modern gothic style, fine line detailing, powerful and intense mystical theme, dramatic atmosphere, professional tattoo flash illustration, minimal background with focus on the design.',
          bigImagePath: 'assets/myths/darkfantasyeyesbig.png',
          smallImagePath: 'assets/myths/darkfantasyeyesmall.png',
        ),
        ExploreCategoryItem(
          title: 'Mermaid',
          prompt:
              'Vibrant, horror-themed mermaid tattoo design, grotesque mermaid with a skeletal, gnarled face, long wild hair in dark shades of black and deep purple, sharp claws, and twisted, muscular body, transitioning from human form to a fish tail with iridescent scales in shades of teal, blue, and green, eerie underwater creature vibe with glowing elements, fiery orange and red highlights on the tail and eyes, dramatic shading with contrasting dark tones, high detail, horror fantasy tattoo style with rich colors, professional flash tattoo, clean bold outlines, vivid contrasts.',
          bigImagePath: 'assets/myths/mermaidbig.png',
          smallImagePath: 'assets/myths/mermaidsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Dynamic Dragon',
          prompt:
              'Vibrant and dynamic dragon tattoo design, serpent-like body with smooth scales transitioning from deep green to teal, fiery orange and golden wings stretching outward, feathered wings with a gradient of warm tones from orange to light yellow, sleek sinuous tail with fiery accents, detailed head with sharp features and subtle horns, dragon exuding energy and motion, dramatic shading to highlight the curves and texture of the body, fantasy style with vivid color palette, high contrast, professional tattoo illustration with clean bold outlines.',
          bigImagePath: 'assets/myths/dynamicdragonbig.png',
          smallImagePath: 'assets/myths/dynamicdragonsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Trident',
          prompt:
              'Gothic trident tattoo design with sharp, intricate details, the trident head adorned with dark, thorn-like spines and elegant curves, a serpent wrapping around the trident shaft, the body of the serpent with smooth scales and subtle shading, floral vine elements twisting around the trident, delicate yet powerful, dark and eerie black and grey shading with high contrast, dramatic shadow play, sharp outlines, and fine detail, professional tattoo flash, minimal background with focus on the weapon and serpent, symmetrical design.',
          bigImagePath: 'assets/myths/tridentbig.png',
          smallImagePath: 'assets/myths/tridentsmall.png',
        ),
        ExploreCategoryItem(
          title: 'Warrior',
          prompt:
              'Powerful fantasy warrior tattoo design, dragon-like figure with scales covering the face and neck, glowing blue eyes, long, detailed beard and sharp features, fiery orange and blue flame accents swirling around the character, sharp spiked armor and fins protruding from the back, holding a trident in one hand, dramatic shading with high contrast, detailed textures on the skin and weapon, vivid colors of fire and ice, strong mythical atmosphere, bold clean outlines, professional tattoo flash illustration, minimal background with focus on the character and flames.',
          bigImagePath: 'assets/myths/warriorbig.png',
          smallImagePath: 'assets/myths/warriorsmall.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'custom_ai',
      title: 'Custom AI Designs',
      prompt: 'Unique AI-generated designs combining multiple styles.',
      bigImagePath: 'assets/minimal/pandabig.png',
      smallImagePath: 'assets/minimal/pandasmalllight.png',
      smallImagePathDark: 'assets/minimal/pandamalldark.png',
      items: [
        // Random item 1: From Minimal
        ExploreCategoryItem(
          title: 'Minimalist Panda',
          prompt:
              'A tiny minimalist ankle tattoo of a cute panda sitting upright, facing slightly right, drawn with clean black lines and soft micro-shading. The panda holds a thin green stem with small purple lavender flowers, with subtle botanical detail and glossy black ears and arms. The design is centered on ankle skin, photographed in natural light with shallow depth of field and a minimal, professional tattoo reference style in a 1:1 composition.',
          bigImagePath: 'assets/minimal/pandabig.png',
          smallImagePath: 'assets/minimal/pandasmalllight.png',
          smallImagePathDark: 'assets/minimal/pandamalldark.png',
        ),
        // Random item 2: From Geometric
        ExploreCategoryItem(
          title: 'Tree of Life',
          prompt:
              'Ultra-realistic vertical photo of an inner forearm with a black-and-grey nature tattoo featuring a central pine tree, circular mountain landscape, crescent moons, and ornamental roots. Clean fine-line and blackwork style, smooth shading, natural skin texture, soft studio lighting, neutral background, and shallow depth of field.',
          bigImagePath: 'assets/geometrical/treeoflifebig.png',
          smallImagePath: 'assets/geometrical/treeoflifelight.png',
          smallImagePathDark: 'assets/geometrical/treeoflifesmalldark.png',
        ),
        // Random item 3: From Realism
        ExploreCategoryItem(
          title: 'Realistic Lion Portrait',
          prompt:
              'Ultra-realistic black-and-grey lion head tattoo with detailed fur texture, intense eyes, and powerful expression. Photorealistic shading, high contrast, and fine detail work.',
          bigImagePath: 'assets/realism_and_portrait/lionbig.png',
          smallImagePath: 'assets/realism_and_portrait/lionsmall.png',
        ),
        // Random item 4: From Lettering
        ExploreCategoryItem(
          title: 'Elegant Script Quote',
          prompt:
              'Beautiful flowing script lettering with elegant curves and flourishes. Delicate line work with ornamental details and perfect spacing.',
          bigImagePath: 'assets/letters/scriptbig.png',
          smallImagePath: 'assets/letters/scriptsmall.png',
        ),
        // Random item 5: From Floral
        ExploreCategoryItem(
          title: 'Delicate Rose',
          prompt:
              'Detailed rose tattoo with soft petals, natural shading, and botanical accuracy. Fine line work with realistic depth and texture.',
          bigImagePath: 'assets/floral/rosebig.png',
          smallImagePath: 'assets/floral/rosesmall.png',
        ),
        // Random item 6: From Japanese
        ExploreCategoryItem(
          title: 'Koi Fish',
          prompt:
              'Traditional Japanese koi fish with flowing water, cherry blossoms, and wave patterns. Bold colors and classic irezumi style.',
          bigImagePath: 'assets/japanese/koibig.png',
          smallImagePath: 'assets/japanese/koismall.png',
        ),
        // Random item 7: From Mythology
        ExploreCategoryItem(
          title: 'Phoenix Rising',
          prompt:
              'Majestic phoenix bird rising from flames, wings spread wide with detailed feathers, surrounded by fire and smoke. Powerful mythological creature in black and grey with dramatic shading.',
          bigImagePath: 'assets/myths/phoenixbig.png',
          smallImagePath: 'assets/myths/phoenixsmall.png',
        ),
        // Random item 8: From Traditional
        ExploreCategoryItem(
          title: 'Traditional Anchor',
          prompt:
              'Classic American traditional anchor with bold lines, vibrant colors, and nautical theme. Old school tattoo style with clean outlines.',
          bigImagePath: 'assets/explore/traditional_big.png',
          smallImagePath: 'assets/explore/traditional_small.png',
        ),
        // Random item 9: From Tribal
        ExploreCategoryItem(
          title: 'Tribal Pattern',
          prompt:
              'Bold tribal design with thick black lines and traditional Polynesian patterns. Strong geometric shapes with cultural significance.',
          bigImagePath: 'assets/explore/tribal_big.png',
          smallImagePath: 'assets/explore/tribal_small.png',
        ),
      ],
    ),
  ];
}
