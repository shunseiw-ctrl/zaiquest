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

/**
 * Extract specs from the kanki-recommend--texts description block.
 * Returns partial raw_data with dimensions (mm) and power consumption.
 */
export function extractSpecsFromDescription(text: string): Record<string, unknown> {
  const specs: Record<string, unknown> = {};

  // 寸法: 高さ17.5×幅17×奥行4.5cm → mm換算
  const dimMatch = text.match(/高さ([\d.]+)×幅([\d.]+)×奥行([\d.]+)\s*cm/);
  if (dimMatch) {
    specs.height_mm = Math.round(parseFloat(dimMatch[1]) * 10);
    specs.width_mm = Math.round(parseFloat(dimMatch[2]) * 10);
    specs.depth_mm = Math.round(parseFloat(dimMatch[3]) * 10);
  }

  // 消費電力: 消費電力(50/60Hz) 強1.9/2.2W 弱1.4/1.5W
  const powerMatch = text.match(/消費電力[^●]*?([\d.]+)\/([\d.]+)\s*W/);
  if (powerMatch) {
    specs.power_consumption_50hz = `${powerMatch[1]}W`;
    specs.power_consumption_60hz = `${powerMatch[2]}W`;
  }

  return specs;
}

/**
 * Parse a Panasonic ventilation category list page.
 * Extracts products from `ul.kanki-recommend__block > li` structure.
 */
export function parsePanasonicListPage(html: string, categoryPath: string): RawProduct[] {
  const $ = cheerio.load(html);
  const products: RawProduct[] = [];

  $('.kanki-recommend__block li').each((_, el) => {
    try {
      const $li = $(el);

      // モデル番号: dt テキストから FY- で始まる型番を正規表現抽出
      const dtText = $li.find('dt').text().trim();
      const modelMatch = dtText.match(/(FY-[\w]+)/);
      if (!modelMatch) return;

      const modelNumber = modelMatch[1];

      // 製品名: dt 内の span テキスト（カテゴリ名）+ モデル番号
      const spanText = $li.find('dt span').text().trim();
      const name = spanText ? `${spanText} ${modelNumber}` : modelNumber;

      // 画像URL
      const imgSrc = $li.find('img[alt="写真"]').attr('src') || $li.find('img').first().attr('src');
      const imageUrl = imgSrc
        ? (imgSrc.startsWith('http') ? imgSrc : `${BASE_URL}${imgSrc}`)
        : null;

      // 詳細リンク
      const href = $li.find('a').first().attr('href');
      const productUrl = href
        ? (href.startsWith('http') ? href : `${BASE_URL}${href}`)
        : `${BASE_URL}${categoryPath}`;

      // 説明文からスペック抽出
      const descText = $li.find('.kanki-recommend--texts').text().trim();
      const rawData = descText ? extractSpecsFromDescription(descText) : {};
      if (descText) {
        rawData.description = descText;
      }

      products.push({
        model_number: modelNumber,
        name,
        manufacturer_slug: 'panasonic',
        category_slug: mapCategory(spanText || categoryPath),
        image_url: imageUrl,
        product_url: productUrl,
        source: 'panasonic_biz',
        source_id: null,
        raw_data: Object.keys(rawData).length > 0 ? rawData : null,
      });
    } catch {
      // Skip unparseable items
    }
  });

  return products;
}

/** Scrape Panasonic Biz ventilation products */
export async function scrapePanasonic(): Promise<PanasonicScrapingResult> {
  const products: RawProduct[] = [];
  const errors: string[] = [];

  // Panasonic Biz ventilation product category pages
  const categoryUrls = [
    '/air/kanki/pipe/',        // パイプファン
    '/air/kanki/tenume/',      // 天埋換気扇
    '/air/kanki/rangehood/',   // レンジフード
    '/air/kanki/bathkan/',     // 浴室換気乾燥機
  ];

  for (const categoryPath of categoryUrls) {
    try {
      const html = await fetchPage(`${BASE_URL}${categoryPath}`);
      const parsed = parsePanasonicListPage(html, categoryPath);
      products.push(...parsed);
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
