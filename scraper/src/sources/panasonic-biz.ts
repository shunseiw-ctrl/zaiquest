import * as cheerio from 'cheerio';
import { RawProduct } from '../normalizer.js';

const BIZ_BASE = 'https://www2.panasonic.biz/jp/air/kanki/okikae';
const DELAY_MS = 2000;

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

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

export interface PanasonicBizScrapingResult {
  products: RawProduct[];
  errors: string[];
}

/** Extract all FY- model numbers from the list page */
function parseListPage(html: string): string[] {
  const $ = cheerio.load(html);
  const modelNumbers: string[] = [];
  const seen = new Set<string>();

  // Primary selector: links containing detail_hinban parameter
  $('a[href*="detail_hinban"]').each((_, el) => {
    const href = $(el).attr('href') || '';
    const match = href.match(/detail_hinban=([A-Z0-9\-]+)/i);
    if (match) {
      const model = match[1].toUpperCase().trim();
      if (!seen.has(model)) {
        seen.add(model);
        modelNumbers.push(model);
      }
    }
  });

  // Fallback: also extract from text content if href parsing missed some
  if (modelNumbers.length === 0) {
    $('li').each((_, el) => {
      const text = $(el).text().trim();
      const match = text.match(/^(FY-[A-Z0-9\-]+)/i);
      if (match) {
        const model = match[1].toUpperCase().trim();
        if (!seen.has(model)) {
          seen.add(model);
          modelNumbers.push(model);
        }
      }
    });
  }

  return modelNumbers;
}

interface DetailSpec {
  listPrice: string | null;
  powerConsumption50: string | null;
  powerConsumption60: string | null;
  airflow50: string | null;
  airflow60: string | null;
  noiseLevel50: string | null;
  noiseLevel60: string | null;
  successorModel: string | null;
  remarks: string | null;
}

/** Parse a detail page and extract spec data */
function parseDetailPage(html: string): DetailSpec {
  const $ = cheerio.load(html);
  const spec: DetailSpec = {
    listPrice: null,
    powerConsumption50: null,
    powerConsumption60: null,
    airflow50: null,
    airflow60: null,
    noiseLevel50: null,
    noiseLevel60: null,
    successorModel: null,
    remarks: null,
  };

  // Extract specs from table rows (th/td pairs)
  $('table tr').each((_, row) => {
    const th = $(row).find('th').first().text().trim();
    const td = $(row).find('td').first().text().trim();
    if (!th || !td) return;

    if (th.includes('希望小売価格') || th.includes('本体希望') || th.includes('価格')) {
      // Extract numeric price: "12,345円" → "12345"
      const priceMatch = td.match(/([0-9,]+)\s*円/);
      if (priceMatch) spec.listPrice = priceMatch[1].replace(/,/g, '');
    }

    if (th.includes('消費電力')) {
      // May have 50Hz/60Hz values
      const match50 = td.match(/50Hz[：:\s]*([0-9.]+)/);
      const match60 = td.match(/60Hz[：:\s]*([0-9.]+)/);
      if (match50) spec.powerConsumption50 = match50[1];
      if (match60) spec.powerConsumption60 = match60[1];
      // Single value fallback
      if (!match50 && !match60) {
        const single = td.match(/([0-9.]+)\s*W/);
        if (single) {
          spec.powerConsumption50 = single[1];
          spec.powerConsumption60 = single[1];
        }
      }
    }

    if (th.includes('風量')) {
      const match50 = td.match(/50Hz[：:\s]*([0-9.]+)/);
      const match60 = td.match(/60Hz[：:\s]*([0-9.]+)/);
      if (match50) spec.airflow50 = match50[1];
      if (match60) spec.airflow60 = match60[1];
      if (!match50 && !match60) {
        const single = td.match(/([0-9.]+)/);
        if (single) {
          spec.airflow50 = single[1];
          spec.airflow60 = single[1];
        }
      }
    }

    if (th.includes('騒音')) {
      const match50 = td.match(/50Hz[：:\s]*([0-9.]+)/);
      const match60 = td.match(/60Hz[：:\s]*([0-9.]+)/);
      if (match50) spec.noiseLevel50 = match50[1];
      if (match60) spec.noiseLevel60 = match60[1];
      if (!match50 && !match60) {
        const single = td.match(/([0-9.]+)/);
        if (single) {
          spec.noiseLevel50 = single[1];
          spec.noiseLevel60 = single[1];
        }
      }
    }

    if (th.includes('後継') || th.includes('代替')) {
      const modelMatch = td.match(/(FY-[A-Z0-9\-]+)/i);
      if (modelMatch) spec.successorModel = modelMatch[1].toUpperCase();
    }

    if (th.includes('備考') || th.includes('商品名') || th.includes('品名')) {
      spec.remarks = td;
    }
  });

  // Also check definition lists
  $('dt').each((_, dt) => {
    const label = $(dt).text().trim();
    const dd = $(dt).next('dd');
    const value = dd.text().trim();
    if (!label || !value) return;

    if (label.includes('後継') && !spec.successorModel) {
      const modelMatch = value.match(/(FY-[A-Z0-9\-]+)/i);
      if (modelMatch) spec.successorModel = modelMatch[1].toUpperCase();
    }
  });

  // Check for successor in body text
  if (!spec.successorModel) {
    const bodyText = $('body').text();
    const successorMatch = bodyText.match(/後継[品機種]*[：:\s]*(FY-[A-Z0-9\-]+)/i);
    if (successorMatch) spec.successorModel = successorMatch[1].toUpperCase();
  }

  return spec;
}

