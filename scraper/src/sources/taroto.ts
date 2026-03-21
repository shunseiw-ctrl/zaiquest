import * as cheerio from 'cheerio';
import { RawProduct } from '../normalizer.js';

const BASE_URL = 'https://www.taroto.jp';
const DELAY_MS = 2000; // 1req/2sec to respect server

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

/** Fetch a page with polite delay */
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

/** Category definitions with slug mappings */
const CATEGORIES = [
  { path: 'kanki-pipe', slug: 'ventilation-fan', label: 'パイプファン' },
  { path: 'kanki-duct', slug: 'duct-fan', label: 'ダクト換気扇' },
  { path: 'kanki-kitchen', slug: 'range-hood', label: 'レンジフード' },
  { path: 'kanki-bath', slug: 'bathroom-dryer', label: '浴室乾燥機' },
  { path: 'kanki-kabe', slug: 'ventilation-fan', label: '壁付換気扇' },
] as const;

/** Map manufacturer names to slugs */
function mapManufacturer(name: string): string {
  const lower = name.toLowerCase();
  if (lower.includes('panasonic') || lower.includes('パナソニック')) return 'panasonic';
  if (lower.includes('三菱') || lower.includes('mitsubishi')) return 'mitsubishi';
  if (lower.includes('東芝') || lower.includes('toshiba')) return 'toshiba';
  return 'other';
}

/** Extract price number from text like "￥8,682(税込)" */
function extractPrice(text: string): string | null {
  const match = text.match(/[￥¥]\s*([\d,]+)/);
  return match ? match[1].replace(/,/g, '') : null;
}

/** Extract model number from product title */
function extractModelNumber(text: string): string | null {
  // Match patterns like VFP-8GK4, FY-08PD9D, V-08PQFF4, DVB-18S4, WD-240DK2, etc.
  const match = text.match(/([A-Z]{1,5}[\-]?\d{1,5}[A-Z\d\-()]*)/i);
  return match ? match[1] : null;
}

export interface TarotoScrapingResult {
  products: RawProduct[];
  errors: string[];
}

/** Scrape all products from a single category listing page */
function parseListingPage(
  html: string,
  categorySlug: string,
): RawProduct[] {
  const $ = cheerio.load(html);
  const products: RawProduct[] = [];

  // Find all product links
  const productLinks = $('a[href*="/view/item/"]');
  const seen = new Set<string>();

  productLinks.each((_, el) => {
    const $el = $(el);
    const href = $el.attr('href') || '';
    const text = $el.text().trim();

    // Skip if no text content (image-only links) or already processed
    if (!text || text.length < 5) return;
    const itemId = href.match(/\/view\/item\/(\d+)/)?.[1];
    if (!itemId || seen.has(itemId)) return;
    seen.add(itemId);

    const modelNumber = extractModelNumber(text);
    if (!modelNumber) return;

    // Find manufacturer - check sibling/parent elements
    const $parent = $el.parent();
    const parentText = $parent.text();
    const manufacturerSlug = mapManufacturer(parentText || text);

    // Find price - look in parent container for ￥ text
    let priceText: string | null = null;
    $parent.find('div, span').each((_, child) => {
      const childText = $(child).text();
      if (childText.includes('￥') && !priceText) {
        priceText = extractPrice(childText);
      }
    });
    // Also check parent's siblings
    if (!priceText) {
      $parent.siblings().each((_, sib) => {
        const sibText = $(sib).text();
        if (sibText.includes('￥') && !priceText) {
          priceText = extractPrice(sibText);
        }
      });
    }

    // Find image URL
    let imageUrl: string | null = null;
    const $img = $parent.find('img[src*="itemimages"]').first();
    if ($img.length) {
      imageUrl = $img.attr('src') || null;
    } else {
      // Check sibling links for image
      $parent.parent().find('img[src*="itemimages"]').first().each((_, img) => {
        imageUrl = $(img).attr('src') || null;
      });
    }

    const productUrl = href.startsWith('http') ? href : `${BASE_URL}${href.split('?')[0]}`;
    const name = text.replace(modelNumber, '').trim() || text;

    products.push({
      model_number: modelNumber,
      name,
      manufacturer_slug: manufacturerSlug,
      category_slug: categorySlug,
      street_price: priceText,
      product_url: productUrl,
      image_url: imageUrl,
      source: 'taroto',
      source_id: itemId,
      raw_data: null,
    });
  });

  return products;
}

/** Get total page count from listing page */
function getPageCount(html: string): number {
  const $ = cheerio.load(html);
  let maxPage = 1;

  // Look for pagination links with page parameter
  $('a[href*="page="]').each((_, el) => {
    const href = $(el).attr('href') || '';
    const pageMatch = href.match(/page=(\d+)/);
    if (pageMatch) {
      const page = parseInt(pageMatch[1], 10);
      if (page > maxPage) maxPage = page;
    }
  });

  return maxPage;
}

/** Scrape taroto.jp ventilation products */
export async function scrapeTaroto(): Promise<TarotoScrapingResult> {
  const allProducts: RawProduct[] = [];
  const errors: string[] = [];
  const seenModels = new Set<string>();

  for (const category of CATEGORIES) {
    try {
      const firstPageUrl = `${BASE_URL}/view/category/${category.path}`;
      console.log(`[Taroto] Fetching category: ${category.label} (${category.path})`);

      const firstHtml = await fetchPage(firstPageUrl);
      const pageCount = getPageCount(firstHtml);
      console.log(`[Taroto] ${category.label}: ${pageCount} pages`);

      // Parse first page
      const firstProducts = parseListingPage(firstHtml, category.slug);
      for (const p of firstProducts) {
        if (!seenModels.has(p.model_number)) {
          seenModels.add(p.model_number);
          allProducts.push(p);
        }
      }

      // Parse remaining pages
      for (let page = 2; page <= pageCount; page++) {
        try {
          const html = await fetchPage(`${firstPageUrl}?page=${page}`);
          const products = parseListingPage(html, category.slug);
          for (const p of products) {
            if (!seenModels.has(p.model_number)) {
              seenModels.add(p.model_number);
              allProducts.push(p);
            }
          }
        } catch (e) {
          const msg = e instanceof Error ? e.message : String(e);
          errors.push(`Failed page ${page} of ${category.path}: ${msg}`);
        }
      }

      console.log(`[Taroto] ${category.label}: collected ${firstProducts.length}+ products`);
    } catch (e) {
      const msg = e instanceof Error ? e.message : String(e);
      errors.push(`Failed category ${category.path}: ${msg}`);
    }
  }

  console.log(`[Taroto] Total unique products: ${allProducts.length}`);
  return { products: allProducts, errors };
}
