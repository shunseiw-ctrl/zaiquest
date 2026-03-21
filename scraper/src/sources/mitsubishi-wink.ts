import { chromium } from 'playwright';
import { RawProduct } from '../normalizer.js';

const WINK_URL = 'https://www.mitsubishielectric.co.jp/ldg/wink/';
const DELAY_MS = 3000; // Extra conservative for Playwright

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export interface MitsubishiWinkScrapingResult {
  products: RawProduct[];
  errors: string[];
}

/** Scrape Mitsubishi WINK using Playwright (requires browser) */
export async function scrapeMitsubishiWink(): Promise<MitsubishiWinkScrapingResult> {
  const products: RawProduct[] = [];
  const errors: string[] = [];

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    userAgent: 'ZaiquestBot/1.0 (building material search; polite crawler)',
  });

  try {
    const page = await context.newPage();
    await page.goto(WINK_URL, { waitUntil: 'networkidle' });
    await sleep(DELAY_MS);

    // Navigate to ventilation fan category
    // WINK requires token-based navigation; adapt selectors as needed
    const categoryLinks = await page.$$eval(
      'a[href*="ventilation"], a[href*="kanki"], .category-link',
      (links) => links.map((a) => a.getAttribute('href')).filter(Boolean)
    );

    console.log(`Mitsubishi WINK: found ${categoryLinks.length} categories`);

    for (const link of categoryLinks) {
      try {
        const fullUrl = link!.startsWith('http') ? link! : `${WINK_URL}${link}`;
        await page.goto(fullUrl, { waitUntil: 'networkidle' });
        await sleep(DELAY_MS);

        // Extract product rows from the search results table
        const rows = await page.$$eval(
          'table.product-list tr, .search-result .item',
          (elements) =>
            elements.map((el) => ({
              modelNumber: el.querySelector('.model, td:nth-child(1)')?.textContent?.trim() ?? '',
              name: el.querySelector('.name, td:nth-child(2)')?.textContent?.trim() ?? '',
              specs: el.querySelector('.specs, td:nth-child(3)')?.textContent?.trim() ?? '',
              price: el.querySelector('.price, td:nth-child(4)')?.textContent?.trim() ?? '',
              detailUrl: el.querySelector('a')?.getAttribute('href') ?? '',
            }))
        );

        for (const row of rows) {
          if (!row.modelNumber || !row.modelNumber.match(/^V[A-Z\-\d]/)) continue;

          products.push({
            model_number: row.modelNumber,
            name: row.name || row.modelNumber,
            manufacturer_slug: 'mitsubishi',
            voltage: null,
            list_price: row.price || null,
            product_url: row.detailUrl
              ? row.detailUrl.startsWith('http')
                ? row.detailUrl
                : `${WINK_URL}${row.detailUrl}`
              : null,
            source: 'mitsubishi_wink',
            source_id: null,
            raw_data: { rawSpecs: row.specs },
          });
        }
      } catch (e) {
        const msg = e instanceof Error ? e.message : String(e);
        errors.push(`WINK category error: ${msg}`);
      }
    }
  } finally {
    await browser.close();
  }

  return { products, errors };
}
