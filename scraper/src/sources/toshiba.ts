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
      'Accept': 'text/html',
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

/** Scrape Toshiba Carrier ventilation products (2-stage crawl) */
export async function scrapeToshiba(): Promise<ToshibaScrapingResult> {
  const products: RawProduct[] = [];
  const errors: string[] = [];

  // Stage 1: Get category pages
  const categoryUrls = [
    '/products/ventilation/duct/',
    '/products/ventilation/pipe/',
    '/products/ventilation/range/',
    '/products/ventilation/bathroom/',
  ];

  for (const categoryPath of categoryUrls) {
    try {
      const html = await fetchPage(`${BASE_URL}${categoryPath}`);
      const $ = cheerio.load(html);

      // Stage 2: Find and scrape product detail links
      const detailLinks: string[] = [];
      $('a[href*="product"], a[href*="detail"]').each((_, el) => {
        const href = $(el).attr('href');
        if (href && !detailLinks.includes(href)) {
          detailLinks.push(href.startsWith('http') ? href : `${BASE_URL}${href}`);
        }
      });

      console.log(`Toshiba ${categoryPath}: found ${detailLinks.length} products`);

      for (const link of detailLinks) {
        try {
          const detailHtml = await fetchPage(link);
          const product = parseToshibaDetail(detailHtml, link, categoryPath);
          if (product) {
            products.push(product);
          }
        } catch (e) {
          const msg = e instanceof Error ? e.message : String(e);
          errors.push(`Failed: ${link} - ${msg}`);
        }
      }
    } catch (e) {
      const msg = e instanceof Error ? e.message : String(e);
      errors.push(`Failed category: ${categoryPath} - ${msg}`);
    }
  }

  return { products, errors };
}

function mapCategory(path: string): string | undefined {
  if (path.includes('duct')) return 'duct-fan';
  if (path.includes('pipe')) return 'ventilation-fan';
  if (path.includes('range')) return 'range-hood';
  if (path.includes('bathroom')) return 'bathroom-dryer';
  return undefined;
}

function parseToshibaDetail(
  html: string,
  url: string,
  categoryPath: string
): RawProduct | null {
  const $ = cheerio.load(html);

  const titleText = $('h1, .product-name').first().text().trim();
  const modelMatch = titleText.match(/([A-Z]{2,5}[\-]?\d{2,}[A-Z\d\-]*)/i);
  if (!modelMatch) return null;

  const specs: Record<string, string> = {};
  $('table tr, .spec-item').each((_, row) => {
    const th = $(row).find('th, .spec-label').text().trim();
    const td = $(row).find('td, .spec-value').text().trim();
    if (th && td) specs[th] = td;
  });

  const dimensionText = specs['外形寸法'] || '';
  let width: string | null = null;
  let height: string | null = null;
  let depth: string | null = null;

  const dimMatch = dimensionText.match(
    /W?\s*(\d+)\s*[×x]\s*H?\s*(\d+)\s*[×x]\s*D?\s*(\d+)/i
  );
  if (dimMatch) {
    width = dimMatch[1];
    height = dimMatch[2];
    depth = dimMatch[3];
  }

  return {
    model_number: modelMatch[1],
    name: titleText,
    manufacturer_slug: 'toshiba',
    category_slug: mapCategory(categoryPath),
    width_mm: width,
    height_mm: height,
    depth_mm: depth,
    pipe_diameter: specs['接続パイプ'] || null,
    voltage: specs['電源'] || specs['電圧'] || null,
    airflow: specs['風量'] || null,
    noise_level: specs['騒音'] || null,
    power_consumption: specs['消費電力'] || null,
    list_price: specs['希望小売価格'] || null,
    product_url: url,
    image_url: null,
    source: 'toshiba',
    source_id: null,
    raw_data: specs,
  };
}
