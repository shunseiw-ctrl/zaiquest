import 'dotenv/config';
import { scrapeTaroto, scrapeDetailPages } from './sources/taroto.js';
import { scrapePanasonic, scrapePanasonicDetailPages } from './sources/panasonic.js';
import { scrapeToshiba, scrapeToshibaDetailPages } from './sources/toshiba.js';
import { scrapeMitsubishiWink, scrapeMitsubishiWinkDetailPages } from './sources/mitsubishi-wink.js';
import { scrapePanasonicBiz } from './sources/panasonic-biz.js';
import { importMitsubishiPdf } from './import-mitsubishi-pdf.js';
import { crossReferenceSpecs } from './cross-reference.js';
import { normalize, RawProduct } from './normalizer.js';
import { uploadProducts } from './uploader.js';

type SourceName = 'taroto' | 'panasonic' | 'panasonic-biz' | 'toshiba' | 'mitsubishi-wink' | 'mitsubishi-pdf' | 'all';
type DetailSourceName = 'taroto' | 'toshiba' | 'panasonic' | 'mitsubishi-wink';

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
    case 'panasonic-biz':
      return scrapePanasonicBiz();
    case 'mitsubishi-wink':
      return scrapeMitsubishiWink();
    case 'mitsubishi-pdf':
      // PDF import handles its own normalize+upload cycle; return empty for main flow
      await importMitsubishiPdf();
      return { products: [], errors: [] };
    case 'all': {
      // HTTP scrapers run in parallel
      const results = await Promise.allSettled([
        scrapeTaroto(),
        scrapePanasonic(),
        scrapeToshiba(),
        scrapePanasonicBiz(),
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

      // WINK uses Playwright — run sequentially after HTTP scrapers
      console.log('[ZAIQUEST Scraper] Playwright起動: mitsubishi-wink スクレイピング開始...');
      try {
        const winkResult = await scrapeMitsubishiWink();
        products.push(...winkResult.products);
        errors.push(...winkResult.errors);
      } catch (e) {
        const msg = e instanceof Error ? e.message : String(e);
        errors.push(`mitsubishi-wink failed: ${msg}`);
        console.error(`[ZAIQUEST Scraper] mitsubishi-wink エラー: ${msg}`);
      }

      return { products, errors };
    }
  }
}

async function main() {
  const args = process.argv.slice(2);

  // Merge mode: cross-reference specs between sources
  const mergeMode = args.includes('--merge');
  if (mergeMode) {
    console.log('[ZAIQUEST Scraper] Running cross-reference merge...');
    const { merged, errors: mergeErrors } = await crossReferenceSpecs();
    console.log(`[ZAIQUEST Scraper] Cross-reference complete: ${merged} products merged`);
    if (mergeErrors.length > 0) {
      console.warn(`[ZAIQUEST Scraper] Merge errors: ${mergeErrors.length}`);
      mergeErrors.forEach((e) => console.warn(`  - ${e}`));
    }
    return;
  }

  // Detail mode: scrape individual product pages for spec data
  const detailMode = args.includes('--detail');
  if (detailMode) {
    const sourceIdx = args.indexOf('--source');
    const detailSource: DetailSourceName =
      sourceIdx >= 0 && args[sourceIdx + 1]
        ? (args[sourceIdx + 1] as DetailSourceName)
        : 'taroto';

    console.log(`[ZAIQUEST Scraper] Running detail page scraper for ${detailSource}...`);
    let result: { updated: number; errors: string[] };

    switch (detailSource) {
      case 'taroto':
        result = await scrapeDetailPages();
        break;
      case 'toshiba':
        result = await scrapeToshibaDetailPages();
        break;
      case 'panasonic':
        result = await scrapePanasonicDetailPages();
        break;
      case 'mitsubishi-wink':
        console.log('[ZAIQUEST Scraper] Playwright起動: WINK詳細ページスクレイピング...');
        result = await scrapeMitsubishiWinkDetailPages();
        break;
    }

    console.log(`[ZAIQUEST Scraper] Detail scrape complete: ${result.updated} products updated`);
    if (result.errors.length > 0) {
      console.warn(`[ZAIQUEST Scraper] Detail errors: ${result.errors.length}`);
      result.errors.forEach((e) => console.warn(`  - ${e}`));
    }
    return;
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
