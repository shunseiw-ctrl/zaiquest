import { describe, it, expect } from 'vitest';
import { parsePanasonicDetailPage, parsePanasonicListPage, extractSpecsFromDescription } from '../src/sources/panasonic.js';

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

// ---------------------------------------------------------------------------
// List page parser tests
// ---------------------------------------------------------------------------

const SAMPLE_LIST_HTML = `<html><body>
<ul class="flex__block--pc flex-wr just-spabe kanki-recommend__block">
  <li>
    <a class="is-link--bk on-hover" href="https://www14.arrow.mew.co.jp/scvb/a2A/opnItemList?s_hinban_key=FY-08PFRY9VD&search_kbn=0">
      <div class="kanki-recommend-body flex__block align-ce">
        <p><img alt="写真" src="/air/kanki/pipe/img/index/recommend/01_photo@2x.png"></p>
        <dl>
          <dt>
            <span>パイプファン</span>
            FY-08PFRY9VD
          </dt>
          <dd>
            <p class="kanki-recommend--link">＞詳しく見る</p>
          </dd>
        </dl>
      </div>
    </a>
    <div class="kanki-recommend--texts">
      ●トイレ用 ●排気 ●常時換気推奨 ●人感センサー付
      ●室内側寸法(ルーバー寸法) 高さ17.5×幅17×奥行4.5cm
      ●消費電力(50/60Hz) 強1.9/2.2W 弱1.4/1.5W
    </div>
  </li>
  <li>
    <a class="is-link--bk on-hover" href="/air/kanki/pipe/detail/FY-12PTS9D/">
      <div class="kanki-recommend-body flex__block align-ce">
        <p><img alt="写真" src="/air/kanki/pipe/img/index/recommend/02_photo@2x.png"></p>
        <dl>
          <dt>
            <span>パイプファン</span>
            FY-12PTS9D
          </dt>
          <dd>
            <p class="kanki-recommend--link">＞詳しく見る</p>
          </dd>
        </dl>
      </div>
    </a>
    <div class="kanki-recommend--texts">
      ●居室用 ●排気 ●速結端子付
      ●室内側寸法(ルーバー寸法) 高さ22×幅22×奥行5cm
      ●消費電力(50/60Hz) 3.0/3.5W
    </div>
  </li>
  <li>
    <a href="/some/page/">
      <div class="kanki-recommend-body">
        <dl><dt><span>その他</span>NOT-A-MODEL</dt></dl>
      </div>
    </a>
  </li>
</ul>
</body></html>`;

describe('parsePanasonicListPage', () => {
  it('should extract products from kanki-recommend__block list', () => {
    const products = parsePanasonicListPage(SAMPLE_LIST_HTML, '/air/kanki/pipe/');
    // Third li has no FY- model, should be skipped
    expect(products).toHaveLength(2);
  });

  it('should extract correct model numbers', () => {
    const products = parsePanasonicListPage(SAMPLE_LIST_HTML, '/air/kanki/pipe/');
    expect(products[0].model_number).toBe('FY-08PFRY9VD');
    expect(products[1].model_number).toBe('FY-12PTS9D');
  });

  it('should build product name from span + model', () => {
    const products = parsePanasonicListPage(SAMPLE_LIST_HTML, '/air/kanki/pipe/');
    expect(products[0].name).toBe('パイプファン FY-08PFRY9VD');
  });

  it('should resolve image URLs', () => {
    const products = parsePanasonicListPage(SAMPLE_LIST_HTML, '/air/kanki/pipe/');
    expect(products[0].image_url).toBe('https://sumai.panasonic.jp/air/kanki/pipe/img/index/recommend/01_photo@2x.png');
  });

  it('should preserve absolute hrefs for product_url', () => {
    const products = parsePanasonicListPage(SAMPLE_LIST_HTML, '/air/kanki/pipe/');
    // First product has absolute external URL
    expect(products[0].product_url).toContain('arrow.mew.co.jp');
    // Second product has relative URL → should be resolved
    expect(products[1].product_url).toBe('https://sumai.panasonic.jp/air/kanki/pipe/detail/FY-12PTS9D/');
  });

  it('should map category from span text', () => {
    const products = parsePanasonicListPage(SAMPLE_LIST_HTML, '/air/kanki/pipe/');
    expect(products[0].category_slug).toBe('ventilation-fan');
  });

  it('should set manufacturer_slug and source', () => {
    const products = parsePanasonicListPage(SAMPLE_LIST_HTML, '/air/kanki/pipe/');
    expect(products[0].manufacturer_slug).toBe('panasonic');
    expect(products[0].source).toBe('panasonic_biz');
  });

  it('should return empty array for HTML with no products', () => {
    const products = parsePanasonicListPage('<html><body><p>no products</p></body></html>', '/air/kanki/pipe/');
    expect(products).toHaveLength(0);
  });

  it('should store extracted specs in raw_data', () => {
    const products = parsePanasonicListPage(SAMPLE_LIST_HTML, '/air/kanki/pipe/');
    const raw = products[0].raw_data as Record<string, unknown>;
    expect(raw).not.toBeNull();
    expect(raw.height_mm).toBe(175);
    expect(raw.width_mm).toBe(170);
    expect(raw.depth_mm).toBe(45);
    expect(raw.power_consumption_50hz).toBe('1.9W');
    expect(raw.power_consumption_60hz).toBe('2.2W');
  });
});

describe('extractSpecsFromDescription', () => {
  it('should extract dimensions in mm from cm text', () => {
    const specs = extractSpecsFromDescription('●室内側寸法(ルーバー寸法) 高さ17.5×幅17×奥行4.5cm');
    expect(specs.height_mm).toBe(175);
    expect(specs.width_mm).toBe(170);
    expect(specs.depth_mm).toBe(45);
  });

  it('should extract power consumption', () => {
    const specs = extractSpecsFromDescription('●消費電力(50/60Hz) 強1.9/2.2W 弱1.4/1.5W');
    expect(specs.power_consumption_50hz).toBe('1.9W');
    expect(specs.power_consumption_60hz).toBe('2.2W');
  });

  it('should extract power without 強/弱 prefix', () => {
    const specs = extractSpecsFromDescription('●消費電力(50/60Hz) 3.0/3.5W');
    expect(specs.power_consumption_50hz).toBe('3.0W');
    expect(specs.power_consumption_60hz).toBe('3.5W');
  });

  it('should return empty object for unrelated text', () => {
    const specs = extractSpecsFromDescription('●トイレ用 ●排気');
    expect(Object.keys(specs)).toHaveLength(0);
  });
});
