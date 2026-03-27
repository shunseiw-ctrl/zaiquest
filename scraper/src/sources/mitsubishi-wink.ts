import { chromium, Page } from 'playwright';
import { createClient } from '@supabase/supabase-js';
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
      const MAX_PAGES = 100; // Safety limit (100 products/page × 100 = 10000 max)

      try {
        // Navigate to category (first page)
        const categoryUrl = `${WINK_SSL_BASE}searchProduct.do?ccd=${category.ccd}&oldProductFlg=1`;
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
            const normalizedModel = prod.modelNumber.trim().toUpperCase();
            if (seenModels.has(normalizedModel)) continue;
            seenModels.add(normalizedModel);

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

/** Extract spec data from a WINK product detail page */
async function extractDetailSpecs(page: Page): Promise<{
  airflow: string | null;
  noise_level: string | null;
  power_consumption: string | null;
  dimensions: string | null;
  voltage: string | null;
}> {
  return page.evaluate(() => {
    const specs: Record<string, string> = {};

    // WINK detail pages display specs in a table or definition list
    // Try table rows first (th/td pairs)
    const rows = document.querySelectorAll('table tr');
    for (const row of rows) {
      const th = row.querySelector('th');
      const td = row.querySelector('td');
      if (th && td) {
        const label = th.textContent?.trim() || '';
        const value = td.textContent?.trim() || '';
        if (label && value) specs[label] = value;
      }
    }

    // Also try dt/dd pairs
    const dts = document.querySelectorAll('dt');
    for (const dt of dts) {
      const dd = dt.nextElementSibling;
      if (dd?.tagName === 'DD') {
        const label = dt.textContent?.trim() || '';
        const value = dd.textContent?.trim() || '';
        if (label && value) specs[label] = value;
      }
    }

    // Map Japanese labels to spec fields
    let airflow: string | null = null;
    let noise_level: string | null = null;
    let power_consumption: string | null = null;
    let dimensions: string | null = null;
    let voltage: string | null = null;

    for (const [label, value] of Object.entries(specs)) {
      const l = label.toLowerCase();
      if (l.includes('風量') || l.includes('換気風量')) {
        airflow = value;
      } else if (l.includes('騒音') || l.includes('運転音')) {
        noise_level = value;
      } else if (l.includes('消費電力')) {
        power_consumption = value;
      } else if (l.includes('外形寸法') || l.includes('寸法')) {
        dimensions = value;
      } else if (l.includes('電源') || l.includes('電圧')) {
        voltage = value;
      }
    }

    return { airflow, noise_level, power_consumption, dimensions, voltage };
  });
}

/** Scrape detail pages for existing WINK products in the DB to fill spec data */
export async function scrapeMitsubishiWinkDetailPages(): Promise<{
  updated: number;
  errors: string[];
}> {
  const url = process.env.SUPABASE_URL;
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !key) {
    throw new Error('SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required');
  }
  const supabase = createClient(url, key);

  // Fetch WINK products that are missing spec data
  const { data: products, error: fetchError } = await supabase
    .from('products')
    .select('id, model_number, product_url, airflow, noise_level, power_consumption, raw_data')
    .eq('source', 'mitsubishi_wink')
    .or('airflow.is.null,noise_level.is.null,power_consumption.is.null');

  if (fetchError || !products) {
    throw new Error(`Failed to fetch WINK products: ${fetchError?.message}`);
  }

  if (products.length === 0) {
    console.log('[WINK Detail] スペック未取得の製品はありません');
    return { updated: 0, errors: [] };
  }

  console.log(`[WINK Detail] スペック未取得の製品: ${products.length}件`);

  const errors: string[] = [];
  let updated = 0;
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext();

  try {
    const page = await context.newPage();

    // Agree to terms first
    await agreeToTerms(page);

    for (let i = 0; i < products.length; i++) {
      const product = products[i];
      const productUrl = product.product_url;

      if (!productUrl) {
        errors.push(`${product.model_number}: product_url が未設定`);
        continue;
      }

      console.log(`[WINK Detail] (${i + 1}/${products.length}) ${product.model_number}`);

      try {
        await page.goto(productUrl, { waitUntil: 'networkidle', timeout: 30000 });
        await sleep(DELAY_MS);

        const specs = await extractDetailSpecs(page);

        // Build update payload — only update null fields
        const updateData: Record<string, unknown> = {};
        if (product.airflow == null && specs.airflow) {
          // Extract numeric value from airflow string (e.g., "75m³/h" → 75)
          const match = specs.airflow.match(/(\d+)/);
          if (match) updateData.airflow = parseInt(match[1], 10);
        }
        if (product.noise_level == null && specs.noise_level) {
          const match = specs.noise_level.match(/(\d+(\.\d+)?)/);
          if (match) updateData.noise_level = parseFloat(match[1]);
        }
        if (product.power_consumption == null && specs.power_consumption) {
          const match = specs.power_consumption.match(/(\d+(\.\d+)?)/);
          if (match) updateData.power_consumption = parseFloat(match[1]);
        }

        // Store raw spec data for reference
        const rawData = (product.raw_data as Record<string, unknown>) || {};
        rawData.wink_detail_specs = specs;
        updateData.raw_data = rawData;

        if (Object.keys(updateData).length > 1) {
          // More than just raw_data
          updateData.updated_at = new Date().toISOString();
          const { error: updateError } = await supabase
            .from('products')
            .update(updateData)
            .eq('id', product.id);

          if (updateError) {
            errors.push(`${product.model_number}: DB更新エラー: ${updateError.message}`);
          } else {
            updated++;
            const fields = Object.keys(updateData).filter((k) => k !== 'raw_data' && k !== 'updated_at');
            console.log(`  → ${fields.join(', ')} を更新`);
          }
        } else {
          // Only raw_data update (no numeric specs found)
          await supabase.from('products').update(updateData).eq('id', product.id);
          console.log(`  → スペック値の抽出なし（raw_dataのみ保存）`);
        }
      } catch (e) {
        const msg = e instanceof Error ? e.message : String(e);
        errors.push(`${product.model_number}: 詳細ページ取得エラー: ${msg}`);
        console.error(`  → エラー: ${msg}`);
      }
    }
  } finally {
    await browser.close();
  }

  console.log(`[WINK Detail] 完了: ${updated}件更新, ${errors.length}件エラー`);
  return { updated, errors };
}
