import { describe, it, expect } from 'vitest';
import { parseToshibaDetailPage } from '../src/sources/toshiba.js';

// We need to test parseCategoryPage. It's not currently exported,
// so we test the scraper's output format expectations.
// For now, we import the module to verify it loads correctly.

describe('toshiba scraper', () => {
  it('module loads without errors', async () => {
    const mod = await import('../src/sources/toshiba.js');
    expect(mod.scrapeToshiba).toBeDefined();
  });

  describe('model number patterns', () => {
    // Test the regex pattern used by the scraper
    const modelRegex = /^([A-Z]{2,5}-\d{1,5}[A-Z\d\-()（）]*)/i;

    it('matches standard Toshiba model numbers', () => {
      expect('VFP-8W5'.match(modelRegex)?.[1]).toBe('VFP-8W5');
      expect('VFR-63LJB(K)'.match(modelRegex)?.[1]).toBe('VFR-63LJB(K)');
      expect('VFH-20H2'.match(modelRegex)?.[1]).toBe('VFH-20H2');
      expect('DVB-18S4'.match(modelRegex)?.[1]).toBe('DVB-18S4');
    });

    it('does not match non-model text', () => {
      expect('パイプファン'.match(modelRegex)).toBeNull();
      expect('製品一覧'.match(modelRegex)).toBeNull();
    });

    it('extracts pipe diameter from description', () => {
      const pipeRegex = /[φΦ](\d+)/;
      expect('φ100mm パイプファン'.match(pipeRegex)?.[1]).toBe('100');
      expect('Φ150 ダクト'.match(pipeRegex)?.[1]).toBe('150');
      expect('径不明'.match(pipeRegex)).toBeNull();
    });
  });
});

describe('parseToshibaDetailPage', () => {
  it('should extract specs from table rows', () => {
    const html = `<html><body>
      <table>
        <tr><th>外形寸法</th><td>260×260×107mm</td></tr>
        <tr><th>パイプ径</th><td>φ100mm</td></tr>
        <tr><th>電源</th><td>単相100V</td></tr>
        <tr><th>風量</th><td>95m³/h</td></tr>
        <tr><th>騒音</th><td>28dB</td></tr>
        <tr><th>消費電力</th><td>4.2W</td></tr>
        <tr><th>希望小売価格</th><td>12,000円</td></tr>
      </table>
    </body></html>`;

    const spec = parseToshibaDetailPage(html);
    expect(spec.width_mm).toBe(260);
    expect(spec.height_mm).toBe(260);
    expect(spec.depth_mm).toBe(107);
    expect(spec.pipe_diameter).toBe(100);
    expect(spec.voltage).toBe('単相100V');
    expect(spec.airflow).toBe('95m³/h');
    expect(spec.noise_level).toBe('28dB');
    expect(spec.power_consumption).toBe('4.2W');
    expect(spec.list_price).toBe('12,000円');
  });

  it('should return all nulls for empty HTML', () => {
    const spec = parseToshibaDetailPage('<html><body></body></html>');
    expect(spec.width_mm).toBeNull();
    expect(spec.voltage).toBeNull();
    expect(spec.airflow).toBeNull();
  });

  it('should extract from dl/dt/dd structure', () => {
    const html = `<html><body>
      <dl>
        <dt>電源</dt><dd>AC100V 50/60Hz</dd>
        <dt>風量</dt><dd>120 m³/h</dd>
        <dt>騒音</dt><dd>32 dB</dd>
      </dl>
    </body></html>`;

    const spec = parseToshibaDetailPage(html);
    expect(spec.voltage).toBe('AC100V 50/60Hz');
    expect(spec.airflow).toBe('120 m³/h');
    expect(spec.noise_level).toBe('32 dB');
  });

  it('should extract partial data', () => {
    const html = `<html><body>
      <table>
        <tr><th>パイプ径</th><td>φ150mm</td></tr>
        <tr><th>電源</th><td>単相200V</td></tr>
      </table>
    </body></html>`;

    const spec = parseToshibaDetailPage(html);
    expect(spec.pipe_diameter).toBe(150);
    expect(spec.voltage).toBe('単相200V');
    expect(spec.width_mm).toBeNull();
    expect(spec.airflow).toBeNull();
  });
});
