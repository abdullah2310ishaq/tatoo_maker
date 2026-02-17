class ExploreCategory {
  final String id;
  final String title;
  final String prompt;
  final String bigImagePath;
  final String? smallImagePath;
  final List<ExploreCategoryItem> items;

  const ExploreCategory({
    required this.id,
    required this.title,
    required this.prompt,
    required this.bigImagePath,
    this.smallImagePath,
    required this.items,
  });
}

class ExploreCategoryItem {
  final String title;
  final String prompt;
  final String bigImagePath;
  final String? smallImagePath;

  const ExploreCategoryItem({
    required this.title,
    required this.prompt,
    required this.bigImagePath,
    this.smallImagePath,
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
      bigImagePath: 'assets/explore/minimal_big.png',
      smallImagePath: 'assets/explore/minimal_small.png',
      items: [
        ExploreCategoryItem(
          title: 'Minimal Line Art',
          prompt:
              'Create a minimalist tattoo with simple, clean lines and geometric shapes',
          bigImagePath: 'assets/explore/minimal_big.png',
          smallImagePath: 'assets/explore/minimal_small.png',
        ),
        ExploreCategoryItem(
          title: 'Tiny Symbols',
          prompt: 'Design a small, meaningful symbol with minimal detail',
          bigImagePath: 'assets/explore/minimal_big.png',
          smallImagePath: 'assets/explore/minimal_small.png',
        ),
        ExploreCategoryItem(
          title: 'Simple Wave',
          prompt: 'Minimalist wave design with flowing single line',
          bigImagePath: 'assets/explore/minimal_big.png',
          smallImagePath: 'assets/explore/minimal_small.png',
        ),
        ExploreCategoryItem(
          title: 'Dot Work',
          prompt: 'Delicate dotwork pattern in minimalist style',
          bigImagePath: 'assets/explore/minimal_big.png',
          smallImagePath: 'assets/explore/minimal_small.png',
        ),
        ExploreCategoryItem(
          title: 'Abstract Shape',
          prompt: 'Simple abstract geometric shape with clean edges',
          bigImagePath: 'assets/explore/minimal_big.png',
          smallImagePath: 'assets/explore/minimal_small.png',
        ),
        ExploreCategoryItem(
          title: 'Thin Arrow',
          prompt: 'Minimalist arrow with fine line work',
          bigImagePath: 'assets/explore/minimal_big.png',
          smallImagePath: 'assets/explore/minimal_small.png',
        ),
        ExploreCategoryItem(
          title: 'Small Heart',
          prompt: 'Tiny heart outline with minimal design',
          bigImagePath: 'assets/explore/minimal_big.png',
          smallImagePath: 'assets/explore/minimal_small.png',
        ),
        ExploreCategoryItem(
          title: 'Mountain Line',
          prompt: 'Simple mountain range in single line style',
          bigImagePath: 'assets/explore/minimal_big.png',
          smallImagePath: 'assets/explore/minimal_small.png',
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
      bigImagePath: 'assets/explore/geometric_big.png',
      smallImagePath: 'assets/explore/geometric_small.png',
      items: [
        ExploreCategoryItem(
          title: 'Mandala Circle',
          prompt:
              'Intricate mandala with perfect symmetry and geometric patterns',
          bigImagePath: 'assets/explore/geometric_big.png',
          smallImagePath: 'assets/explore/geometric_small.png',
        ),
        ExploreCategoryItem(
          title: 'Sacred Geometry',
          prompt: 'Flower of life and sacred geometric shapes',
          bigImagePath: 'assets/explore/geometric_big.png',
          smallImagePath: 'assets/explore/geometric_small.png',
        ),
        ExploreCategoryItem(
          title: 'Hexagon Pattern',
          prompt: 'Interconnected hexagons in geometric arrangement',
          bigImagePath: 'assets/explore/geometric_big.png',
          smallImagePath: 'assets/explore/geometric_small.png',
        ),
        ExploreCategoryItem(
          title: 'Triangle Design',
          prompt: 'Overlapping triangles with precise angles',
          bigImagePath: 'assets/explore/geometric_big.png',
          smallImagePath: 'assets/explore/geometric_small.png',
        ),
        ExploreCategoryItem(
          title: 'Dotwork Mandala',
          prompt: 'Geometric mandala created with dotwork technique',
          bigImagePath: 'assets/explore/geometric_big.png',
          smallImagePath: 'assets/explore/geometric_small.png',
        ),
        ExploreCategoryItem(
          title: 'Cube Illusion',
          prompt: '3D cube optical illusion with geometric lines',
          bigImagePath: 'assets/explore/geometric_big.png',
          smallImagePath: 'assets/explore/geometric_small.png',
        ),
        ExploreCategoryItem(
          title: 'Metatron Cube',
          prompt: 'Sacred Metatrons cube with all platonic solids',
          bigImagePath: 'assets/explore/geometric_big.png',
          smallImagePath: 'assets/explore/geometric_small.png',
        ),
        ExploreCategoryItem(
          title: 'Spiral Pattern',
          prompt: 'Golden ratio spiral in geometric form',
          bigImagePath: 'assets/explore/geometric_big.png',
          smallImagePath: 'assets/explore/geometric_small.png',
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
      bigImagePath: 'assets/explore/custom_big.png',
      smallImagePath: 'assets/explore/custom_small.png',
      items: [
        ExploreCategoryItem(
          title: 'AI Fusion',
          prompt: 'Blend of multiple tattoo styles created by AI',
          bigImagePath: 'assets/explore/custom_big.png',
          smallImagePath: 'assets/explore/custom_small.png',
        ),
        ExploreCategoryItem(
          title: 'Unique Creation',
          prompt: 'One-of-a-kind design generated by artificial intelligence',
          bigImagePath: 'assets/explore/custom_big.png',
          smallImagePath: 'assets/explore/custom_small.png',
        ),
        ExploreCategoryItem(
          title: 'Abstract AI',
          prompt: 'AI-generated abstract pattern with unique flow',
          bigImagePath: 'assets/explore/custom_big.png',
          smallImagePath: 'assets/explore/custom_small.png',
        ),
        ExploreCategoryItem(
          title: 'Cyber Organic',
          prompt: 'Blend of cyberpunk and organic elements',
          bigImagePath: 'assets/explore/custom_big.png',
          smallImagePath: 'assets/explore/custom_small.png',
        ),
        ExploreCategoryItem(
          title: 'DreamScape',
          prompt: 'Surreal dreamlike design created by AI',
          bigImagePath: 'assets/explore/custom_big.png',
          smallImagePath: 'assets/explore/custom_small.png',
        ),
        ExploreCategoryItem(
          title: 'Neural Art',
          prompt: 'Artistic pattern inspired by neural networks',
          bigImagePath: 'assets/explore/custom_big.png',
          smallImagePath: 'assets/explore/custom_small.png',
        ),
        ExploreCategoryItem(
          title: 'Hybrid Style',
          prompt: 'Unique combination of traditional and modern styles',
          bigImagePath: 'assets/explore/custom_big.png',
          smallImagePath: 'assets/explore/custom_small.png',
        ),
        ExploreCategoryItem(
          title: 'AI Masterpiece',
          prompt: 'Complex AI-generated design with intricate details',
          bigImagePath: 'assets/explore/custom_big.png',
          smallImagePath: 'assets/explore/custom_small.png',
        ),
      ],
    ),
  ];
}
