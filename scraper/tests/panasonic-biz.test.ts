import { describe, it, expect, vi, beforeAll } from 'vitest';

// Mock env vars before any imports that read them
beforeAll(() => {
  process.env.SUPABASE_URL = 'https://fake.supabase.co';
  process.env.SUPABASE_SERVICE_ROLE_KEY = 'fake-key';
});

// Mock @supabase/supabase-js to avoid real client creation
// Return a stub that satisfies the chained call in main(): supabase.from().select().eq().like().or()
vi.mock('@supabase/supabase-js', () => {
  const chainable = (): Record<string, unknown> => {
    const obj: Record<string, unknown> = {};
    for (const method of ['from', 'select', 'eq', 'like', 'or', 'update', 'insert']) {
      obj[method] = vi.fn(() => ({ ...obj, data: [], error: null }));
    }
    return obj;
  };
  return {
    createClient: vi.fn(() => chainable()),
  };
});

// Now import the functions under test
const { stripColorCode, parseSpec, hasSpecData, COLOR_CODE_PATTERN } =
  await import('../src/scrape-panasonic-biz.js');

// ---------------------------------------------------------------------------
// stripColorCode
// ---------------------------------------------------------------------------
describe('stripColorCode', () => {
  it('returns base model when color code present (e.g., -W)', () => {
    expect(stripColorCode('FY-17J8-W')).toBe('FY-17J8');
  });

  it('returns null when no color code (e.g., FY-17C8)', () => {
    expect(stripColorCode('FY-17C8')).toBeNull();
  });

  it('handles multi-char codes like -BL', () => {
    expect(stripColorCode('FY-24BM8-BL')).toBe('FY-24BM8');
  });

  it('handles multi-char codes like -MBL', () => {
    expect(stripColorCode('FY-24BM8-MBL')).toBe('FY-24BM8');
  });

  it('does NOT strip real model number parts', () => {
    // "-17C8" contains "C" but is part of the model, not a trailing color code
    expect(stripColorCode('FY-17C8')).toBeNull();
    // Model ending with digits should not match
    expect(stripColorCode('FY-08PFRY9VD')).toBeNull();
  });
});

// ---------------------------------------------------------------------------
// parseSpec
// ---------------------------------------------------------------------------
describe('parseSpec', () => {
  it('extracts airflow, power_consumption, noise_level from typical table HTML', () => {
    const html = `<html><body>
      <table>
        <tr><th>風量</th><td>80m³/h</td></tr>
        <tr><th>消費電力</th><td>3.5W</td></tr>
        <tr><th>騒音</th><td>25.5dB</td></tr>
      </table>
    </body></html>`;

    const spec = parseSpec(html);
    expect(spec.airflow).toBe('80m³/h');
    expect(spec.power_consumption).toBe('3.5W');
    expect(spec.noise_level).toBe('25.5dB');
  });

  it('returns all nulls for empty HTML', () => {
    const spec = parseSpec('<html><body></body></html>');
    expect(spec.airflow).toBeNull();
    expect(spec.power_consumption).toBeNull();
    expect(spec.noise_level).toBeNull();
  });

  it('prefers 60Hz value when both 50/60Hz present', () => {
    const html = `<html><body>
      <table>
        <tr><th>風量</th><td>70m³/h</td><td>85m³/h</td></tr>
        <tr><th>消費電力</th><td>3.0W</td><td>3.5W</td></tr>
        <tr><th>騒音</th><td>23dB</td><td>26dB</td></tr>
      </table>
    </body></html>`;

    const spec = parseSpec(html);
    // 60Hz (second value = index 1) should be preferred
    expect(spec.airflow).toBe('85m³/h');
    expect(spec.power_consumption).toBe('3.5W');
    expect(spec.noise_level).toBe('26dB');
  });
});

// ---------------------------------------------------------------------------
// hasSpecData
// ---------------------------------------------------------------------------
describe('hasSpecData', () => {
  it('returns true when at least one field present', () => {
    expect(hasSpecData({ airflow: '80m³/h', power_consumption: null, noise_level: null })).toBe(true);
    expect(hasSpecData({ airflow: null, power_consumption: '3.5W', noise_level: null })).toBe(true);
    expect(hasSpecData({ airflow: null, power_consumption: null, noise_level: '25dB' })).toBe(true);
  });

  it('returns false when all null', () => {
    expect(hasSpecData({ airflow: null, power_consumption: null, noise_level: null })).toBe(false);
  });
});

// ---------------------------------------------------------------------------
// COLOR_CODE_PATTERN (sanity check)
// ---------------------------------------------------------------------------
describe('COLOR_CODE_PATTERN', () => {
  it('matches known color codes at end of string', () => {
    expect(COLOR_CODE_PATTERN.test('FY-17J8-W')).toBe(true);
    expect(COLOR_CODE_PATTERN.test('FY-24BM8-BL')).toBe(true);
    expect(COLOR_CODE_PATTERN.test('FY-24BM8-MBL')).toBe(true);
  });

  it('does not match model numbers without color codes', () => {
    expect(COLOR_CODE_PATTERN.test('FY-17C8')).toBe(false);
    expect(COLOR_CODE_PATTERN.test('FY-08PFRY9VD')).toBe(false);
  });
});
