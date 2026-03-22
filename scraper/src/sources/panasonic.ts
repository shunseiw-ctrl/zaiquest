import * as cheerio from 'cheerio';
import { RawProduct } from '../normalizer.js';
import { DetailSpec } from '../types.js';
import { runDetailScraper } from '../detail-scraper-utils.js';

const BASE_URL = 'https://sumai.panasonic.jp';
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

function mapCategory(categoryText: string): string | undefined {
  const lower = categoryText.toLowerCase();
  if (lower.includes('パイプファン') || lower.includes('換気扇')) return 'ventilation-fan';
  if (lower.includes('レンジフード')) return 'range-hood';
  if (lower.includes('ダクト') || lower.includes('天埋')) return 'duct-fan';
  if (lower.includes('浴室')) return 'bathroom-dryer';
  return undefined;
}

export interface PanasonicScrapingResult {
  products: RawProduct[];
  errors: string[];
}

/** Scrape Panasonic Biz ventilation products */
export async function scrapePanasonic(): Promise<PanasonicScrapingResult> {
  const products: RawProduct[] = [];
  const errors: string[] = [];

  // Panasonic Biz has a product search with detail.php pages
  const categoryUrls = [
    '/air/kanki/pipe/',      // パイプファン
    '/air/kanki/tenpura/',   // 天埋換気扇
    '/air/kanki/range/',     // レンジフード
    '/air/kanki/bathkan/',   // 浴室換気乾燥機
  ];

  for (const categoryPath of categoryUrls) {
    try {
      const html = await fetchPage(`${BASE_URL}${categoryPath}`);
      const $ = cheerio.load(html);

      // Find product links
      $('a[href*="detail"]').each((_, el) => {
        const href = $(el).attr('href');
        if (href) {
          const fullUrl = href.startsWith('http') ? href : `${BASE_URL}${href}`;
          // Queue for later scraping
        }
      });

      // Parse product listings directly if available
      $('table tr, .product-list .product-item').each((_, el) => {
        try {
          const $el = $(el);
          const modelNumber = $el.find('.model-number, td:first-child a').text().trim();
          const name = $el.find('.product-name, td:nth-child(2)').text().trim();
          const price = $el.find('.price, td:nth-child(3)').text().trim();

          if (modelNumber && modelNumber.match(/^FY-/)) {
            products.push({
              model_number: modelNumber,
              name: name || modelNumber,
              manufacturer_slug: 'panasonic',
              category_slug: mapCategory(categoryPath),
              list_price: price || null,
              product_url: `${BASE_URL}${categoryPath}`,
              source: 'panasonic_biz',
              source_id: null,
              raw_data: null,
            });
          }
        } catch (e) {
          // Skip unparseable rows
        }
      });
    } catch (e) {
      const msg = e instanceof Error ? e.message : String(e);
      errors.push(`Failed to scrape ${categoryPath}: ${msg}`);
    }
  }

  return { products, errors };
}

// ---------------------------------------------------------------------------
// Detail page scraping (spec extraction from product pages)
// ---------------------------------------------------------------------------

/** Parse a Panasonic product detail page for specs */
export function parsePanasonicDetailPage(html: string): DetailSpec {
  const $ = cheerio.load(html);
  const spec: DetailSpec = {
    width_mm: null, height_mm: null, depth_mm: null,
    pipe_diameter: null, voltage: null, airflow: null,
    noise_level: null, power_consumption: null, list_price: null,
  };

  // Panasonic uses specification tables with th/td
  $('table tr, table th').closest('tr').each((_, row) => {
    const th = $(row).find('th').first().text().trim();
    const td = $(row).find('td').first().text().trim();
    if (!th || !td) return;

    if (th.includes('外形寸法') || th.includes('寸法')) {
      const dimMatch = td.match(/(\d+)\s*[×xX]\s*(\d+)\s*[×xX]\s*(\d+)/);
      if (dimMatch) {
        spec.width_mm = parseInt(dimMatch[1], 10);
        spec.height_mm = parseInt(dimMatch[2], 10);
        spec.depth_mm = parseInt(dimMatch[3], 10);
      }
    }
    if (th.includes('接続') || th.includes('ダクト径') || th.includes('パイプ径')) {
      const pipeMatch = td.match(/[φΦ]?\s*(\d+)/);
      if (pipeMatch) spec.pipe_diameter = parseInt(pipeMatch[1], 10);
    }
    if (th.includes('電源') || th.includes('電圧')) spec.voltage = td;
    if (th.includes('風量')) spec.airflow = td;
    if (th.includes('騒音')) spec.noise_level = td;
    if (th.includes('消費電力')) spec.power_consumption = td;
    if (th.includes('定価') || th.includes('希望小売') || th.includes('価格')) spec.list_price = td;
  });

  // Check for spec list elements (.spec-list, .productSpec, etc.)
  $('.spec-list li, .productSpec li, .specTable td').each((_, el) => {
    const text = $(el).text().trim();
    if (spec.voltage == null && (text.includes('電源') || text.includes('電圧'))) {
      const match = text.match(/[：:]\s*(.+)/);
      if (match) spec.voltage = match[1].trim();
    }
    if (spec.airflow == null && text.includes('風量')) {
      const match = text.match(/[：:]\s*(.+)/);
      if (match) spec.airflow = match[1].trim();
    }
  });

  // Check price in body text
  if (spec.list_price == null) {
    const bodyText = $('body').text();
    const priceMatch = bodyText.match(/希望小売価格[（(]税[抜込][)）][：:\s]*[￥¥]?\s*([\d,]+)/);
    if (priceMatch) spec.list_price = priceMatch[1];
  }

  return spec;
}

/** Scrape Panasonic detail pages for spec data */
export async function scrapePanasonicDetailPages(): Promise<{ updated: number; errors: string[] }> {
  return runDetailScraper({
    source: 'panasonic_biz',
    parser: parsePanasonicDetailPage,
  });
}
