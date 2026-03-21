import { describe, it, expect } from 'vitest';

// We need to test parseCategoryPage. It's not currently exported,
// so we test the scraper's output format expectations.
// For now, we import the module to verify it loads correctly.

describe('toshiba scraper', () => {
  it('module loads without errors', async () => {
    const mod = await import('../src/sources/toshiba.js');
    expect(mod.scrapeToshiba).toBeDefined();
  });

  describe('model number patterns', () => {
    // Test the regex pattern used by the scraper
    const modelRegex = /^([A-Z]{2,5}-\d{1,5}[A-Z\d\-()（）]*)/i;

    it('matches standard Toshiba model numbers', () => {
      expect('VFP-8W5'.match(modelRegex)?.[1]).toBe('VFP-8W5');
      expect('VFR-63LJB(K)'.match(modelRegex)?.[1]).toBe('VFR-63LJB(K)');
      expect('VFH-20H2'.match(modelRegex)?.[1]).toBe('VFH-20H2');
      expect('DVB-18S4'.match(modelRegex)?.[1]).toBe('DVB-18S4');
    });

    it('does not match non-model text', () => {
      expect('パイプファン'.match(modelRegex)).toBeNull();
      expect('製品一覧'.match(modelRegex)).toBeNull();
    });

    it('extracts pipe diameter from description', () => {
      const pipeRegex = /[φΦ](\d+)/;
      expect('φ100mm パイプファン'.match(pipeRegex)?.[1]).toBe('100');
      expect('Φ150 ダクト'.match(pipeRegex)?.[1]).toBe('150');
      expect('径不明'.match(pipeRegex)).toBeNull();
    });
  });
});
