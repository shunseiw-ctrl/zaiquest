import 'dotenv/config';
import { createClient } from '@supabase/supabase-js';
import * as cheerio from 'cheerio';

// --- Supabase client ---
const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
if (!SUPABASE_URL || !SUPABASE_KEY) {
  throw new Error('SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required');
}
const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

// --- Constants ---
const DETAIL_URL_BASE =
  'https://www2.panasonic.biz/jp/air/kanki/okikae/detail.php?detail_hinban=';
const DELAY_MS = 2000;

// --- Types ---
interface TargetProduct {
  id: string;
  model_number: string;
}

interface ScrapedSpec {
  airflow: string | null;
  power_consumption: string | null;
  noise_level: string | null;
}

// --- Helper: sleep ---
function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

// --- Step 1: Fetch target products from Supabase ---
async function fetchTargetProducts(): Promise<TargetProduct[]> {
  // tarotoソースのFY-製品でスペックが欠けているもの
  const { data, error } = await supabase
    .from('products')
    .select('id, model_number')
    .eq('source', 'taroto')
    .like('model_number', 'FY-%')
    .or('airflow.is.null,power_consumption.is.null,noise_level.is.null');

  if (error) {
    throw new Error(`Failed to fetch products: ${error.message}`);
  }

  return (data ?? []) as TargetProduct[];
}

// --- Step 2: Scrape detail page ---
async function scrapeDetailPage(modelNumber: string): Promise<ScrapedSpec> {
  const url = `${DETAIL_URL_BASE}${encodeURIComponent(modelNumber)}`;
  const response = await fetch(url);

  if (!response.ok) {
    throw new Error(`HTTP ${response.status} for ${modelNumber}`);
  }

  const html = await response.text();
  const $ = cheerio.load(html);

  const spec: ScrapedSpec = {
    airflow: null,
    power_consumption: null,
    noise_level: null,
  };

  // Parse table rows
  $('table tr').each((_, row) => {
    const cells = $(row).find('td, th');
    if (cells.length < 2) return;

    const label = $(cells[0]).text().trim();
    // 60Hz value is the last non-empty cell, 50Hz is the second
    // Typical structure: label | 50Hz value | 60Hz value
    const values: string[] = [];
    cells.each((i, cell) => {
      if (i > 0) {
        const text = $(cell).text().trim();
        if (text) values.push(text);
      }
    });

    if (values.length === 0) return;

    // Prefer 60Hz (last value), fallback to 50Hz (first value)
    const value60Hz = values.length >= 2 ? values[1] : values[0];
    const value50Hz = values[0];
    const preferredValue = value60Hz || value50Hz;

    if (!preferredValue) return;

    if (label.includes('消費電力')) {
      spec.power_consumption = preferredValue;
    } else if (label.includes('風量')) {
      spec.airflow = preferredValue;
    } else if (label.includes('騒音')) {
      spec.noise_level = preferredValue;
    }
  });

  return spec;
}

// --- Main ---
async function main() {
  console.log('=== Panasonic BIZ スペック補完スクレイパー ===');
  console.log('対象: tarotoソースのFY-型番で、スペック欠損のある製品\n');

  // Step 1: Get target products
  const products = await fetchTargetProducts();
  console.log(`対象製品数: ${products.length}\n`);

  if (products.length === 0) {
    console.log('対象製品がありません。終了します。');
    return;
  }

  let updated = 0;
  let skipped = 0;
  let errors = 0;

  for (let i = 0; i < products.length; i++) {
    const product = products[i];

    try {
      const spec = await scrapeDetailPage(product.model_number);

      // Check if we got any data
      if (!spec.airflow && !spec.power_consumption && !spec.noise_level) {
        skipped++;
        if ((i + 1) % 10 === 0 || i === products.length - 1) {
          console.log(
            `[${i + 1}/${products.length}] 進捗: 更新=${updated}, スキップ=${skipped}, エラー=${errors}`
          );
        }
        await sleep(DELAY_MS);
        continue;
      }

      // Build update object (only non-null fields)
      const updateData: Record<string, string> = {};
      if (spec.airflow) updateData.airflow = spec.airflow;
      if (spec.power_consumption)
        updateData.power_consumption = spec.power_consumption;
      if (spec.noise_level) updateData.noise_level = spec.noise_level;

      const { error: updateError } = await supabase
        .from('products')
        .update(updateData)
        .eq('id', product.id);

      if (updateError) {
        console.error(
          `  [ERROR] DB更新失敗 ${product.model_number}: ${updateError.message}`
        );
        errors++;
      } else {
        updated++;
      }
    } catch (err) {
      const msg = err instanceof Error ? err.message : String(err);
      console.error(`  [ERROR] ${product.model_number}: ${msg}`);
      errors++;
    }

    // Progress log every 10 items
    if ((i + 1) % 10 === 0 || i === products.length - 1) {
      console.log(
        `[${i + 1}/${products.length}] 進捗: 更新=${updated}, スキップ=${skipped}, エラー=${errors}`
      );
    }

    await sleep(DELAY_MS);
  }

  console.log('\n=== 完了 ===');
  console.log(`合計: ${products.length}`);
  console.log(`更新: ${updated}`);
  console.log(`スキップ (データなし): ${skipped}`);
  console.log(`エラー: ${errors}`);
}

main().catch((err) => {
  console.error('Fatal error:', err);
  process.exit(1);
});
