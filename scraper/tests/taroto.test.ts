import { describe, it, expect } from 'vitest';
// Import parseListingPage directly - it's exported from the module
import { parseListingPage, parseDetailPage, parseComparisonPage } from '../src/sources/taroto.js';

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

  // --- Tests for taroto.jp actual HTML structure (unstructured text) ---

  it('extracts pipe diameter from p.item-description text', () => {
    const html = `
      <html><body>
        <p class="item-description">
          ●接続パイプ径：φ100mm<br>
          ●埋込寸法：260mm角<br>
        </p>
      </body></html>
    `;

    const spec = parseDetailPage(html);
    expect(spec.pipe_diameter).toBe(100);
  });

  it('extracts list price from p.fixed-price', () => {
    const html = `
      <html><body>
        <p class="fixed-price">希望小売価格：￥22,100（税抜）</p>
        <p class="item-description">
          ●接続ダクト：φ150mm<br>
        </p>
      </body></html>
    `;

    const spec = parseDetailPage(html);
    expect(spec.list_price).toBe('￥22,100（税抜）');
    expect(spec.pipe_diameter).toBe(150);
  });

  it('extracts square dimensions from description text', () => {
    const html = `
      <html><body>
        <p class="item-description">
          ●埋込寸法：260mm角<br>
          ●接続パイプ径：φ100mm<br>
        </p>
      </body></html>
    `;

    const spec = parseDetailPage(html);
    // 260mm角 → width=260, height=260
    expect(spec.width_mm).toBe(260);
    expect(spec.height_mm).toBe(260);
  });

  it('extracts WxH or WxHxD dimensions from description text', () => {
    const html = `
      <html><body>
        <p class="item-description">
          ●外形寸法：285×285×107mm<br>
          ●接続ダクト：φ100<br>
        </p>
      </body></html>
    `;

    const spec = parseDetailPage(html);
    expect(spec.width_mm).toBe(285);
    expect(spec.height_mm).toBe(285);
    expect(spec.depth_mm).toBe(107);
    expect(spec.pipe_diameter).toBe(100);
  });

  it('extracts voltage from description text', () => {
    const html = `
      <html><body>
        <p class="item-description">
          ●電源：単相100V<br>
        </p>
      </body></html>
    `;

    const spec = parseDetailPage(html);
    expect(spec.voltage).toBe('単相100V');
  });

  it('extracts airflow, noise, power from description text', () => {
    const html = `
      <html><body>
        <p class="item-description">
          ●風量：55m3/h<br>
          ●騒音：26dB<br>
          ●消費電力：3.7W<br>
        </p>
      </body></html>
    `;

    const spec = parseDetailPage(html);
    expect(spec.airflow).toBe('55m3/h');
    expect(spec.noise_level).toBe('26dB');
    expect(spec.power_consumption).toBe('3.7W');
  });

  it('handles mixed format: table specs + description text + fixed-price', () => {
    const html = `
      <html><body>
        <table>
          <tr><th>電源</th><td>三相200V</td></tr>
        </table>
        <p class="item-description">
          ●接続パイプ径：φ150mm<br>
          ●風量：120m3/h<br>
        </p>
        <p class="fixed-price">希望小売価格：￥45,000（税抜）</p>
      </body></html>
    `;

    const spec = parseDetailPage(html);
    // Table data takes priority for voltage
    expect(spec.voltage).toBe('三相200V');
    // Description data fills in the rest
    expect(spec.pipe_diameter).toBe(150);
    expect(spec.airflow).toBe('120m3/h');
    expect(spec.list_price).toBe('￥45,000（税抜）');
  });

  it('returns nulls when no description or table exists', () => {
    const html = `<html><body><p>Some other content</p></body></html>`;
    const spec = parseDetailPage(html);
    expect(spec.width_mm).toBeNull();
    expect(spec.pipe_diameter).toBeNull();
    expect(spec.voltage).toBeNull();
    expect(spec.list_price).toBeNull();
  });
});

