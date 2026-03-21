import { describe, it, expect } from 'vitest';
// Import parseListingPage directly - it's exported from the module
import { parseListingPage, parseDetailPage } from '../src/sources/taroto.js';

describe('taroto parseListingPage', () => {
  it('extracts products from listing HTML', () => {
    const html = `
      <html><body>
        <a href="/view/item/12345?foo=bar">
          <div>パナソニック FY-17C8 天埋換気扇</div>
          <div>￥8,682(税込)</div>
          <img src="https://www.taroto.jp/itemimages/FY-17C8.jpg" />
        </a>
      </body></html>
    `;

    const products = parseListingPage(html, 'ventilation-fan');
    expect(products.length).toBe(1);
    expect(products[0].model_number).toBe('FY-17C8');
    expect(products[0].street_price).toBe('8682');
    expect(products[0].source).toBe('taroto');
    expect(products[0].source_id).toBe('12345');
    expect(products[0].category_slug).toBe('ventilation-fan');
    expect(products[0].product_url).toBe('https://www.taroto.jp/view/item/12345');
  });

  it('deduplicates products by item ID', () => {
    const html = `
      <html><body>
        <a href="/view/item/100">VD-15ZC14 ダクト換気扇</a>
        <a href="/view/item/100">VD-15ZC14 ダクト換気扇（別リンク）</a>
        <a href="/view/item/200">FY-08PD9D パイプファン</a>
      </body></html>
    `;

    const products = parseListingPage(html, 'duct-fan');
    expect(products.length).toBe(2);
  });

  it('skips items without model numbers', () => {
    const html = `
      <html><body>
        <a href="/view/item/300">換気扇カテゴリ一覧</a>
        <a href="/view/item/301">VD-15ZC14 ダクト換気扇</a>
      </body></html>
    `;

    const products = parseListingPage(html, 'duct-fan');
    // "換気扇カテゴリ一覧" has no model number pattern
    expect(products.length).toBe(1);
    expect(products[0].model_number).toBe('VD-15ZC14');
  });

  it('returns empty array for HTML with no product links', () => {
    const html = `<html><body><p>No products here</p></body></html>`;
    const products = parseListingPage(html, 'ventilation-fan');
    expect(products.length).toBe(0);
  });
});

describe('taroto parseDetailPage', () => {
  it('extracts dimensions from spec table', () => {
    const html = `
      <html><body>
        <table>
          <tr><th>外形寸法</th><td>285×285×107mm</td></tr>
          <tr><th>接続ダクト径</th><td>φ100</td></tr>
          <tr><th>電源</th><td>単相100V</td></tr>
          <tr><th>風量</th><td>55m3/h</td></tr>
          <tr><th>騒音</th><td>26dB</td></tr>
          <tr><th>消費電力</th><td>3.7W</td></tr>
          <tr><th>メーカー希望小売価格</th><td>¥22,100(税抜)</td></tr>
        </table>
      </body></html>
    `;

    const spec = parseDetailPage(html);
    expect(spec.width_mm).toBe(285);
    expect(spec.height_mm).toBe(285);
    expect(spec.depth_mm).toBe(107);
    expect(spec.pipe_diameter).toBe(100);
    expect(spec.voltage).toBe('単相100V');
    expect(spec.airflow).toBe('55m3/h');
    expect(spec.noise_level).toBe('26dB');
    expect(spec.power_consumption).toBe('3.7W');
    expect(spec.list_price).toBe('¥22,100(税抜)');
  });

  it('returns nulls for empty spec table', () => {
    const html = `<html><body><table></table></body></html>`;
    const spec = parseDetailPage(html);
    expect(spec.width_mm).toBeNull();
    expect(spec.pipe_diameter).toBeNull();
    expect(spec.voltage).toBeNull();
  });

  it('handles partial spec data', () => {
    const html = `
      <html><body>
        <table>
          <tr><th>電源</th><td>三相200V</td></tr>
        </table>
      </body></html>
    `;

    const spec = parseDetailPage(html);
    expect(spec.voltage).toBe('三相200V');
    expect(spec.width_mm).toBeNull();
    expect(spec.airflow).toBeNull();
  });

  it('handles dimension patterns without mm suffix', () => {
    const html = `
      <html><body>
        <table>
          <tr><th>外形寸法</th><td>320 × 320 × 150</td></tr>
        </table>
      </body></html>
    `;

    const spec = parseDetailPage(html);
    expect(spec.width_mm).toBe(320);
    expect(spec.height_mm).toBe(320);
    expect(spec.depth_mm).toBe(150);
  });
});
