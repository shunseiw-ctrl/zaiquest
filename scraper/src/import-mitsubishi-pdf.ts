/**
 * 三菱換気扇 機器早見表 PDF (2025年1月改訂版) からの手動データ投入スクリプト
 * Source: mitsubishikankisen_kikihayamihyo_241211.pdf
 *
 * Usage: npx tsx src/import-mitsubishi-pdf.ts
 */
import { normalize, type RawProduct } from './normalizer.js';
import { uploadProducts } from './uploader.js';
import 'dotenv/config';

const SOURCE = 'mitsubishi_pdf';
const SOURCE_ID = 'kikihayamihyo_241211';
const MFG = 'mitsubishi';
const BASE_URL = 'https://www.mitsubishielectric.co.jp/ldg/wink/';

// ============================================================
// パイプ用ファン (Pipe Fans) — 接続パイプΦ100mm
// ============================================================
const pipeFans100: RawProduct[] = [
  // 標準タイプ
  { model_number: 'V-08PS8', name: 'パイプ用ファン V-08PS8', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 75, list_price: 11300, usage: '居室・洗面所・トイレ', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'V-08PD8', name: 'パイプ用ファン V-08PD8 電気式シャッター付', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 75, list_price: 11700, usage: '居室・洗面所・トイレ', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // センサータイプ — 人感センサー付
  { model_number: 'V-08PAD8', name: 'パイプ用ファン V-08PAD8 人感センサー付', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 75, list_price: 23700, usage: '居室', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'V-08PALD8', name: 'パイプ用ファン V-08PALD8 人感センサー付', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 75, list_price: 26100, usage: '洗面所・トイレ', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'V-08PTSD8', name: 'パイプ用ファン V-08PTSD8 温度センサー付 24時間換気', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 75, list_price: 27900, usage: '居室', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // 標準・連続運転タイプ
  { model_number: 'V-08PLD8', name: 'パイプ用ファン V-08PLD8', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 75, list_price: 15100, usage: '居室・洗面所・トイレ', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'V-08PFLD8', name: 'パイプ用ファン V-08PFLD8', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 75, list_price: 15400, usage: '居室・洗面所', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'V-08PBLD8', name: 'パイプ用ファン V-08PBLD8', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 95, list_price: 16700, usage: '居室・洗面所・トイレ', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'V-08PHSD8', name: 'パイプ用ファン V-08PHSD8 湿度センサー付 24時間換気', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 75, list_price: 27900, usage: '居室・洗面所', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'V-08PHLD8', name: 'パイプ用ファン V-08PHLD8 湿度センサー付', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 75, list_price: 28500, usage: '居室・洗面所', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // 小風量タイプ
  { model_number: 'V-08KPLD8', name: 'パイプ用ファン V-08KPLD8', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 48, list_price: 14300, usage: '居室・洗面所・トイレ', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'V-08XPLD8', name: 'パイプ用ファン V-08XPLD8', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 48, list_price: 14700, usage: '居室・洗面所・トイレ', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // 高静圧タイプ
  { model_number: 'V-08PP8', name: 'パイプ用ファン V-08PP8', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 100, list_price: 12100, usage: '洗面所・トイレ・浴室', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'V-08PPD8', name: 'パイプ用ファン V-08PPD8 電気式シャッター付', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 100, list_price: 12800, usage: '洗面所・トイレ・浴室', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'V-08PPM8', name: 'パイプ用ファン V-08PPM8', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 95, list_price: 12900, usage: '洗面所・トイレ・浴室', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // 角形タイプ
  { model_number: 'V-08PE7', name: 'パイプ用ファン V-08PE7', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 75, list_price: 17600, usage: '居室・洗面所', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'V-08PED7', name: 'パイプ用ファン V-08PED7 電気式シャッター付', category_slug: 'ventilation-fan', pipe_diameter: 100, voltage: 100, airflow: 75, list_price: 18100, usage: '居室・洗面所', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
];

// ============================================================
// パイプ用ファン — 接続パイプΦ150mm
// ============================================================
const pipeFans150: RawProduct[] = [
  { model_number: 'V-12P8', name: 'パイプ用ファン V-12P8 Φ150mm', category_slug: 'ventilation-fan', pipe_diameter: 150, voltage: 100, airflow: 135, list_price: 14400, usage: '居室・洗面所・トイレ・浴室', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'V-12PD8', name: 'パイプ用ファン V-12PD8 Φ150mm 電気式シャッター付', category_slug: 'ventilation-fan', pipe_diameter: 150, voltage: 100, airflow: 135, list_price: 15200, usage: '居室・洗面所・トイレ・浴室', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
];

// ============================================================
// ダクト用換気扇 — DCブラシレスモーター搭載タイプ
// ============================================================
const ductFansDC: RawProduct[] = [
  { model_number: 'VD-10ZVC7', name: 'ダクト用換気扇 VD-10ZVC7 DCモーター', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 100, list_price: 29800, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-13ZVC7', name: 'ダクト用換気扇 VD-13ZVC7 DCモーター', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, list_price: 33900, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-15ZVC7', name: 'ダクト用換気扇 VD-15ZVC7 DCモーター', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 160, list_price: 46200, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-18ZVC7', name: 'ダクト用換気扇 VD-18ZVC7 DCモーター', category_slug: 'duct-fan', pipe_diameter: 150, voltage: 100, airflow: 300, list_price: 60500, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-10ZFVC7', name: 'ダクト用換気扇 VD-10ZFVC7 DCモーター フィルター付', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 120, list_price: 51600, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-15ZFVC7', name: 'ダクト用換気扇 VD-15ZFVC7 DCモーター フィルター付', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, list_price: 54200, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // 大風量タイプ
  { model_number: 'VD-15ZVX7-C', name: 'ダクト用換気扇 VD-15ZVX7-C DCモーター 大風量', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 160, list_price: 46800, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-18ZVX7-C', name: 'ダクト用換気扇 VD-18ZVX7-C DCモーター 大風量', category_slug: 'duct-fan', pipe_diameter: 150, voltage: 100, list_price: 55400, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-15ZVX7-FP', name: 'ダクト用換気扇 VD-15ZVX7-FP DCモーター フリープラン', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 160, list_price: 51600, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-18ZVX7-FP', name: 'ダクト用換気扇 VD-18ZVX7-FP DCモーター フリープラン', category_slug: 'duct-fan', pipe_diameter: 150, voltage: 100, list_price: 61200, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // CO₂センサー付
  { model_number: 'VD-13ZVY7', name: 'ダクト用換気扇 VD-13ZVY7 CO₂センサー付', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 120, list_price: 43700, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-18ZVY7', name: 'ダクト用換気扇 VD-18ZVY7 CO₂センサー付', category_slug: 'duct-fan', pipe_diameter: 150, voltage: 100, list_price: 55800, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // CO₂センサー付 機器連動タイプ
  { model_number: 'VD-18ZAGVR7-C', name: 'ダクト用換気扇 VD-18ZAGVR7-C CO₂センサー付 機器連動', category_slug: 'duct-fan', pipe_diameter: 150, voltage: 100, airflow: 400, list_price: 94300, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-20ZAGVR7-C', name: 'ダクト用換気扇 VD-20ZAGVR7-C CO₂センサー付 機器連動', category_slug: 'duct-fan', pipe_diameter: 150, voltage: 100, airflow: 550, list_price: 116000, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // 人感センサー付
  { model_number: 'VD-10ZAVC7', name: 'ダクト用換気扇 VD-10ZAVC7 人感センサー付', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 100, list_price: 47600, usage: 'トイレ・洗面所', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-13ZAVC7', name: 'ダクト用換気扇 VD-13ZAVC7 人感センサー付', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, list_price: 51900, usage: 'トイレ・洗面所', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
];

// ============================================================
// ダクト用換気扇 — ACモーター サニタリー用
// ============================================================
const ductFansAC: RawProduct[] = [
  { model_number: 'VD-10ZC14', name: 'ダクト用換気扇 VD-10ZC14', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 90, list_price: 20700, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-10Z14', name: 'ダクト用換気扇 VD-10Z14', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 90, list_price: 23200, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-10ZLC14-S', name: 'ダクト用換気扇 VD-10ZLC14-S 24時間換気', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 90, list_price: 24900, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-13Z14', name: 'ダクト用換気扇 VD-13Z14', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 125, list_price: 27100, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-13ZC14', name: 'ダクト用換気扇 VD-13ZC14', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 125, list_price: 24600, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-13ZLC14-S', name: 'ダクト用換気扇 VD-13ZLC14-S 24時間換気', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 125, list_price: 28400, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-15ZC14', name: 'ダクト用換気扇 VD-15ZC14', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 180, list_price: 25200, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-15ZFC14', name: 'ダクト用換気扇 VD-15ZFC14 フィルター付', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 180, list_price: 31700, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-15ZLC14-S', name: 'ダクト用換気扇 VD-15ZLC14-S 24時間換気', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 180, list_price: 30300, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-13ZCD14', name: 'ダクト用換気扇 VD-13ZCD14', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 175, list_price: 31900, usage: 'サニタリー用', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-15ZFCD14', name: 'ダクト用換気扇 VD-15ZFCD14 フィルター付', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 210, list_price: 34400, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-18ZC14', name: 'ダクト用換気扇 VD-18ZC14', category_slug: 'duct-fan', pipe_diameter: 150, voltage: 100, airflow: 320, list_price: 39800, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-20ZC14', name: 'ダクト用換気扇 VD-20ZC14', category_slug: 'duct-fan', pipe_diameter: 150, voltage: 100, list_price: 50300, usage: '浴室・トイレ・洗面所(居間・事務所・店舗)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-08ZC14', name: 'ダクト用換気扇 VD-08ZC14 トイレ(小空間)専用', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 50, list_price: 19300, usage: 'トイレ(小空間)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // 居間・事務所・店舗用
  { model_number: 'VD-15ZX14-C', name: 'ダクト用換気扇 VD-15ZX14-C', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 160, list_price: 27600, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-15ZXP14-C', name: 'ダクト用換気扇 VD-15ZXP14-C', category_slug: 'duct-fan', pipe_diameter: 100, voltage: 100, airflow: 210, list_price: 33000, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // 台所・ミニキッチン用
  { model_number: 'VD-13ZY14', name: 'ダクト用換気扇 VD-13ZY14 台所用', category_slug: 'duct-fan', pipe_diameter: 150, voltage: 100, airflow: 160, list_price: 42600, usage: '台所・ミニキッチン', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-15ZY14', name: 'ダクト用換気扇 VD-15ZY14 台所用', category_slug: 'duct-fan', pipe_diameter: 150, voltage: 100, manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-18ZP13', name: 'ダクト用換気扇 VD-18ZP13 台所用', category_slug: 'duct-fan', pipe_diameter: 150, voltage: 100, airflow: 370, list_price: 42600, usage: '台所・湿潤室・厨房', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VD-20Z14', name: 'ダクト用換気扇 VD-20Z14 台所用', category_slug: 'duct-fan', pipe_diameter: 150, voltage: 100, airflow: 420, list_price: 48100, usage: '台所・湿潤室・厨房', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
];

// ============================================================
// 標準換気扇
// ============================================================
const standardFans: RawProduct[] = [
  // 学校用標準換気扇（窓枠据付格子タイプ）
  { model_number: 'EX-20SC4', name: '標準換気扇 EX-20SC4 学校用', category_slug: 'ventilation-fan', voltage: 100, list_price: 39600, usage: '学校', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-25SC4', name: '標準換気扇 EX-25SC4 学校用', category_slug: 'ventilation-fan', voltage: 100, list_price: 41900, usage: '学校', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-30SC4', name: '標準換気扇 EX-30SC4 学校用', category_slug: 'ventilation-fan', voltage: 100, list_price: 44700, usage: '学校', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-20SC+-S', name: '標準換気扇 EX-20SC+-S 電気式シャッター', category_slug: 'ventilation-fan', voltage: 100, list_price: 37700, usage: '学校', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-25SC+-S', name: '標準換気扇 EX-25SC+-S 電気式シャッター', category_slug: 'ventilation-fan', voltage: 100, list_price: 40000, usage: '学校', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-30SC+-S', name: '標準換気扇 EX-30SC+-S 電気式シャッター', category_slug: 'ventilation-fan', voltage: 100, list_price: 42900, usage: '学校', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-20SC+-RK', name: '標準換気扇 EX-20SC+-RK 再生式フィルター付', category_slug: 'ventilation-fan', voltage: 100, list_price: 40600, usage: '学校', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-25SC+-RK', name: '標準換気扇 EX-25SC+-RK 再生式フィルター付', category_slug: 'ventilation-fan', voltage: 100, list_price: 42900, usage: '学校', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-30SC+-RK', name: '標準換気扇 EX-30SC+-RK 再生式フィルター付', category_slug: 'ventilation-fan', voltage: 100, list_price: 45800, usage: '学校', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // 店舗用
  { model_number: 'EX-20ST+-S', name: '標準換気扇 EX-20ST+-S 店舗用', category_slug: 'ventilation-fan', voltage: 100, list_price: 34300, usage: '店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-25ST+-S', name: '標準換気扇 EX-25ST+-S 店舗用', category_slug: 'ventilation-fan', voltage: 100, list_price: 36300, usage: '店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-30ST+-S', name: '標準換気扇 EX-30ST+-S 店舗用', category_slug: 'ventilation-fan', voltage: 100, list_price: 39000, usage: '店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // クリーンコンパック
  { model_number: 'EX-20LH9', name: '標準換気扇 EX-20LH9 クリーンコンパック', category_slug: 'ventilation-fan', voltage: 100, list_price: 22300, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-25LH9', name: '標準換気扇 EX-25LH9 クリーンコンパック', category_slug: 'ventilation-fan', voltage: 100, list_price: 25200, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // 格子タイプ
  { model_number: 'EX-20EK9-C', name: '標準換気扇 EX-20EK9-C 格子タイプ', category_slug: 'ventilation-fan', voltage: 100, list_price: 32800, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-25EK9-C', name: '標準換気扇 EX-25EK9-C 格子タイプ', category_slug: 'ventilation-fan', voltage: 100, list_price: 35500, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-30EK9-C', name: '標準換気扇 EX-30EK9-C 格子タイプ', category_slug: 'ventilation-fan', voltage: 100, list_price: 39300, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // フィルターコンパック
  { model_number: 'EX-15LF8', name: '標準換気扇 EX-15LF8 フィルターコンパック', category_slug: 'ventilation-fan', voltage: 100, list_price: 22400, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-20LF8', name: '標準換気扇 EX-20LF8 フィルターコンパック', category_slug: 'ventilation-fan', voltage: 100, list_price: 24200, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-25LF8', name: '標準換気扇 EX-25LF8 フィルターコンパック', category_slug: 'ventilation-fan', voltage: 100, list_price: 27400, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-30FF8', name: '標準換気扇 EX-30FF8 フィルターコンパック', category_slug: 'ventilation-fan', voltage: 100, list_price: 35200, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // ワイドレンジファン
  { model_number: 'VD-15Z14', name: '標準換気扇 VD-15Z14', category_slug: 'ventilation-fan', pipe_diameter: 150, voltage: 100, airflow: 180, list_price: 28200, usage: '居間・事務所・店舗', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // メタルコンパック
  { model_number: 'EX-20LMP9', name: '標準換気扇 EX-20LMP9 メタルコンパック', category_slug: 'ventilation-fan', voltage: 100, list_price: 33100, usage: '台所', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-25LMP9', name: '標準換気扇 EX-25LMP9 メタルコンパック', category_slug: 'ventilation-fan', voltage: 100, list_price: 35900, usage: '台所', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'EX-30FMP9', name: '標準換気扇 EX-30FMP9 メタルコンパック', category_slug: 'ventilation-fan', voltage: 100, list_price: 44400, usage: '台所', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
];

// ============================================================
// バス乾燥・暖房・換気システム
// ============================================================
const bathroomDryers: RawProduct[] = [
  { model_number: 'V-141BZ7', name: 'バス乾燥・暖房・換気 V-141BZ7 100V 1部屋用', category_slug: 'bathroom-dryer', pipe_diameter: 100, voltage: 100, list_price: 128000, usage: '浴室', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'V-143BZLT9', name: 'バス乾燥・暖房・換気 V-143BZLT9 100V 3部屋用', category_slug: 'bathroom-dryer', pipe_diameter: 100, voltage: 100, list_price: 146000, usage: '浴室', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'V-241BK9-RN', name: 'リニューアルバスカラット V-241BK9-RN 200V', category_slug: 'bathroom-dryer', voltage: 200, list_price: 192000, usage: '浴室', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
];

// ============================================================
// 換気空清機ロスナイ・ダクト用ロスナイ
// ============================================================
const lossnay: RawProduct[] = [
  // 壁掛1パイプ取付タイプ
  { model_number: 'VL-10S3-D', name: '換気空清機ロスナイ VL-10S3-D 壁掛1パイプ', category_slug: 'ventilation-fan', voltage: 100, list_price: 48400, usage: '居室', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VL-18U3-D', name: '換気空清機ロスナイ VL-18U3-D 壁掛1パイプ', category_slug: 'ventilation-fan', voltage: 100, list_price: 87700, usage: '居室', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // ダクト用ロスナイ
  { model_number: 'VL-250ZSD3', name: 'ダクト用ロスナイ VL-250ZSD3 電気式シャッター', category_slug: 'duct-fan', voltage: 100, list_price: 207000, usage: '居室・事務所', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VL-250ZSD3-B', name: 'ダクト用ロスナイ VL-250ZSD3-B 電気式シャッター', category_slug: 'duct-fan', voltage: 100, list_price: 237000, usage: '居室・事務所', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  // J-ファンロスナイミニ
  { model_number: 'VL-06JV3', name: 'J-ファンロスナイミニ VL-06JV3 6畳用', category_slug: 'ventilation-fan', voltage: 100, list_price: 40400, usage: '居室(6畳)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VL-08JV3', name: 'J-ファンロスナイミニ VL-08JV3 8畳用', category_slug: 'ventilation-fan', voltage: 100, list_price: 41700, usage: '居室(8畳)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VL-10JV3', name: 'J-ファンロスナイミニ VL-10JV3 10畳用', category_slug: 'ventilation-fan', voltage: 100, list_price: 43100, usage: '居室(10畳)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'VL-12JV3', name: 'J-ファンロスナイミニ VL-12JV3 12畳用', category_slug: 'ventilation-fan', voltage: 100, list_price: 44500, usage: '居室(12畳)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
];

// ============================================================
// ヘルスエアー機能搭載 循環ファン
// ============================================================
const circulationFans: RawProduct[] = [
  { model_number: 'JC-10KR', name: 'ヘルスエアー循環ファン JC-10KR 10畳用 ワイヤレスリモコン', category_slug: 'air-conditioner', voltage: 100, list_price: 51800, usage: '居室(10畳)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'JC-10K', name: 'ヘルスエアー循環ファン JC-10K 10畳用 壁スイッチ', category_slug: 'air-conditioner', voltage: 100, list_price: 41400, usage: '居室(10畳)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
  { model_number: 'JC-30KR', name: 'ヘルスエアー循環ファン JC-30KR 30畳用 ワイヤレスリモコン', category_slug: 'air-conditioner', voltage: 100, list_price: 115000, usage: '居室(30畳)', manufacturer_slug: MFG, source: SOURCE, source_id: SOURCE_ID },
];

// ============================================================
// メイン処理
// ============================================================
export async function importMitsubishiPdf() {
  const allProducts: RawProduct[] = [
    ...pipeFans100,
    ...pipeFans150,
    ...ductFansDC,
    ...ductFansAC,
    ...standardFans,
    ...bathroomDryers,
    ...lossnay,
    ...circulationFans,
  ];

  console.log(`[Mitsubishi PDF Import] Total products: ${allProducts.length}`);
  console.log(`  パイプ用ファンΦ100: ${pipeFans100.length}`);
  console.log(`  パイプ用ファンΦ150: ${pipeFans150.length}`);
  console.log(`  ダクト用換気扇(DC): ${ductFansDC.length}`);
  console.log(`  ダクト用換気扇(AC): ${ductFansAC.length}`);
  console.log(`  標準換気扇: ${standardFans.length}`);
  console.log(`  バス乾燥・暖房: ${bathroomDryers.length}`);
  console.log(`  ロスナイ: ${lossnay.length}`);
  console.log(`  循環ファン: ${circulationFans.length}`);

  const normalized = allProducts.map(normalize);
  console.log(`[Mitsubishi PDF Import] Normalized: ${normalized.length} products`);

  const result = await uploadProducts(normalized);
  console.log(`[Mitsubishi PDF Import] Upload result:`, result);
}

// Allow direct execution: npx tsx src/import-mitsubishi-pdf.ts
if (process.argv[1]?.endsWith('import-mitsubishi-pdf.ts') || process.argv[1]?.endsWith('import-mitsubishi-pdf.js')) {
  importMitsubishiPdf().catch((e) => {
    console.error('[Mitsubishi PDF Import] Fatal error:', e);
    process.exit(1);
  });
}
