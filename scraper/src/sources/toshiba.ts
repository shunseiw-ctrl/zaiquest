import * as cheerio from 'cheerio';
import { RawProduct } from '../normalizer.js';

const BASE_URL = 'https://www.toshiba-carrier.co.jp';
const DELAY_MS = 2000;

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function fetchPage(url: string): Promise<string> {
  await sleep(DELAY_MS);
  const response = await fetch(url, {
    headers: {
      'User-Agent': 'ZaiquestBot/1.0 (building material search; polite crawler)',
      Accept: 'text/html',
    },
  });

  if (!response.ok) {
    throw new Error(`HTTP ${response.status} for ${url}`);
  }

  return response.text();
}

export interface ToshibaScrapingResult {
  products: RawProduct[];
  errors: string[];
}

/** Category definitions for Toshiba Carrier domestic ventilation products */
const CATEGORIES = [
  {
    path: '/products/fan/domestic/pipe/index_j.htm',
    slug: 'ventilation-fan',
    label: 'パイプファン',
  },
  {
    path: '/products/fan/domestic/pipe_pita/index_j.htm',
    slug: 'ventilation-fan',
    label: 'パイプファン(ピタパネ)',
  },
  {
    path: '/products/fan/domestic/regular/index_j.htm',
    slug: 'ventilation-fan',
    label: '一般換気扇',
  },
  {
    path: '/products/fan/domestic/range-food/index_j.htm',
    slug: 'range-hood',
    label: 'レンジフード',
  },
  {
    path: '/products/fan/domestic/window/index_j.htm',
    slug: 'ventilation-fan',
    label: '窓用換気扇',
  },
  {
    path: '/products/fan/domestic/aircon-fan/index_j.htm',
    slug: 'ventilation-fan',
    label: '空調換気扇',
  },
] as const;

/** Parse a Toshiba category listing page */
function parseCategoryPage(
  html: string,
  categorySlug: string,
  categoryPath: string,
): RawProduct[] {
  const $ = cheerio.load(html);
  const products: RawProduct[] = [];
  const seen = new Set<string>();

  // Toshiba pages use h2 headings for model numbers
  $('h2').each((_, heading) => {
    const modelText = $(heading).text().trim();

    // Match model number patterns like VFP-8W5, VFR-63LJB(K), VFH-20H2
    const modelMatch = modelText.match(
      /^([A-Z]{2,5}-\d{1,5}[A-Z\d\-()（）]*)/i
    );
    if (!modelMatch) return;

    const modelNumber = modelMatch[1]
      .replace(/（/g, '(')
      .replace(/）/g, ')');
    if (seen.has(modelNumber)) return;
    seen.add(modelNumber);

    // Get description text from siblings
    const $parent = $(heading).parent();
    const descText = $parent.text().replace(modelText, '').trim();

    // Find image URL - look for img near the heading
    let imageUrl: string | null = null;
    // Check siblings after the heading
    $(heading).nextAll('img').first().each((_, img) => {
      const src = $(img).attr('src');
      if (src) {
        const baseDir = categoryPath.replace(/\/[^/]+$/, '');
        imageUrl = src.startsWith('http')
          ? src
          : `${BASE_URL}${baseDir}/${src}`;
      }
    });
    if (!imageUrl) {
      $parent.find('img').each((_, img) => {
        const src = $(img).attr('src');
        if (src && !imageUrl) {
          const baseDir = categoryPath.replace(/\/[^/]+$/, '');
          imageUrl = src.startsWith('http')
            ? src
            : `${BASE_URL}${baseDir}/${src}`;
        }
      });
    }

    // Extract pipe diameter from description
    let pipeDiameter: string | null = null;
    const pipeMatch = descText.match(/[φΦ](\d+)/);
    if (pipeMatch) pipeDiameter = pipeMatch[1];

    // Product URL on the official site
    const productUrl = `${BASE_URL}${categoryPath}`;

    products.push({
      model_number: modelNumber,
      name: `東芝 ${modelText}`,
      manufacturer_slug: 'toshiba',
      category_slug: categorySlug,
      pipe_diameter: pipeDiameter,
      product_url: productUrl,
      image_url: imageUrl,
      source: 'toshiba',
      source_id: modelNumber,
      raw_data: { description: descText.slice(0, 500) },
    });
  });

  return products;
}

/** Scrape Toshiba Carrier ventilation products */
export async function scrapeToshiba(): Promise<ToshibaScrapingResult> {
  const allProducts: RawProduct[] = [];
  const errors: string[] = [];
  const seenModels = new Set<string>();

  for (const category of CATEGORIES) {
    try {
      console.log(`[Toshiba] Fetching: ${category.label} (${category.path})`);
      const html = await fetchPage(`${BASE_URL}${category.path}`);
      const products = parseCategoryPage(html, category.slug, category.path);

      for (const p of products) {
        if (!seenModels.has(p.model_number)) {
          seenModels.add(p.model_number);
          allProducts.push(p);
        }
      }

      console.log(`[Toshiba] ${category.label}: ${products.length} products`);
    } catch (e) {
      const msg = e instanceof Error ? e.message : String(e);
      errors.push(`Failed ${category.path}: ${msg}`);
    }
  }

  console.log(`[Toshiba] Total unique products: ${allProducts.length}`);
  return { products: allProducts, errors };
}
