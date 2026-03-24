import { createClient } from '@supabase/supabase-js';

/** Cross-reference specs between manufacturer sources and taroto */
export async function crossReferenceSpecs(): Promise<{ merged: number; errors: string[] }> {
  const url = process.env.SUPABASE_URL;
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !key) {
    throw new Error('SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required');
  }
  const supabase = createClient(url, key);

  // Get taroto products with missing spec data
  const { data: tarotoProducts, error: tarotoError } = await supabase
    .from('products')
    .select('id, model_number, voltage, airflow, noise_level, power_consumption, width_mm, height_mm, depth_mm, pipe_diameter, list_price')
    .eq('source', 'taroto');

  if (tarotoError || !tarotoProducts) {
    throw new Error(`Failed to fetch taroto products: ${tarotoError?.message}`);
  }

  // Get manufacturer products (toshiba + panasonic) with spec data
  const { data: mfgProducts, error: mfgError } = await supabase
    .from('products')
    .select('model_number, voltage, airflow, noise_level, power_consumption, width_mm, height_mm, depth_mm, pipe_diameter, list_price')
    .in('source', ['toshiba', 'panasonic_biz', 'mitsubishi_pdf', 'mitsubishi_wink']);

  if (mfgError || !mfgProducts) {
    throw new Error(`Failed to fetch manufacturer products: ${mfgError?.message}`);
  }

  // Build lookup map by model_number
  const mfgMap = new Map<string, typeof mfgProducts[0]>();
  for (const p of mfgProducts) {
    mfgMap.set(p.model_number.toUpperCase(), p);
  }

  console.log(`[CrossRef] ${tarotoProducts.length} taroto products, ${mfgProducts.length} manufacturer products`);

  const errors: string[] = [];
  let merged = 0;
  const specFields = ['voltage', 'airflow', 'noise_level', 'power_consumption', 'width_mm', 'height_mm', 'depth_mm', 'pipe_diameter', 'list_price'] as const;

  for (const taroto of tarotoProducts) {
    const mfg = mfgMap.get(taroto.model_number.toUpperCase());
    if (!mfg) continue;

    // Find fields that are null in taroto but non-null in manufacturer data
    const updateData: Record<string, unknown> = {};
    for (const field of specFields) {
      if (taroto[field] == null && mfg[field] != null) {
        updateData[field] = mfg[field];
      }
    }

    if (Object.keys(updateData).length > 0) {
      updateData.updated_at = new Date().toISOString();
      const { error } = await supabase
        .from('products')
        .update(updateData)
        .eq('id', taroto.id);

      if (error) {
        errors.push(`Merge failed for ${taroto.model_number}: ${error.message}`);
      } else {
        merged++;
        console.log(`[CrossRef] Merged ${Object.keys(updateData).length - 1} fields for ${taroto.model_number}`);
      }
    }
  }

  console.log(`[CrossRef] Merged specs for ${merged} products`);
  return { merged, errors };
}
