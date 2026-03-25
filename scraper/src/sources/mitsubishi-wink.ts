import { chromium, Page } from 'playwright';
import { RawProduct } from '../normalizer.js';

const WINK_BASE = 'https://www.mitsubishielectric.co.jp/ldg/wink/';
const WINK_SSL_BASE = 'https://www.mitsubishielectric.co.jp/ldg/wink/ssl/';
const DELAY_MS = 3000; // Conservative delay between requests

// Category codes for ventilation products on WINK
export const VENTILATION_CATEGORIES = [
  { ccd: '104012', label: '住宅用 換気扇・ロスナイ' },
  { ccd: '202016', label: '業務用 換気扇・ロスナイ' },
  { ccd: '202017', label: '業務用ロスナイ' },
  { ccd: '202018', label: '産業用換気送風機' },
];

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export interface MitsubishiWinkScrapingResult {
  products: RawProduct[];
  errors: string[];
}

/** Agree to WINK terms of service by submitting the initial form */
async function agreeToTerms(page: Page): Promise<void> {
  await page.goto(WINK_BASE, { waitUntil: 'networkidle', timeout: 30000 });
  await sleep(2000);

  // The landing page has a form with hidden input termsAgree=true
  // Submit it to proceed to the main site
  await Promise.all([
    page.waitForNavigation({ waitUntil: 'networkidle', timeout: 15000 }),
    page.evaluate(() => {
      const form = document.querySelector('form');
      if (form) form.submit();
    }),
  ]);
  await sleep(2000);
  console.log('Mitsubishi WINK: agreed to terms, now on:', page.url());
}

/** Extract product data from a single category page */
async function extractProductsFromPage(page: Page): Promise<{
  products: Array<{
    modelNumber: string;
    name: string;
    price: string;
    releaseDate: string;
    isDiscontinued: boolean;
    detailUrl: string;
    pid: string;
    ccd: string;
  }>;
  totalCount: number;
  hasNextPage: boolean;
}> {
  // Extract total count from "検索結果XXX件中" text
  const totalCount = await page.evaluate(() => {
    const text = document.body.innerText;
    const match = text.match(/検索結果(\d+)件中/);
    return match ? parseInt(match[1], 10) : 0;
  });

  // Extract products using the actual WINK page structure:
  //   table#table_product_list > tbody > tr (one per product)
  //     div.sec_product_detail > h3 > a[name="productNameLink"] (model number + detail URL)
  //     p.txt_detail (product name, price, release date)
  const products = await page.evaluate(() => {
    const results: Array<{
      modelNumber: string;
      name: string;
      price: string;
      releaseDate: string;
      isDiscontinued: boolean;
      detailUrl: string;
      pid: string;
      ccd: string;
    }> = [];

    // Each product is in a div.sec_product_list inside the product table
    const productDivs = document.querySelectorAll('div.sec_product_list');

    for (const div of productDivs) {
      // Model number from the named link
      const nameLink = div.querySelector('a[name="productNameLink"]') as HTMLAnchorElement | null;
      if (!nameLink) continue;

      const modelNumber = nameLink.textContent?.trim() || '';
      if (!modelNumber) continue;

      const href = nameLink.getAttribute('href') || '';
      const pidMatch = href.match(/pid=(\d+)/);
      const ccdMatch = href.match(/ccd=(\d+)/);

      // Product detail text
      const detailP = div.querySelector('p.txt_detail');
      const detailText = detailP?.textContent || '';

      // Extract product description name (first meaningful line in txt_detail)
      let name = '';
      const lines = detailText.split('\n').map((l) => l.trim()).filter(Boolean);
      for (const line of lines) {
        if (
          !line.startsWith('価格') &&
          !line.startsWith('発売日') &&
          !line.startsWith('生産終了') &&
          line.length > 2 &&
          line.length < 100
        ) {
          name = line;
          break;
        }
      }

      // Extract price: "価格：XX,XXX円（税別）"
      let price = '';
      const priceMatch = detailText.match(/価格[：:]([0-9,]+)円/);
      if (priceMatch) price = priceMatch[1].replace(/,/g, '');

      // Extract release date
      let releaseDate = '';
      const dateMatch = detailText.match(/発売日[：:](\d{4}年\d{2}月\d{2}日)/);
      if (dateMatch) releaseDate = dateMatch[1];

      // Check if discontinued
      let isDiscontinued = false;
      const disconMatch = detailText.match(/生産終了[：:](\d{4}年\d{2}月)/);
      if (disconMatch) isDiscontinued = true;
      // Also check for hidden span with 生産終了 (visibility:hidden means still in production)
      const disconSpan = div.querySelector('span[style*="visibility:hidden"]');
      if (disconSpan && disconSpan.textContent?.includes('生産終了')) {
        isDiscontinued = false; // Hidden means NOT discontinued
      } else if (detailText.includes('生産終了')) {
        isDiscontinued = true;
      }

      results.push({
        modelNumber,
        name: name || modelNumber,
        price,
        releaseDate,
        isDiscontinued,
        detailUrl: href,
        pid: pidMatch ? pidMatch[1] : '',
        ccd: ccdMatch ? ccdMatch[1] : '',
      });
    }
    return results;
  });

  // Check if there's a "次へ" (next) link
  const hasNextPage = await page.evaluate(() => {
    const links = document.querySelectorAll('a');
    for (const link of links) {
      if (link.textContent?.trim() === '次へ') return true;
    }
    return false;
  });

  return { products, totalCount, hasNextPage };
}

