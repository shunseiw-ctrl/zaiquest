import { describe, it, expect } from 'vitest';
import { normalize, RawProduct } from '../src/normalizer.js';

describe('normalize', () => {
  it('should normalize model number to uppercase trimmed', () => {
    const raw: RawProduct = {
      model_number: ' fy-17c8 ',
      name: 'Test Fan',
      manufacturer_slug: 'panasonic',
      source: 'test',
    };
    const result = normalize(raw);
    expect(result.model_number).toBe('FY-17C8');
  });

  it('should parse numeric strings with commas', () => {
    const raw: RawProduct = {
      model_number: 'VD-15ZC14',
      name: 'Test',
      manufacturer_slug: 'mitsubishi',
      source: 'test',
      list_price: '12,800',
      width_mm: '285',
    };
    const result = normalize(raw);
    expect(result.list_price).toBe(12800);
    expect(result.width_mm).toBe(285);
  });

  it('should parse voltage from text', () => {
    const raw: RawProduct = {
      model_number: 'TEST-100',
      name: 'Test',
      manufacturer_slug: 'test',
      source: 'test',
      voltage: '単相100V',
    };
    const result = normalize(raw);
    expect(result.voltage).toBe(100);
  });

  it('should handle 200V voltage', () => {
    const raw: RawProduct = {
      model_number: 'TEST-200',
      name: 'Test',
      manufacturer_slug: 'test',
      source: 'test',
      voltage: '三相200V',
    };
    const result = normalize(raw);
    expect(result.voltage).toBe(200);
  });

  it('should handle null/undefined values', () => {
    const raw: RawProduct = {
      model_number: 'TEST',
      name: 'Test',
      manufacturer_slug: 'test',
      source: 'test',
    };
    const result = normalize(raw);
    expect(result.width_mm).toBeNull();
    expect(result.height_mm).toBeNull();
    expect(result.list_price).toBeNull();
    expect(result.voltage).toBeNull();
    expect(result.is_discontinued).toBe(false);
  });

  it('should pass through numeric values directly', () => {
    const raw: RawProduct = {
      model_number: 'TEST',
      name: 'Test',
      manufacturer_slug: 'test',
      source: 'test',
      width_mm: 285,
      list_price: 12800,
      voltage: 100,
    };
    const result = normalize(raw);
    expect(result.width_mm).toBe(285);
    expect(result.list_price).toBe(12800);
    expect(result.voltage).toBe(100);
  });

  it('should strip units from numeric strings', () => {
    const raw: RawProduct = {
      model_number: 'TEST',
      name: 'Test',
      manufacturer_slug: 'test',
      source: 'test',
      airflow: '55m3/h',
      noise_level: '26dB',
      power_consumption: '3.7W',
    };
    const result = normalize(raw);
    expect(result.airflow).toBe(55);
    expect(result.noise_level).toBe(26);
    expect(result.power_consumption).toBe(3.7);
  });
});
