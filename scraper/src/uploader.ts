import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { NormalizedProduct } from './normalizer.js';

let client: SupabaseClient | null = null;

function getClient(): SupabaseClient {
  if (!client) {
    const url = process.env.SUPABASE_URL;
    const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
    if (!url || !key) {
      throw new Error('SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required');
    }
    client = createClient(url, key);
  }
  return client;
}

/** Resolve manufacturer slug to UUID */
async function getManufacturerId(slug: string): Promise<string> {
  const supabase = getClient();
  const { data, error } = await supabase
    .from('manufacturers')
    .select('id')
    .eq('slug', slug)
    .single();

  if (error || !data) {
    throw new Error(`Manufacturer not found: ${slug}`);
  }
  return data.id;
}

/** Resolve category slug to UUID (optional) */
async function getCategoryId(slug?: string): Promise<string | null> {
  if (!slug) return null;
  const supabase = getClient();
  const { data } = await supabase
    .from('categories')
    .select('id')
    .eq('slug', slug)
    .single();

  return data?.id ?? null;
}

export interface UploadResult {
  total: number;
  inserted: number;
  updated: number;
  errors: number;
}

/** Upsert normalized products to Supabase */
export async function uploadProducts(
  products: NormalizedProduct[]
): Promise<UploadResult> {
  const supabase = getClient();
  const result: UploadResult = {
    total: products.length,
    inserted: 0,
    updated: 0,
    errors: 0,
  };

  // Resolve slugs to IDs (batch by unique slugs)
  const manufacturerMap = new Map<string, string>();
  const categoryMap = new Map<string, string>();

  for (const p of products) {
    if (!manufacturerMap.has(p.manufacturer_slug)) {
      try {
        manufacturerMap.set(p.manufacturer_slug, await getManufacturerId(p.manufacturer_slug));
      } catch (e) {
        console.error(`Failed to resolve manufacturer: ${p.manufacturer_slug}`, e);
      }
    }
    if (p.category_slug && !categoryMap.has(p.category_slug)) {
      const id = await getCategoryId(p.category_slug);
      if (id) categoryMap.set(p.category_slug, id);
    }
  }

  // Upsert in batches of 100
  const batchSize = 100;
  for (let i = 0; i < products.length; i += batchSize) {
    const batch = products.slice(i, i + batchSize);
    const rows = batch
      .filter((p) => manufacturerMap.has(p.manufacturer_slug))
      .map((p) => ({
        model_number: p.model_number,
        name: p.name,
        manufacturer_id: manufacturerMap.get(p.manufacturer_slug),
        category_id: p.category_slug ? categoryMap.get(p.category_slug) ?? null : null,
        width_mm: p.width_mm,
        height_mm: p.height_mm,
        depth_mm: p.depth_mm,
        pipe_diameter: p.pipe_diameter,
        voltage: p.voltage,
        airflow: p.airflow,
        noise_level: p.noise_level,
        power_consumption: p.power_consumption,
        list_price: p.list_price,
        street_price: p.street_price,
        product_url: p.product_url,
        image_url: p.image_url,
        usage: p.usage,
        description: p.description,
        is_discontinued: p.is_discontinued,
        predecessor_model: p.predecessor_model,
        source: p.source,
        source_id: p.source_id,
        raw_data: p.raw_data,
        updated_at: new Date().toISOString(),
      }));

    const { error, count } = await supabase
      .from('products')
      .upsert(rows, {
        onConflict: 'source,model_number',
        count: 'exact',
      });

    if (error) {
      console.error(`Batch upsert error at ${i}:`, error.message);
      result.errors += batch.length;
    } else {
      result.inserted += count ?? rows.length;
    }
  }

  return result;
}