/** Scrape Mitsubishi WINK using Playwright (requires browser) */
export async function scrapeMitsubishiWink(): Promise<MitsubishiWinkScrapingResult> {
  const products: RawProduct[] = [];
  const errors: string[] = [];
  const seenModels = new Set<string>();

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext();

  try {
    const page = await context.newPage();

    // Step 1: Agree to terms
    await agreeToTerms(page);

    // Step 2: Scrape each ventilation category
    for (const category of VENTILATION_CATEGORIES) {
      console.log(`\nMitsubishi WINK: scraping category "${category.label}" (ccd=${category.ccd})`);

      let pageNum = 1;
      let categoryProductCount = 0;
      const MAX_PAGES = 25; // Safety limit (100 products/page × 25 = 2500 max)

      try {
        // Navigate to category (first page)
        const categoryUrl = `${WINK_SSL_BASE}searchProduct.do?ccd=${category.ccd}`;
        await page.goto(categoryUrl, { waitUntil: 'networkidle', timeout: 30000 });
        await sleep(DELAY_MS);

        while (pageNum <= MAX_PAGES) {
          const { products: pageProducts, totalCount, hasNextPage } =
            await extractProductsFromPage(page);

          if (pageNum === 1) {
            console.log(`  Total products in category: ${totalCount}`);
          }

          console.log(`  Page ${pageNum}: found ${pageProducts.length} products`);

          for (const prod of pageProducts) {
            // Deduplicate by model number
            if (seenModels.has(prod.modelNumber)) continue;
            seenModels.add(prod.modelNumber);

            const productUrl = prod.detailUrl.startsWith('http')
              ? prod.detailUrl
              : `${WINK_SSL_BASE}${prod.detailUrl}`;

            products.push({
              model_number: prod.modelNumber,
              name: prod.name || prod.modelNumber,
              manufacturer_slug: 'mitsubishi',
              category_slug: category.label.includes('住宅用') ? 'residential' : 'commercial',
              voltage: null,
              list_price: prod.price || null,
              product_url: productUrl,
              source: 'mitsubishi_wink',
              source_id: prod.pid,
              is_discontinued: prod.isDiscontinued,
              raw_data: {
                wink_ccd: prod.ccd,
                wink_pid: prod.pid,
                category: category.label,
                releaseDate: prod.releaseDate,
              },
            });
            categoryProductCount++;
          }

          if (!hasNextPage || pageProducts.length === 0) break;

          // Click next page
          pageNum++;
          try {
            await Promise.all([
              page.waitForNavigation({ waitUntil: 'networkidle', timeout: 15000 }),
              page.evaluate(() => {
                const links = document.querySelectorAll('a');
                for (const link of links) {
                  if (link.textContent?.trim() === '次へ') {
                    link.click();
                    return;
                  }
                }
              }),
            ]);
            await sleep(DELAY_MS);
          } catch (navErr) {
            const msg = navErr instanceof Error ? navErr.message : String(navErr);
            errors.push(`WINK pagination error on page ${pageNum} of ${category.label}: ${msg}`);
            break;
          }
        }

        console.log(`  Category "${category.label}" total: ${categoryProductCount} unique products`);
      } catch (e) {
        const msg = e instanceof Error ? e.message : String(e);
        errors.push(`WINK category error (${category.label}): ${msg}`);
        console.error(`  Error in category "${category.label}": ${msg}`);
      }
    }
  } finally {
    await browser.close();
  }

  console.log(`\nMitsubishi WINK: total unique products scraped: ${products.length}`);
  return { products, errors };
}
