export interface RawProduct {
  model_number: string;
  name: string;
  manufacturer_slug: string;
  category_slug?: string;
  width_mm?: number | string | null;
  height_mm?: number | string | null;
  depth_mm?: number | string | null;
  pipe_diameter?: number | string | null;
  voltage?: number | string | null;
  airflow?: number | string | null;
  noise_level?: number | string | null;
  power_consumption?: number | string | null;
  list_price?: number | string | null;
  street_price?: number | string | null;
  product_url?: string | null;
  image_url?: string | null;
  usage?: string | null;
  description?: string | null;
  is_discontinued?: boolean;
  predecessor_model?: string | null;
  source: string;
  source_id?: string | null;
  raw_data?: Record<string, unknown> | null;
}

export interface NormalizedProduct {
  model_number: string;
  name: string;
  manufacturer_slug: string;
  category_slug?: string;
  width_mm: number | null;
  height_mm: number | null;
  depth_mm: number | null;
  pipe_diameter: number | null;
  voltage: number | null;
  airflow: number | null;
  noise_level: number | null;
  power_consumption: number | null;
  list_price: number | null;
  street_price: number | null;
  product_url: string | null;
  image_url: string | null;
  usage: string | null;
  description: string | null;
  is_discontinued: boolean;
  predecessor_model: string | null;
  source: string;
  source_id: string | null;
  raw_data: Record<string, unknown> | null;
}

/** Parse a numeric value, stripping commas and units */
function parseNumeric(value: number | string | null | undefined): number | null {
  if (value == null) return null;
  if (typeof value === 'number') return value;
  // Extract the first numeric value (with optional decimal) from the string
  const cleaned = value.replace(/[,、]/g, '');
  const match = cleaned.match(/-?\d+(\.\d+)?/);
  if (!match) return null;
  const num = parseFloat(match[0]);
  return isNaN(num) ? null : num;
}

/** Parse integer (for prices) */
function parseIntValue(value: number | string | null | undefined): number | null {
  const num = parseNumeric(value);
  return num != null ? Math.round(num) : null;
}

/** Parse voltage, normalizing common formats */
function parseVoltage(value: number | string | null | undefined): number | null {
  if (value == null) return null;
  if (typeof value === 'number') return value;
  const str = value.toLowerCase();
  if (str.includes('200')) return 200;
  if (str.includes('100')) return 100;
  return parseIntValue(value);
}

export function normalize(raw: RawProduct): NormalizedProduct {
  return {
    model_number: raw.model_number.trim().toUpperCase(),
    name: raw.name.trim(),
    manufacturer_slug: raw.manufacturer_slug,
    category_slug: raw.category_slug,
    width_mm: parseNumeric(raw.width_mm),
    height_mm: parseNumeric(raw.height_mm),
    depth_mm: parseNumeric(raw.depth_mm),
    pipe_diameter: parseNumeric(raw.pipe_diameter),
    voltage: parseVoltage(raw.voltage),
    airflow: parseNumeric(raw.airflow),
    noise_level: parseNumeric(raw.noise_level),
    power_consumption: parseNumeric(raw.power_consumption),
    list_price: parseIntValue(raw.list_price),
    street_price: parseIntValue(raw.street_price),
    product_url: raw.product_url?.trim() || null,
    image_url: raw.image_url?.trim() || null,
    usage: raw.usage?.trim() || null,
    description: raw.description?.trim() || null,
    is_discontinued: raw.is_discontinued ?? false,
    predecessor_model: raw.predecessor_model?.trim() || null,
    source: raw.source,
    source_id: raw.source_id?.trim() || null,
    raw_data: raw.raw_data ?? null,
  };
}
