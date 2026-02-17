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
      bigImagePath: 'assets/explore/japanese_big.png',
      smallImagePath: 'assets/explore/japanese_small.png',
      items: [
        ExploreCategoryItem(
          title: 'Dragon Sleeve',
          prompt: 'Japanese style dragon with flowing clouds and waves',
          bigImagePath: 'assets/explore/japanese_big.png',
          smallImagePath: 'assets/explore/japanese_small.png',
        ),
        ExploreCategoryItem(
          title: 'Koi Fish',
          prompt: 'Traditional Japanese koi fish swimming upstream',
          bigImagePath: 'assets/explore/japanese_big.png',
          smallImagePath: 'assets/explore/japanese_small.png',
        ),
        ExploreCategoryItem(
          title: 'Cherry Blossom',
          prompt: 'Delicate cherry blossoms in Japanese style',
          bigImagePath: 'assets/explore/japanese_big.png',
          smallImagePath: 'assets/explore/japanese_small.png',
        ),
        ExploreCategoryItem(
          title: 'Samurai Warrior',
          prompt: 'Traditional Japanese samurai in full armor',
          bigImagePath: 'assets/explore/japanese_big.png',
          smallImagePath: 'assets/explore/japanese_small.png',
        ),
        ExploreCategoryItem(
          title: 'Geisha Portrait',
          prompt: 'Beautiful geisha with traditional makeup and kimono',
          bigImagePath: 'assets/explore/japanese_big.png',
          smallImagePath: 'assets/explore/japanese_small.png',
        ),
        ExploreCategoryItem(
          title: 'Phoenix Bird',
          prompt: 'Japanese phoenix rising with detailed feathers',
          bigImagePath: 'assets/explore/japanese_big.png',
          smallImagePath: 'assets/explore/japanese_small.png',
        ),
        ExploreCategoryItem(
          title: 'Tiger & Bamboo',
          prompt: 'Fierce tiger among bamboo stalks',
          bigImagePath: 'assets/explore/japanese_big.png',
          smallImagePath: 'assets/explore/japanese_small.png',
        ),
        ExploreCategoryItem(
          title: 'Wave Pattern',
          prompt: 'Traditional Japanese wave pattern with foam',
          bigImagePath: 'assets/explore/japanese_big.png',
          smallImagePath: 'assets/explore/japanese_small.png',
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
      bigImagePath: 'assets/explore/floral_big.png',
      smallImagePath: 'assets/explore/floral_small.png',
      items: [
        ExploreCategoryItem(
          title: 'Rose Bouquet',
          prompt: 'Delicate roses with leaves and natural shading',
          bigImagePath: 'assets/explore/floral_big.png',
          smallImagePath: 'assets/explore/floral_small.png',
        ),
        ExploreCategoryItem(
          title: 'Wildflowers',
          prompt: 'Collection of wildflowers in a natural arrangement',
          bigImagePath: 'assets/explore/floral_big.png',
          smallImagePath: 'assets/explore/floral_small.png',
        ),
        ExploreCategoryItem(
          title: 'Lotus Flower',
          prompt: 'Sacred lotus flower with detailed petals',
          bigImagePath: 'assets/explore/floral_big.png',
          smallImagePath: 'assets/explore/floral_small.png',
        ),
        ExploreCategoryItem(
          title: 'Sunflower',
          prompt: 'Bright sunflower with detailed center',
          bigImagePath: 'assets/explore/floral_big.png',
          smallImagePath: 'assets/explore/floral_small.png',
        ),
        ExploreCategoryItem(
          title: 'Peony Blossom',
          prompt: 'Lush peony flower with layered petals',
          bigImagePath: 'assets/explore/floral_big.png',
          smallImagePath: 'assets/explore/floral_small.png',
        ),
        ExploreCategoryItem(
          title: 'Vine & Leaves',
          prompt: 'Flowing vine with detailed leaves',
          bigImagePath: 'assets/explore/floral_big.png',
          smallImagePath: 'assets/explore/floral_small.png',
        ),
        ExploreCategoryItem(
          title: 'Orchid Branch',
          prompt: 'Elegant orchid branch with multiple blooms',
          bigImagePath: 'assets/explore/floral_big.png',
          smallImagePath: 'assets/explore/floral_small.png',
        ),
        ExploreCategoryItem(
          title: 'Fern Leaves',
          prompt: 'Delicate fern leaves with natural curves',
          bigImagePath: 'assets/explore/floral_big.png',
          smallImagePath: 'assets/explore/floral_small.png',
        ),
      ],
    ),
    ExploreCategory(
      id: 'mythology',
      title: 'Mythology & Fantasy',
      prompt: 'Mythical creatures, gods, and fantasy-inspired designs.',
      bigImagePath: 'assets/explore/mythology_big.png',
      smallImagePath: 'assets/explore/mythology_small.png',
      items: [
        ExploreCategoryItem(
          title: 'Phoenix Rising',
          prompt: 'Majestic phoenix with flames and detailed feathers',
          bigImagePath: 'assets/explore/mythology_big.png',
          smallImagePath: 'assets/explore/mythology_small.png',
        ),
        ExploreCategoryItem(
          title: 'Greek Gods',
          prompt: 'Classical Greek mythology inspired design',
          bigImagePath: 'assets/explore/mythology_big.png',
          smallImagePath: 'assets/explore/mythology_small.png',
        ),
        ExploreCategoryItem(
          title: 'Dragon Guardian',
          prompt: 'Mythical dragon protecting ancient treasure',
          bigImagePath: 'assets/explore/mythology_big.png',
          smallImagePath: 'assets/explore/mythology_small.png',
        ),
        ExploreCategoryItem(
          title: 'Medusa Head',
          prompt: 'Medusa with snake hair in Greek mythology style',
          bigImagePath: 'assets/explore/mythology_big.png',
          smallImagePath: 'assets/explore/mythology_small.png',
        ),
        ExploreCategoryItem(
          title: 'Valkyrie Warrior',
          prompt: 'Norse Valkyrie with wings and armor',
          bigImagePath: 'assets/explore/mythology_big.png',
          smallImagePath: 'assets/explore/mythology_small.png',
        ),
        ExploreCategoryItem(
          title: 'Unicorn Magic',
          prompt: 'Mystical unicorn with magical elements',
          bigImagePath: 'assets/explore/mythology_big.png',
          smallImagePath: 'assets/explore/mythology_small.png',
        ),
        ExploreCategoryItem(
          title: 'Anubis God',
          prompt: 'Egyptian god Anubis with hieroglyphics',
          bigImagePath: 'assets/explore/mythology_big.png',
          smallImagePath: 'assets/explore/mythology_small.png',
        ),
        ExploreCategoryItem(
          title: 'Kraken Beast',
          prompt: 'Legendary kraken sea monster with tentacles',
          bigImagePath: 'assets/explore/mythology_big.png',
          smallImagePath: 'assets/explore/mythology_small.png',
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
