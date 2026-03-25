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

// カラーコード・バリエーション記号のパターン（型番末尾に付くもの）
// 注意: FY-17C8 の "-17C8" のような型番本体部分は削らない
// カラーコードは最後のハイフン区切り部分で、1〜3文字のアルファベットのみ
export const COLOR_CODE_PATTERN = /-(W|C|BL|BE|K|S|G|T|WH|CK|FP|D|N|MW|MC|MBL|MBE|MK|MS|MG|MT)$/i;

// --- Types ---
interface TargetProduct {
  id: string;
  model_number: string;
}

export interface ScrapedSpec {
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

// --- Helper: カラーコードを除去してベース型番を取得 ---
export function stripColorCode(modelNumber: string): string | null {
  if (COLOR_CODE_PATTERN.test(modelNumber)) {
    return modelNumber.replace(COLOR_CODE_PATTERN, '');
  }
  return null;
}

// --- Step 2: HTMLからスペックをパース ---
export function parseSpec(html: string): ScrapedSpec {
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

// --- Step 2b: HTMLがデータを含むか判定 ---
export function hasSpecData(spec: ScrapedSpec): boolean {
  return !!(spec.airflow || spec.power_consumption || spec.noise_level);
}

// --- Step 2c: ページをフェッチしてパース（キャッシュ付き） ---
// ベース型番でフェッチした結果をキャッシュして重複フェッチを防ぐ
const fetchCache = new Map<string, ScrapedSpec>();

async function scrapeDetailPage(modelNumber: string): Promise<ScrapedSpec> {
  // キャッシュチェック
  if (fetchCache.has(modelNumber)) {
    return fetchCache.get(modelNumber)!;
  }

  const url = `${DETAIL_URL_BASE}${encodeURIComponent(modelNumber)}`;
  const response = await fetch(url);

  if (!response.ok) {
    throw new Error(`HTTP ${response.status} for ${modelNumber}`);
  }

  const html = await response.text();
  const spec = parseSpec(html);

  fetchCache.set(modelNumber, spec);
  return spec;
}

// --- Step 2d: リトライ付きスクレイプ ---
async function scrapeWithRetry(modelNumber: string): Promise<{ spec: ScrapedSpec; usedModel: string }> {
  // 1. まず元の型番で試行
  const spec = await scrapeDetailPage(modelNumber);
  if (hasSpecData(spec)) {
    return { spec, usedModel: modelNumber };
  }

  // 2. カラーコードを除去してリトライ
  const baseModel = stripColorCode(modelNumber);
  if (baseModel && baseModel !== modelNumber) {
    // キャッシュにあればフェッチ不要（重複バリエーション対策）
    const baseSpec = await scrapeDetailPage(baseModel);
    if (hasSpecData(baseSpec)) {
      return { spec: baseSpec, usedModel: baseModel };
    }
  }

  // 3. どちらもダメ
  return { spec, usedModel: modelNumber };
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
  let cacheHits = 0;

  // 同じベース型番のフェッチ済みセットを追跡（delayスキップ用）
  const fetchedUrls = new Set<string>();

  for (let i = 0; i < products.length; i++) {
    const product = products[i];

    try {
      const { spec, usedModel } = await scrapeWithRetry(product.model_number);

      // キャッシュヒットだった場合はログ
      const wasCached = fetchedUrls.has(usedModel) && usedModel !== product.model_number;
      if (wasCached) cacheHits++;

      // Check if we got any data
      if (!hasSpecData(spec)) {
        skipped++;
        if ((i + 1) % 10 === 0 || i === products.length - 1) {
          console.log(
            `[${i + 1}/${products.length}] 進捗: 更新=${updated}, スキップ=${skipped}, エラー=${errors}, キャッシュヒット=${cacheHits}`
          );
        }
        // キャッシュヒットならdelay不要
        if (!wasCached) {
          fetchedUrls.add(product.model_number);
          await sleep(DELAY_MS);
        }
        continue;
      }

      if (usedModel !== product.model_number) {
        console.log(`  [RETRY OK] ${product.model_number} → ${usedModel} でヒット`);
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

    fetchedUrls.add(product.model_number);

    // Progress log every 10 items
    if ((i + 1) % 10 === 0 || i === products.length - 1) {
      console.log(
        `[${i + 1}/${products.length}] 進捗: 更新=${updated}, スキップ=${skipped}, エラー=${errors}, キャッシュヒット=${cacheHits}`
      );
    }

    await sleep(DELAY_MS);
  }

  console.log('\n=== 完了 ===');
  console.log(`合計: ${products.length}`);
  console.log(`更新: ${updated}`);
  console.log(`スキップ (データなし): ${skipped}`);
  console.log(`エラー: ${errors}`);
  console.log(`キャッシュヒット: ${cacheHits}`);
  console.log(`フェッチキャッシュサイズ: ${fetchCache.size}`);
}

main().catch((err) => {
  console.error('Fatal error:', err);
  process.exit(1);
});
