# ZAIQUEST Build Commands
# 使い方: export SUPABASE_ANON_KEY="your-anon-key" してから make run-prod 等を実行

SUPABASE_URL := https://femuzakojnhohgtmypff.supabase.co

# --- Dev (Supabase local) ---
run-dev:
	flutter run \
	  --dart-define=SUPABASE_URL=http://127.0.0.1:54321 \
	  --dart-define=SUPABASE_ANON_KEY=$(SUPABASE_LOCAL_ANON_KEY)

# --- Prod ---
run-prod:
	flutter run \
	  --dart-define=SUPABASE_URL=$(SUPABASE_URL) \
	  --dart-define=SUPABASE_ANON_KEY=$(SUPABASE_ANON_KEY) \
	  --dart-define=SENTRY_DSN=$(SENTRY_DSN)

build-apk:
	flutter build apk --release \
	  --dart-define=SUPABASE_URL=$(SUPABASE_URL) \
	  --dart-define=SUPABASE_ANON_KEY=$(SUPABASE_ANON_KEY) \
	  --dart-define=SENTRY_DSN=$(SENTRY_DSN)

build-appbundle:
	flutter build appbundle --release \
	  --dart-define=SUPABASE_URL=$(SUPABASE_URL) \
	  --dart-define=SUPABASE_ANON_KEY=$(SUPABASE_ANON_KEY) \
	  --dart-define=SENTRY_DSN=$(SENTRY_DSN)

build-ios:
	flutter build ios --release \
	  --dart-define=SUPABASE_URL=$(SUPABASE_URL) \
	  --dart-define=SUPABASE_ANON_KEY=$(SUPABASE_ANON_KEY) \
	  --dart-define=SENTRY_DSN=$(SENTRY_DSN)

# --- Scraper ---
scrape-all:
	cd scraper && npm run scrape:all

scrape-detail:
	cd scraper && npx tsx src/index.ts --detail --source taroto
	cd scraper && npx tsx src/index.ts --detail --source panasonic
	cd scraper && npx tsx src/index.ts --detail --source toshiba
	cd scraper && npx tsx src/index.ts --detail --source mitsubishi-wink

scrape-merge:
	cd scraper && npx tsx src/index.ts --merge
