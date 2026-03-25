import { describe, it, expect } from 'vitest';
import {
  scrapeMitsubishiWink,
  VENTILATION_CATEGORIES,
  MitsubishiWinkScrapingResult,
} from '../src/sources/mitsubishi-wink.js';

describe('mitsubishi-wink scraper', () => {
  it('module loads without errors', async () => {
    const mod = await import('../src/sources/mitsubishi-wink.js');
    expect(mod.scrapeMitsubishiWink).toBeDefined();
  });

  it('scrapeMitsubishiWink is a function', () => {
    expect(typeof scrapeMitsubishiWink).toBe('function');
  });

  describe('MitsubishiWinkScrapingResult interface', () => {
    it('accepts a valid result shape', () => {
      const result: MitsubishiWinkScrapingResult = {
        products: [],
        errors: [],
      };
      expect(result).toHaveProperty('products');
      expect(result).toHaveProperty('errors');
      expect(Array.isArray(result.products)).toBe(true);
      expect(Array.isArray(result.errors)).toBe(true);
    });
  });

  describe('VENTILATION_CATEGORIES', () => {
    it('is an array with 4 categories', () => {
      expect(Array.isArray(VENTILATION_CATEGORIES)).toBe(true);
      expect(VENTILATION_CATEGORIES).toHaveLength(4);
    });

    it('each category has ccd and label properties', () => {
      for (const cat of VENTILATION_CATEGORIES) {
        expect(cat).toHaveProperty('ccd');
        expect(cat).toHaveProperty('label');
        expect(typeof cat.ccd).toBe('string');
        expect(typeof cat.label).toBe('string');
      }
    });

    it('contains expected category codes', () => {
      const codes = VENTILATION_CATEGORIES.map((c) => c.ccd);
      expect(codes).toContain('104012');
      expect(codes).toContain('202016');
      expect(codes).toContain('202017');
      expect(codes).toContain('202018');
    });

    it('contains residential and commercial labels', () => {
      const labels = VENTILATION_CATEGORIES.map((c) => c.label);
      expect(labels.some((l) => l.includes('住宅用'))).toBe(true);
      expect(labels.some((l) => l.includes('業務用'))).toBe(true);
    });
  });
});
