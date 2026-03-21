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
      'Accept': 'text/html',
    },
  });

  if (!response.ok) {
    throw new Error(`HTTP ${response.status} for ${url}`);
  }

  return response.text();
}

/** Map taroto category names to our category slugs */
function mapCategory(category: string): string | undefined {
  const lower = category.toLowerCase();
  if (lower.includes('換気扇') || lower.includes('パイプファン')) return 'ventilation-fan';
  if (lower.includes('レンジ') || lower.includes('フード')) return 'range-hood';
  if (lower.includes('ダクト')) return 'duct-fan';
  if (lower.includes('浴室') || lower.includes('乾燥')) return 'bathroom-dryer';
  return undefined;
}

/** Map manufacturer names to slugs */
function mapManufacturer(name: string): string {
  const lower = name.toLowerCase();
  if (lower.includes('panasonic') || lower.includes('パナソニック')) return 'panasonic';
  if (lower.includes('三菱') || lower.includes('mitsubishi')) return 'mitsubishi';
  if (lower.includes('東芝') || lower.includes('toshiba')) return 'toshiba';
  return 'taroto'; // fallback
}

export interface TarotoScrapingResult {
  products: RawProduct[];
  errors: string[];
}

/** Scrape taroto.jp ventilation products */
export async function scrapeTaroto(): Promise<TarotoScrapingResult> {
  const products: RawProduct[] = [];
  const errors: string[] = [];

  // Start from the ventilation category listing page
  // taroto.jp typically has table-based product listings with pricing comparisons
  try {
    const html = await fetchPage(`${BASE_URL}/category/ventilation/`);
    const $ = cheerio.load(html);

    // Find product links in the listing
    const productLinks: string[] = [];
    $('a[href*="/product/"]').each((_, el) => {
      const href = $(el).attr('href');
      if (href) {
        const fullUrl = href.startsWith('http') ? href : `${BASE_URL}${href}`;
        if (!productLinks.includes(fullUrl)) {
          productLinks.push(fullUrl);
        }
      }
    });

    console.log(`Found ${productLinks.length} product links on taroto.jp`);

    // Scrape each product detail page
    for (const link of productLinks) {
      try {
        const productHtml = await fetchPage(link);
        const product = parseProductPage(productHtml, link);
        if (product) {
          products.push(product);
        }
      } catch (e) {
        const msg = e instanceof Error ? e.message : String(e);
        errors.push(`Failed to scrape ${link}: ${msg}`);
      }
    }
  } catch (e) {
    const msg = e instanceof Error ? e.message : String(e);
    errors.push(`Failed to load taroto listing: ${msg}`);
  }

  return { products, errors };
}

/** Parse a single taroto product page */
function parseProductPage(html: string, url: string): RawProduct | null {
  const $ = cheerio.load(html);

  // Extract model number from title or header
  const titleText = $('h1, .product-title, .item-title').first().text().trim();
  const modelMatch = titleText.match(/([A-Z]{1,3}[\-\s]?\d{2,}[A-Z\d\-]*)/i);
  if (!modelMatch) return null;

  const modelNumber = modelMatch[1];

  // Extract manufacturer from breadcrumb or product info
  const breadcrumb = $('.breadcrumb, .category-path').text();
  const manufacturerSlug = mapManufacturer(breadcrumb || titleText);

  // Extract spec table
  const specs: Record<string, string> = {};
  $('table.spec-table tr, .product-spec tr, table tr').each((_, row) => {
    const th = $(row).find('th, td:first-child').text().trim();
    const td = $(row).find('td:last-child').text().trim();
    if (th && td && th !== td) {
      specs[th] = td;
    }
  });

  // Extract prices
  const listPriceText =
    specs['メーカー希望小売価格'] || specs['定価'] || specs['希望小売価格'] || '';
  const streetPriceText =
    $('.price, .selling-price, .sale-price').first().text().trim() ||
    specs['販売価格'] || specs['実売価格'] || '';

  // Extract dimensions from spec table
  const widthText = specs['幅'] || specs['W'] || null;
  const heightText = specs['高さ'] || specs['H'] || null;
  const depthText = specs['奥行'] || specs['D'] || null;

  // Try parsing composite dimension string like "W285×H285×D163"
  const dimensionText = specs['外形寸法'] || specs['寸法'] || '';
  let width = widthText;
  let height = heightText;
  let depth = depthText;

  if (dimensionText) {
    const dimMatch = dimensionText.match(
      /W?\s*(\d+)\s*[×x]\s*H?\s*(\d+)\s*[×x]\s*D?\s*(\d+)/i
    );
    if (dimMatch) {
      width = width || dimMatch[1];
      height = height || dimMatch[2];
      depth = depth || dimMatch[3];
    }
  }

  // Extract image
  const imageUrl =
    $('img.product-image, .product-photo img, .main-image img')
      .first()
      .attr('src') || null;

  return {
    model_number: modelNumber,
    name: titleText.replace(modelNumber, '').trim() || titleText,
    manufacturer_slug: manufacturerSlug,
    category_slug: mapCategory(breadcrumb || titleText),
    width_mm: width,
    height_mm: height,
    depth_mm: depth,
    pipe_diameter: specs['接続パイプ径'] || specs['パイプ径'] || null,
    voltage: specs['電圧'] || specs['電源'] || null,
    airflow: specs['風量'] || specs['換気風量'] || null,
    noise_level: specs['騒音'] || specs['騒音値'] || null,
    power_consumption: specs['消費電力'] || null,
    list_price: listPriceText || null,
    street_price: streetPriceText || null,
    product_url: url,
    image_url: imageUrl
      ? imageUrl.startsWith('http')
        ? imageUrl
        : `${BASE_URL}${imageUrl}`
      : null,
    usage: specs['用途'] || null,
    description: null,
    is_discontinued: titleText.includes('廃番') || titleText.includes('生産終了'),
    predecessor_model: specs['後継品'] || specs['後継機種'] || null,
    source: 'taroto',
    source_id: null,
    raw_data: specs,
  };
}
