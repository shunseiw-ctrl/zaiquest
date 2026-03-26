# ZAIQUEST - 建材横断検索アプリ

5メーカーの換気扇・建材を横断検索できるモバイルアプリ。内装業の材料発注時に複数メーカーサイトを手動巡回する手間を解消します。

## 対応メーカー

| メーカー | データソース |
|---------|-----------|
| Panasonic | panasonic.biz カタログ |
| 三菱電機 | WINK (Web) + 機器早見表 PDF |
| 東芝キャリア | 東芝キャリア カタログ |
| taroto | taroto.jp (実勢価格あり) |

## 主な機能

- **横断検索**: 型番・寸法・電圧・価格・メーカー・カテゴリで絞り込み
- **商品比較**: 最大4件の商品をスペック比較表で並べて比較
- **お気に入り**: よく使う商品をブックマーク
- **発注メモ**: 商品ごとに数量とメモを記録
- **オフライン対応**: SQLite キャッシュでネットワーク不安定時も検索可能

## 技術スタック

| レイヤー | 技術 |
|---------|------|
| モバイル | Flutter 3.41 + Riverpod 3 + GoRouter |
| バックエンド | Supabase (Auth + PostgreSQL + RLS) |
| ローカルDB | Drift (SQLite) |
| スクレイパー | Node.js + TypeScript + Playwright |
| CI/CD | GitHub Actions |

## セットアップ

### 前提条件

- Flutter SDK 3.11+
- Node.js 22+
- Supabase プロジェクト

### Flutter アプリ

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### スクレイパー

```bash
cd scraper
npm install
npx playwright install chromium
```

## ビルド・実行

環境変数を設定してから実行:

```bash
export SUPABASE_ANON_KEY="your-anon-key"
```

```bash
# 開発
make run-dev

# 本番接続
make run-prod

# リリースビルド
make build-apk        # Android APK
make build-appbundle   # Android App Bundle (Play Store用)
make build-ios         # iOS
```

## スクレイパー実行

```bash
make scrape-all       # 全ソース一括取得
make scrape-detail    # 詳細スペック取得
make scrape-merge     # クロスリファレンスマージ
```

## プロジェクト構成

```
zaiquest/
├── lib/
│   ├── core/           # テーマ、ルーター
│   ├── data/           # Supabase/Drift データソース、リポジトリ実装
│   ├── domain/         # エンティティ、リポジトリインターフェース、ユースケース
│   └── presentation/   # UI (pages, providers, widgets)
├── scraper/
│   └── src/
│       ├── sources/    # メーカー別スクレイパー
│       ├── index.ts    # CLI エントリポイント
│       ├── normalizer.ts
│       └── uploader.ts
├── supabase/
│   ├── migrations/     # DBスキーマ
│   └── seed.sql        # 初期マスタデータ
└── test/               # ユニットテスト・ウィジェットテスト
```

## ライセンス

Private - Albalize Inc.