/** Scrape Panasonic biz site for ventilation products */
export async function scrapePanasonicBiz(options?: {
  /** Skip model numbers already in DB (pass the set of known models) */
  skipModels?: Set<string>;
  /** Max detail pages to fetch (0 = unlimited) */
  maxDetails?: number;
  /** Resume from this model number (skip until we reach it) */
  resumeFrom?: string;
}): Promise<PanasonicBizScrapingResult> {
  const products: RawProduct[] = [];
  const errors: string[] = [];
  const skipModels = options?.skipModels ?? new Set<string>();
  const maxDetails = options?.maxDetails ?? 0;
  const resumeFrom = options?.resumeFrom ?? null;

  // Step 1: Fetch all model numbers from list page
  console.log('[Panasonic Biz] Fetching model list from result.php...');
  let allModels: string[];
  try {
    const listHtml = await fetchPage(`${BIZ_BASE}/result.php?search_hinban=FY-`);
    allModels = parseListPage(listHtml);
    console.log(`[Panasonic Biz] Found ${allModels.length} model numbers on list page`);
  } catch (e) {
    const msg = e instanceof Error ? e.message : String(e);
    return { products, errors: [`Failed to fetch list page: ${msg}`] };
  }

  if (allModels.length === 0) {
    return { products, errors: ['No model numbers found on list page — HTML structure may have changed'] };
  }

  // Filter out already-known models
  const modelsToFetch = allModels.filter((m) => !skipModels.has(m));
  console.log(`[Panasonic Biz] Models to fetch details: ${modelsToFetch.length} (skipping ${allModels.length - modelsToFetch.length} known)`);

  // Handle resume
  let startIdx = 0;
  if (resumeFrom) {
    const idx = modelsToFetch.indexOf(resumeFrom);
    if (idx >= 0) {
      startIdx = idx;
      console.log(`[Panasonic Biz] Resuming from ${resumeFrom} (index ${startIdx})`);
    }
  }

  // Step 2: Fetch detail pages
  const limit = maxDetails > 0 ? Math.min(startIdx + maxDetails, modelsToFetch.length) : modelsToFetch.length;

  for (let i = startIdx; i < limit; i++) {
    const model = modelsToFetch[i];

    if (i > startIdx && i % 100 === 0) {
      console.log(`[Panasonic Biz] Progress: ${i}/${limit} (${((i / limit) * 100).toFixed(1)}%)`);
    }

    try {
      const detailUrl = `${BIZ_BASE}/detail.php?detail_hinban=${encodeURIComponent(model)}`;
      const detailHtml = await fetchPage(detailUrl);
      const spec = parseDetailPage(detailHtml);

      const isDiscontinued = spec.successorModel != null;

      // Use 50Hz values as primary (eastern Japan standard)
      products.push({
        model_number: model,
        name: spec.remarks || `パナソニック ${model}`,
        manufacturer_slug: 'panasonic',
        list_price: spec.listPrice ?? null,
        power_consumption: spec.powerConsumption50 ?? null,
        airflow: spec.airflow50 ?? null,
        noise_level: spec.noiseLevel50 ?? null,
        is_discontinued: isDiscontinued,
        predecessor_model: spec.successorModel ?? null,
        product_url: `${BIZ_BASE}/detail.php?detail_hinban=${encodeURIComponent(model)}`,
        source: 'panasonic_biz',
        source_id: model,
        raw_data: {
          power_consumption_50hz: spec.powerConsumption50,
          power_consumption_60hz: spec.powerConsumption60,
          airflow_50hz: spec.airflow50,
          airflow_60hz: spec.airflow60,
          noise_level_50hz: spec.noiseLevel50,
          noise_level_60hz: spec.noiseLevel60,
          remarks: spec.remarks,
        },
      });
    } catch (e) {
      const msg = e instanceof Error ? e.message : String(e);
      errors.push(`${model}: ${msg}`);
      // Log periodically
      if (errors.length <= 10 || errors.length % 50 === 0) {
        console.warn(`[Panasonic Biz] Error for ${model}: ${msg}`);
      }
    }
  }

  console.log(`[Panasonic Biz] Completed: ${products.length} products, ${errors.length} errors`);
  return { products, errors };
}