describe('taroto parseComparisonPage', () => {
  it('extracts replacement model products from comparison table', () => {
    const html = `
      <html><body>
        <table>
          <tr>
            <td>V-10Z<br/>V-10Z2<br/>V-10Z2-1</td>
            <td><a href="https://www.taroto.jp/view/item/000000026272">VD-10ZJ14</a></td>
            <td>風量増加</td>
          </tr>
        </table>
      </body></html>
    `;

    const products = parseComparisonPage(html, 'mitsubishi');
    expect(products.length).toBe(1);
    expect(products[0].model_number).toBe('VD-10ZJ14');
    expect(products[0].manufacturer_slug).toBe('mitsubishi');
    expect(products[0].source).toBe('taroto');
    expect(products[0].source_id).toBe('000000026272');
    expect(products[0].product_url).toBe('https://www.taroto.jp/view/item/000000026272');
    expect(products[0].predecessor_model).toBe('V-10Z');
    expect(products[0].raw_data).toEqual({ taihi_note: '風量増加' });
  });

  it('deduplicates products by item ID', () => {
    const html = `
      <html><body>
        <table>
          <tr>
            <td>FV-10A</td>
            <td><a href="/view/item/100">FY-17S7</a></td>
            <td></td>
          </tr>
          <tr>
            <td>FV-10B</td>
            <td><a href="/view/item/100">FY-17S7</a></td>
            <td></td>
          </tr>
          <tr>
            <td>FV-20A</td>
            <td><a href="/view/item/200">FY-24BM6K</a></td>
            <td>埋込寸法が異なります</td>
          </tr>
        </table>
      </body></html>
    `;

    const products = parseComparisonPage(html, 'panasonic');
    expect(products.length).toBe(2);
    expect(products[0].model_number).toBe('FY-17S7');
    expect(products[1].model_number).toBe('FY-24BM6K');
  });

  it('handles multiple product links in a single cell', () => {
    const html = `
      <html><body>
        <table>
          <tr>
            <td>VFP-8GK</td>
            <td>
              <a href="/view/item/300">VFP-8GK4</a>（標準）<br/>
              <a href="/view/item/301">VFP-8WGK4</a>（防水）
            </td>
            <td>仕様変更</td>
          </tr>
        </table>
      </body></html>
    `;

    const products = parseComparisonPage(html, 'toshiba');
    expect(products.length).toBe(2);
    expect(products[0].model_number).toBe('VFP-8GK4');
    expect(products[1].model_number).toBe('VFP-8WGK4');
  });

  it('handles relative URLs', () => {
    const html = `
      <html><body>
        <table>
          <tr>
            <td>V-08PD7</td>
            <td><a href="/view/item/500">V-08PQFF4</a></td>
            <td></td>
          </tr>
        </table>
      </body></html>
    `;

    const products = parseComparisonPage(html, 'mitsubishi');
    expect(products.length).toBe(1);
    expect(products[0].product_url).toBe('https://www.taroto.jp/view/item/500');
  });

  it('returns empty array for HTML with no comparison tables', () => {
    const html = `<html><body><p>No tables here</p></body></html>`;
    const products = parseComparisonPage(html, 'panasonic');
    expect(products.length).toBe(0);
  });

  it('skips rows without product links', () => {
    const html = `
      <html><body>
        <table>
          <tr><th>旧品番</th><th>買替（現行）機種</th><th>備考</th></tr>
          <tr>
            <td>FY-10A</td>
            <td><a href="/view/item/600">FY-17S7</a></td>
            <td></td>
          </tr>
          <tr>
            <td>FY-OLD</td>
            <td>廃止（代替なし）</td>
            <td>生産終了</td>
          </tr>
        </table>
      </body></html>
    `;

    const products = parseComparisonPage(html, 'panasonic');
    expect(products.length).toBe(1);
    expect(products[0].model_number).toBe('FY-17S7');
  });
});
