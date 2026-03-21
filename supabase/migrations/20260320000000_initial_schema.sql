-- メーカーマスタ
CREATE TABLE manufacturers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  slug TEXT NOT NULL UNIQUE,
  website_url TEXT,
  logo_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- カテゴリマスタ（階層対応）
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  parent_id UUID REFERENCES categories(id),
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 商品テーブル（メイン）
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_number TEXT NOT NULL,
  name TEXT NOT NULL,
  manufacturer_id UUID NOT NULL REFERENCES manufacturers(id),
  category_id UUID REFERENCES categories(id),
  -- 寸法 (mm)
  width_mm NUMERIC,
  height_mm NUMERIC,
  depth_mm NUMERIC,
  pipe_diameter NUMERIC,
  -- スペック
  voltage INT,
  airflow NUMERIC,
  noise_level NUMERIC,
  power_consumption NUMERIC,
  -- 価格
  list_price INT,
  street_price INT,
  -- メタ
  product_url TEXT,
  image_url TEXT,
  usage TEXT,
  description TEXT,
  is_discontinued BOOLEAN DEFAULT FALSE,
  predecessor_model TEXT,
  -- ソース管理
  source TEXT NOT NULL,
  source_id TEXT,
  raw_data JSONB,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE (source, model_number)
);

-- お気に入り
CREATE TABLE user_favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE (user_id, product_id)
);

-- 発注メモ
CREATE TABLE user_memos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  quantity INT DEFAULT 1,
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE (user_id, product_id)
);

-- インデックス
CREATE INDEX idx_products_dimensions ON products (width_mm, height_mm, depth_mm) WHERE is_discontinued = FALSE;
CREATE INDEX idx_products_voltage ON products (voltage) WHERE is_discontinued = FALSE;
CREATE INDEX idx_products_price ON products (list_price) WHERE is_discontinued = FALSE;
CREATE INDEX idx_products_manufacturer ON products (manufacturer_id);
CREATE INDEX idx_products_category ON products (category_id);
CREATE INDEX idx_products_pipe_diameter ON products (pipe_diameter) WHERE is_discontinued = FALSE;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX idx_products_model_number_trgm ON products USING gin (model_number gin_trgm_ops);

-- RLS
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "products_read_all" ON products FOR SELECT USING (true);
CREATE POLICY "products_write_service" ON products FOR ALL USING (auth.role() = 'service_role');

ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;
CREATE POLICY "favorites_own" ON user_favorites FOR ALL USING (auth.uid() = user_id);

ALTER TABLE user_memos ENABLE ROW LEVEL SECURITY;
CREATE POLICY "memos_own" ON user_memos FOR ALL USING (auth.uid() = user_id);
