import 'dotenv/config';
import { scrapeTaroto, scrapeDetailPages } from './sources/taroto.js';
import { scrapePanasonic } from './sources/panasonic.js';
import { scrapeToshiba } from './sources/toshiba.js';
import { scrapeMitsubishiWink } from './sources/mitsubishi-wink.js';
import { normalize, RawProduct } from './normalizer.js';
import { uploadProducts } from './uploader.js';

type SourceName = 'taroto' | 'panasonic' | 'toshiba' | 'mitsubishi-wink' | 'all';

async function scrapeSource(source: SourceName): Promise<{
  products: RawProduct[];
  errors: string[];
}> {
  switch (source) {
    case 'taroto':
      return scrapeTaroto();
    case 'panasonic':
      return scrapePanasonic();
    case 'toshiba':
      return scrapeToshiba();
    case 'mitsubishi-wink':
      return scrapeMitsubishiWink();
    case 'all': {
      const results = await Promise.allSettled([
        scrapeTaroto(),
        scrapePanasonic(),
        scrapeToshiba(),
        // mitsubishi-wink requires Playwright, run separately
      ]);

      const products: RawProduct[] = [];
      const errors: string[] = [];

      for (const result of results) {
        if (result.status === 'fulfilled') {
          products.push(...result.value.products);
          errors.push(...result.value.errors);
        } else {
          errors.push(`Source failed: ${result.reason}`);
        }
      }

      return { products, errors };
    }
  }
}

async function main() {
  const args = process.argv.slice(2);

  // Detail mode: scrape individual product pages for spec data
  const detailMode = args.includes('--detail');
  if (detailMode) {
    console.log('[ZAIQUEST Scraper] Running detail page scraper...');
    const { updated, errors: detailErrors } = await scrapeDetailPages();
    console.log(`[ZAIQUEST Scraper] Detail scrape complete: ${updated} products updated`);
    if (detailErrors.length > 0) {
      console.warn(`[ZAIQUEST Scraper] Detail errors: ${detailErrors.length}`);
      detailErrors.forEach((e) => console.warn(`  - ${e}`));
    }
    return; // Don't run normal scraping
  }

  const sourceIdx = args.indexOf('--source');
  const source: SourceName =
    sourceIdx >= 0 && args[sourceIdx + 1]
      ? (args[sourceIdx + 1] as SourceName)
      : 'all';

  console.log(`[ZAIQUEST Scraper] Starting: ${source}`);
  console.log(`[ZAIQUEST Scraper] Time: ${new Date().toISOString()}`);

  const { products: rawProducts, errors: scrapeErrors } =
    await scrapeSource(source);

  console.log(`[ZAIQUEST Scraper] Scraped: ${rawProducts.length} products`);
  if (scrapeErrors.length > 0) {
    console.warn(`[ZAIQUEST Scraper] Scraping errors: ${scrapeErrors.length}`);
    scrapeErrors.forEach((e) => console.warn(`  - ${e}`));
  }

  // Normalize
  const normalized = rawProducts.map(normalize);
  console.log(`[ZAIQUEST Scraper] Normalized: ${normalized.length} products`);

  // Upload
  const result = await uploadProducts(normalized);
  console.log(`[ZAIQUEST Scraper] Upload result:`, result);

  // Alert if count dropped significantly
  if (rawProducts.length === 0 && source !== 'all') {
    console.error(
      `[ZAIQUEST Scraper] WARNING: 0 products scraped from ${source}. HTML structure may have changed.`
    );
    process.exit(1);
  }

  console.log(`[ZAIQUEST Scraper] Done.`);
}

main().catch((e) => {
  console.error('[ZAIQUEST Scraper] Fatal error:', e);
  process.exit(1);
});
