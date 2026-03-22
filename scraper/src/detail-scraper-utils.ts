import { createClient } from '@supabase/supabase-js';
import { DetailSpec } from './types.js';

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

/** Normalize DetailSpec values to database-ready format */
function normalizeSpecForUpdate(spec: DetailSpec): Record<string, unknown> {
  const updateData: Record<string, unknown> = { updated_at: new Date().toISOString() };

  if (spec.width_mm != null) updateData.width_mm = spec.width_mm;
  if (spec.height_mm != null) updateData.height_mm = spec.height_mm;
  if (spec.depth_mm != null) updateData.depth_mm = spec.depth_mm;
  if (spec.pipe_diameter != null) updateData.pipe_diameter = spec.pipe_diameter;
  if (spec.voltage != null) {
    if (spec.voltage.includes('200')) updateData.voltage = 200;
    else if (spec.voltage.includes('100')) updateData.voltage = 100;
  }
  if (spec.airflow != null) {
    const match = spec.airflow.match(/(\d+(\.\d+)?)/);
    if (match) updateData.airflow = parseFloat(match[1]);
  }
  if (spec.noise_level != null) {
    const match = spec.noise_level.match(/(\d+(\.\d+)?)/);
    if (match) updateData.noise_level = parseFloat(match[1]);
  }
  if (spec.power_consumption != null) {
    const match = spec.power_consumption.match(/(\d+(\.\d+)?)/);
    if (match) updateData.power_consumption = parseFloat(match[1]);
  }
  if (spec.list_price != null) {
    const priceMatch = spec.list_price.replace(/[,、]/g, '').match(/(\d+)/);
    if (priceMatch) updateData.list_price = parseInt(priceMatch[1], 10);
  }

  return updateData;
}

/** Generic detail scraper runner */
export async function runDetailScraper(options: {
  source: string;
  parser: (html: string) => DetailSpec;
  delayMs?: number;
}): Promise<{ updated: number; errors: string[] }> {
  const url = process.env.SUPABASE_URL;
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !key) {
    throw new Error('SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required');
  }
  const supabase = createClient(url, key);

  const { data: products, error: fetchError } = await supabase
    .from('products')
    .select('id, model_number, product_url')
    .eq('source', options.source)
    .not('product_url', 'is', null);

  if (fetchError || !products) {
    throw new Error(`Failed to fetch products: ${fetchError?.message}`);
  }

  console.log(`[${options.source} Detail] Found ${products.length} products to process`);
  const errors: string[] = [];
  let updated = 0;
  const delay = options.delayMs ?? DELAY_MS;

  for (let i = 0; i < products.length; i++) {
    const product = products[i];
    try {
      console.log(`[${options.source} Detail] (${i + 1}/${products.length}) ${product.model_number}`);

      // Use custom delay if specified
      if (delay !== DELAY_MS) await sleep(delay - DELAY_MS); // fetchPage already has DELAY_MS
      const html = await fetchPage(product.product_url);
      const spec = options.parser(html);

      const updateData = normalizeSpecForUpdate(spec);

      if (Object.keys(updateData).length > 1) {
        const { error: updateError } = await supabase
          .from('products')
          .update(updateData)
          .eq('id', product.id);

        if (updateError) {
          errors.push(`Update failed for ${product.model_number}: ${updateError.message}`);
        } else {
          updated++;
        }
      }
    } catch (e) {
      const msg = e instanceof Error ? e.message : String(e);
      errors.push(`Detail fetch failed for ${product.model_number}: ${msg}`);
    }
  }

  console.log(`[${options.source} Detail] Updated ${updated}/${products.length} products`);
  return { updated, errors };
}
