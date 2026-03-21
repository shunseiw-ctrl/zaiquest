import 'package:flutter_test/flutter_test.dart';

import 'package:zaiquest/domain/entities/product.dart';
import 'package:zaiquest/domain/entities/search_filter.dart';

void main() {
  group('Product entity', () {
    test('creates with required fields', () {
      const product = Product(
        id: 'test-id',
        modelNumber: 'VD-15ZC14',
        name: 'ダクト用換気扇',
        manufacturerId: 'mfr-1',
        source: 'test',
      );

      expect(product.modelNumber, 'VD-15ZC14');
      expect(product.isDiscontinued, false);
      expect(product.widthMm, isNull);
    });

    test('copyWith works', () {
      const product = Product(
        id: 'test-id',
        modelNumber: 'VD-15ZC14',
        name: 'ダクト用換気扇',
        manufacturerId: 'mfr-1',
        source: 'test',
      );

      final updated = product.copyWith(voltage: 100, listPrice: 12800);
      expect(updated.voltage, 100);
      expect(updated.listPrice, 12800);
      expect(updated.modelNumber, 'VD-15ZC14');
    });
  });

  group('SearchFilter', () {
    test('defaults are correct', () {
      const filter = SearchFilter();
      expect(filter.offset, 0);
      expect(filter.limit, 20);
      expect(filter.includeDiscontinued, false);
      expect(filter.manufacturerIds, isEmpty);
      expect(filter.query, isNull);
    });

    test('copyWith updates filter', () {
      const filter = SearchFilter();
      final updated = filter.copyWith(
        voltage: 100,
        widthMin: 200,
        widthMax: 400,
      );
      expect(updated.voltage, 100);
      expect(updated.widthMin, 200);
      expect(updated.widthMax, 400);
    });
  });
}
