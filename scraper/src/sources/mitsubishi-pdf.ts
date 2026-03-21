import { RawProduct } from '../normalizer.js';

const CLAUDE_API_URL = 'https://api.anthropic.com/v1/messages';

export interface MitsubishiPdfResult {
  products: RawProduct[];
  errors: string[];
}

interface ClaudeProduct {
  model_number: string;
  name: string;
  width_mm?: number;
  height_mm?: number;
  depth_mm?: number;
  pipe_diameter?: number;
  voltage?: number;
  airflow?: number;
  noise_level?: number;
  power_consumption?: number;
  list_price?: number;
  usage?: string;
  is_discontinued?: boolean;
  predecessor_model?: string;
}

/** Parse Mitsubishi PDF catalog using Claude API (Haiku) */
export async function parseMitsubishiPdf(
  pdfBase64: string,
  filename: string
): Promise<MitsubishiPdfResult> {
  const products: RawProduct[] = [];
  const errors: string[] = [];

  const apiKey = process.env.CLAUDE_API_KEY;
  if (!apiKey) {
    return { products, errors: ['CLAUDE_API_KEY not set'] };
  }

  try {
    const response = await fetch(CLAUDE_API_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: JSON.stringify({
        model: 'claude-haiku-4-5-20251001',
        max_tokens: 4096,
        messages: [
          {
            role: 'user',
            content: [
              {
                type: 'document',
                source: {
                  type: 'base64',
                  media_type: 'application/pdf',
                  data: pdfBase64,
                },
              },
              {
                type: 'text',
                text: `このPDFは三菱電機の換気扇カタログです。各商品の情報を以下のJSON配列として抽出してください。

各商品について以下のフィールドを抽出:
- model_number: 型番 (例: VD-15ZC14)
- name: 商品名
- width_mm: 幅 (mm, 数値)
- height_mm: 高さ (mm, 数値)
- depth_mm: 奥行 (mm, 数値)
- pipe_diameter: 接続パイプ径 (mm, 数値)
- voltage: 電圧 (100 or 200)
- airflow: 風量 (m3/h, 数値)
- noise_level: 騒音 (dB, 数値)
- power_consumption: 消費電力 (W, 数値)
- list_price: 希望小売価格 (円, 数値, 税抜)
- usage: 用途
- is_discontinued: 廃番かどうか (boolean)
- predecessor_model: 後継機種の型番

JSON配列のみを返してください。説明文は不要です。`,
              },
            ],
          },
        ],
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      errors.push(`Claude API error: ${response.status} - ${errorText}`);
      return { products, errors };
    }

    const data = await response.json();
    const content = data.content?.[0]?.text;

    if (!content) {
      errors.push('Empty response from Claude API');
      return { products, errors };
    }

    // Extract JSON from response (may be wrapped in markdown code block)
    const jsonMatch = content.match(/\[[\s\S]*\]/);
    if (!jsonMatch) {
      errors.push('No JSON array found in Claude response');
      return { products, errors };
    }

    const parsed: ClaudeProduct[] = JSON.parse(jsonMatch[0]);

    for (const item of parsed) {
      if (!item.model_number) continue;

      products.push({
        model_number: item.model_number,
        name: item.name || item.model_number,
        manufacturer_slug: 'mitsubishi',
        width_mm: item.width_mm ?? null,
        height_mm: item.height_mm ?? null,
        depth_mm: item.depth_mm ?? null,
        pipe_diameter: item.pipe_diameter ?? null,
        voltage: item.voltage ?? null,
        airflow: item.airflow ?? null,
        noise_level: item.noise_level ?? null,
        power_consumption: item.power_consumption ?? null,
        list_price: item.list_price ?? null,
        usage: item.usage ?? null,
        is_discontinued: item.is_discontinued ?? false,
        predecessor_model: item.predecessor_model ?? null,
        source: 'mitsubishi_pdf',
        source_id: filename,
        raw_data: item as unknown as Record<string, unknown>,
      });
    }
  } catch (e) {
    const msg = e instanceof Error ? e.message : String(e);
    errors.push(`PDF parsing error: ${msg}`);
  }

  return { products, errors };
}
