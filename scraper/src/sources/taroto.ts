import * as cheerio from 'cheerio';
import { RawProduct } from '../normalizer.js';
import { DetailSpec } from '../types.js';
import { runDetailScraper } from '../detail-scraper-utils.js';

export type { DetailSpec };

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
  { path: 'kanki-mado', slug: 'ventilation-fan', label: '窓用換気扇' },
  { path: 'kanki-netu', slug: 'heat-exchange-fan', label: '空調・熱交換型換気扇' },
  { path: 'kanki-system', slug: 'ventilation-system', label: '換気システム・中間ダクトファン' },
  { path: 'kanki-yuuatu', slug: 'industrial-fan', label: '有圧・産業用換気扇' },
  { path: 'kanki-souhuu', slug: 'duct-blower', label: 'ダクト用送風機' },
  { path: 'kanki-seijyou', slug: 'air-purifier', label: '空気清浄機' },
  { path: 'kanki-remocon', slug: 'ventilation-controller', label: 'スイッチ・コントローラー' },
  { path: 'kanki-buzai', slug: 'ventilation-parts', label: 'システム部材・フード' },
] as const;

/** Comparison table (対比表) page definitions - old→new model replacement guides */
const COMPARISON_PAGES = [
  { path: 'taihi1', manufacturer: 'panasonic', label: 'パナソニック対比表' },
  { path: 'taihi2', manufacturer: 'toshiba', label: '東芝対比表' },
  { path: 'taihi3', manufacturer: 'mitsubishi', label: '三菱対比表' },
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
  // Try multiple patterns in priority order:
  const patterns = [
    // Standard: FY-08PD9D, VFP-8GK4, DVB-18S4, VB-NET-GZ150P
    /([A-Z]{2,5}[\-][A-Z0-9\-()]+)/i,
    // Single-letter prefix: P-01DC, F-1SS3, W-40SBM
    /([A-Z][\-]\d[A-Z0-9\-()]*)/i,
    // No-hyphen: PYU1510, AL100
    /([A-Z]{1,5}\d{1,5}[A-Z\d\-()]*)/i,
    // Pure numeric (6+ digits): 41101370
    /(\d{6,})/,
  ];

  for (const pattern of patterns) {
    const match = text.match(pattern);
    if (match && match[1].length >= 3) return match[1];
  }
  return null;
}

export interface TarotoScrapingResult {
  products: RawProduct[];
  errors: string[];
}

