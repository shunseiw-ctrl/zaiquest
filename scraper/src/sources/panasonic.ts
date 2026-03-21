import * as cheerio from 'cheerio';
import { RawProduct } from '../normalizer.js';

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
