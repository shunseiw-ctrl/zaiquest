import { describe, it, expect } from 'vitest';
import { parsePanasonicDetailPage } from '../src/sources/panasonic.js';

describe('parsePanasonicDetailPage', () => {
  it('should extract specs from table rows', () => {
    const html = `<html><body>
      <table>
        <tr><th>外形寸法</th><td>320×320×120mm</td></tr>
        <tr><th>パイプ径</th><td>φ100mm</td></tr>
        <tr><th>電源</th><td>単相100V</td></tr>
        <tr><th>風量</th><td>80m³/h</td></tr>
        <tr><th>騒音</th><td>25.5dB</td></tr>
        <tr><th>消費電力</th><td>3.5W</td></tr>
        <tr><th>希望小売価格</th><td>15,800円</td></tr>
      </table>
    </body></html>`;

    const spec = parsePanasonicDetailPage(html);
    expect(spec.width_mm).toBe(320);
    expect(spec.height_mm).toBe(320);
    expect(spec.depth_mm).toBe(120);
    expect(spec.pipe_diameter).toBe(100);
    expect(spec.voltage).toBe('単相100V');
    expect(spec.airflow).toBe('80m³/h');
    expect(spec.noise_level).toBe('25.5dB');
    expect(spec.power_consumption).toBe('3.5W');
    expect(spec.list_price).toBe('15,800円');
  });

  it('should return all nulls for empty HTML', () => {
    const spec = parsePanasonicDetailPage('<html><body></body></html>');
    expect(spec.width_mm).toBeNull();
    expect(spec.height_mm).toBeNull();
    expect(spec.voltage).toBeNull();
    expect(spec.airflow).toBeNull();
  });

  it('should extract from spec list elements', () => {
    const html = `<html><body>
      <ul class="spec-list">
        <li>電源：AC100V 50/60Hz</li>
        <li>風量：105 m³/h</li>
      </ul>
    </body></html>`;

    const spec = parsePanasonicDetailPage(html);
    expect(spec.voltage).toBe('AC100V 50/60Hz');
    expect(spec.airflow).toBe('105 m³/h');
  });

  it('should extract partial data', () => {
    const html = `<html><body>
      <table>
        <tr><th>接続パイプ径</th><td>φ150mm</td></tr>
      </table>
    </body></html>`;

    const spec = parsePanasonicDetailPage(html);
    expect(spec.pipe_diameter).toBe(150);
    expect(spec.width_mm).toBeNull();
  });

  it('should extract price from body text', () => {
    const html = `<html><body>
      <p>メーカー希望小売価格（税抜）：￥22,100</p>
    </body></html>`;

    const spec = parsePanasonicDetailPage(html);
    expect(spec.list_price).toBe('22,100');
  });
});