/** Scrape all products from a single category listing page */
export function parseListingPage(
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

/** Parse comparison table page (対比表) to extract replacement model products */
export function parseComparisonPage(
  html: string,
  manufacturerSlug: string,
): RawProduct[] {
  const $ = cheerio.load(html);
  const products: RawProduct[] = [];
  const seen = new Set<string>();

  // Comparison tables have rows: old model | new model (linked) | notes
  $('table tr').each((_, row) => {
    const $cells = $(row).find('td');
    if ($cells.length < 2) return;

    // The replacement model cell contains links to product detail pages
    $cells.each((_, cell) => {
      $(cell).find('a[href*="/view/item/"]').each((_, link) => {
        const $link = $(link);
        const href = $link.attr('href') || '';
        const text = $link.text().trim();

        if (!text || text.length < 3) return;

        const itemId = href.match(/\/view\/item\/(\d+)/)?.[1];
        if (!itemId || seen.has(itemId)) return;
        seen.add(itemId);

        const modelNumber = extractModelNumber(text);
        if (!modelNumber) return;

        // Get old model numbers from the first cell (predecessor info)
        // Replace <br> tags with newlines before extracting text
        const $firstCell = $($cells.first());
        $firstCell.find('br').replaceWith('\n');
        const firstCellText = $firstCell.text().trim();
        const predecessorModels = firstCellText
          .split(/[,\n]+/)
          .map(s => s.trim())
          .filter(s => /^[A-Z]{1,5}[\-]?\d/i.test(s));

        // Get notes from the last cell
        const notesCell = $cells.length >= 3 ? $($cells.last()).text().trim() : null;

        const productUrl = href.startsWith('http') ? href : `${BASE_URL}${href.split('?')[0]}`;

        products.push({
          model_number: modelNumber,
          name: text,
          manufacturer_slug: manufacturerSlug,
          category_slug: 'ventilation-fan',
          street_price: null,
          product_url: productUrl,
          image_url: null,
          source: 'taroto',
          source_id: itemId,
          predecessor_model: predecessorModels.length > 0 ? predecessorModels[0] : null,
          raw_data: notesCell ? { taihi_note: notesCell } : null,
        });
      });
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

  // Scrape comparison table pages (対比表) for replacement model data
  for (const taihi of COMPARISON_PAGES) {
    try {
      const url = `${BASE_URL}/view/page/${taihi.path}`;
      console.log(`[Taroto] Fetching comparison table: ${taihi.label} (${taihi.path})`);

      const html = await fetchPage(url);
      const products = parseComparisonPage(html, taihi.manufacturer);
      let added = 0;
      for (const p of products) {
        if (!seenModels.has(p.model_number)) {
          seenModels.add(p.model_number);
          allProducts.push(p);
          added++;
        }
      }

      console.log(`[Taroto] ${taihi.label}: ${products.length} products found, ${added} new`);
    } catch (e) {
      const msg = e instanceof Error ? e.message : String(e);
      errors.push(`Failed comparison page ${taihi.path}: ${msg}`);
    }
  }

  console.log(`[Taroto] Total unique products: ${allProducts.length}`);
  return { products: allProducts, errors };
}

// ---------------------------------------------------------------------------
// Detail page scraping (spec extraction from individual product pages)
// ---------------------------------------------------------------------------


/** Parse detail page HTML to extract spec data from table, description text, and price element */
export function parseDetailPage(html: string): DetailSpec {
  const $ = cheerio.load(html);
  const spec: DetailSpec = {
    width_mm: null, height_mm: null, depth_mm: null,
    pipe_diameter: null, voltage: null, airflow: null,
    noise_level: null, power_consumption: null, list_price: null,
  };

  // --- Source 1: Parse spec table rows (th/td pairs) ---
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
    if (thLower.includes('定価') || thLower.includes('希望小売')) spec.list_price = td;
  });

  // --- Source 2: Parse unstructured text from p.item-description ---
  const descText = $('p.item-description').first().text();
  if (descText) {
    // Split by ● to get individual spec lines
    const lines = descText.split(/[●・]/).map(l => l.trim()).filter(Boolean);

    for (const line of lines) {
      // Pipe diameter: φ100, φ150mm, Φ100
      if (spec.pipe_diameter == null && (line.includes('接続') || line.includes('パイプ') || line.includes('ダクト'))) {
        const pipeMatch = line.match(/[φΦ](\d+)/);
        if (pipeMatch) spec.pipe_diameter = parseInt(pipeMatch[1], 10);
      }

      // Dimensions: WxHxD pattern like "285×285×107mm"
      if (spec.width_mm == null && (line.includes('寸法') || line.includes('外形'))) {
        const dimMatch = line.match(/(\d+)\s*[×xX]\s*(\d+)\s*[×xX]\s*(\d+)/);
        if (dimMatch) {
          spec.width_mm = parseInt(dimMatch[1], 10);
          spec.height_mm = parseInt(dimMatch[2], 10);
          spec.depth_mm = parseInt(dimMatch[3], 10);
        } else {
          // Square dimension: "260mm角"
          const squareMatch = line.match(/(\d+)\s*mm角/);
          if (squareMatch) {
            spec.width_mm = parseInt(squareMatch[1], 10);
            spec.height_mm = parseInt(squareMatch[1], 10);
          }
        }
      }

      // Voltage: 電源 or 電圧
      if (spec.voltage == null && (line.includes('電源') || line.includes('電圧'))) {
        const volMatch = line.match(/[：:]\s*(.+)/);
        if (volMatch) spec.voltage = volMatch[1].trim();
      }

      // Airflow: 風量
      if (spec.airflow == null && line.includes('風量')) {
        const valMatch = line.match(/[：:]\s*(.+)/);
        if (valMatch) spec.airflow = valMatch[1].trim();
      }

      // Noise level: 騒音
      if (spec.noise_level == null && line.includes('騒音')) {
        const valMatch = line.match(/[：:]\s*(.+)/);
        if (valMatch) spec.noise_level = valMatch[1].trim();
      }

      // Power consumption: 消費電力
      if (spec.power_consumption == null && line.includes('消費電力')) {
        const valMatch = line.match(/[：:]\s*(.+)/);
        if (valMatch) spec.power_consumption = valMatch[1].trim();
      }
    }
  }

  // --- Source 3: Parse list price from p.fixed-price ---
  if (spec.list_price == null) {
    const priceText = $('p.fixed-price').first().text().trim();
    if (priceText) {
      // Extract price portion after colon: "希望小売価格：￥22,100（税抜）" → "￥22,100（税抜）"
      const priceMatch = priceText.match(/[：:]\s*(.+)/);
      if (priceMatch) spec.list_price = priceMatch[1].trim();
    }
  }

  return spec;
}

/** Scrape detail pages for existing taroto products to fill in spec data */
export async function scrapeDetailPages(): Promise<{ updated: number; errors: string[] }> {
  return runDetailScraper({
    source: 'taroto',
    parser: parseDetailPage,
  });
}
