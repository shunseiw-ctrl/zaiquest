import * as cheerio from 'cheerio';
import { RawProduct } from '../normalizer.js';
import { DetailSpec } from '../types.js';
import { runDetailScraper } from '../detail-scraper-utils.js';

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

// ---------------------------------------------------------------------------
// Detail page scraping (spec extraction from category pages)
// ---------------------------------------------------------------------------

/** Parse Toshiba category page to extract specs for a specific model */
export function parseToshibaDetailPage(html: string): DetailSpec {
  const $ = cheerio.load(html);
  const spec: DetailSpec = {
    width_mm: null, height_mm: null, depth_mm: null,
    pipe_diameter: null, voltage: null, airflow: null,
    noise_level: null, power_consumption: null, list_price: null,
  };

  // Toshiba pages have spec tables within sections for each model
  // Look for table rows with spec data
  $('table tr').each((_, row) => {
    const th = $(row).find('th').first().text().trim();
    const td = $(row).find('td').first().text().trim();
    if (!th || !td) return;

    const thLower = th.toLowerCase();
    if (thLower.includes('外形寸法') || thLower.includes('寸法')) {
      const dimMatch = td.match(/(\d+)\s*[×xX]\s*(\d+)\s*[×xX]\s*(\d+)/);
      if (dimMatch) {
        spec.width_mm = parseInt(dimMatch[1], 10);
        spec.height_mm = parseInt(dimMatch[2], 10);
        spec.depth_mm = parseInt(dimMatch[3], 10);
      }
    }
    if (thLower.includes('接続') || thLower.includes('ダクト径') || thLower.includes('パイプ径')) {
      const pipeMatch = td.match(/[φΦ]?\s*(\d+)/);
      if (pipeMatch) spec.pipe_diameter = parseInt(pipeMatch[1], 10);
    }
    if (thLower.includes('電源') || thLower.includes('電圧')) spec.voltage = td;
    if (thLower.includes('風量')) spec.airflow = td;
    if (thLower.includes('騒音')) spec.noise_level = td;
    if (thLower.includes('消費電力')) spec.power_consumption = td;
    if (thLower.includes('定価') || thLower.includes('希望小売') || thLower.includes('価格')) spec.list_price = td;
  });

  // Also check dl/dt/dd structures
  $('dl').each((_, dl) => {
    $(dl).find('dt').each((i, dt) => {
      const label = $(dt).text().trim();
      const value = $(dl).find('dd').eq(i).text().trim();
      if (!label || !value) return;

      if (label.includes('電源') && spec.voltage == null) spec.voltage = value;
      if (label.includes('風量') && spec.airflow == null) spec.airflow = value;
      if (label.includes('騒音') && spec.noise_level == null) spec.noise_level = value;
      if (label.includes('消費電力') && spec.power_consumption == null) spec.power_consumption = value;
    });
  });

  // Check for price in text (メーカー希望小売価格)
  const bodyText = $('body').text();
  if (spec.list_price == null) {
    const priceMatch = bodyText.match(/希望小売価格[：:\s]*[￥¥]?\s*([\d,]+)/);
    if (priceMatch) spec.list_price = priceMatch[1];
  }

  return spec;
}

/** Scrape Toshiba detail pages for spec data */
export async function scrapeToshibaDetailPages(): Promise<{ updated: number; errors: string[] }> {
  return runDetailScraper({
    source: 'toshiba',
    parser: parseToshibaDetailPage,
  });
}
