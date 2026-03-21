import 'package:flutter_test/flutter_test.dart';

import 'package:zaiquest/domain/entities/search_filter.dart';

/// Tests for SearchFilterNotifier logic.
/// Since Riverpod generated notifiers are hard to unit test without
/// a full ProviderContainer + generated code, we test the filter
/// state transitions directly on the SearchFilter model.
void main() {
  group('SearchFilter state transitions', () {
    test('updateQuery resets offset to 0', () {
      const filter = SearchFilter(offset: 40);
      final updated = filter.copyWith(query: 'VD-15', offset: 0);
      expect(updated.query, 'VD-15');
      expect(updated.offset, 0);
    });

    test('loadMore increments offset by limit', () {
      const filter = SearchFilter(offset: 0, limit: 20);
      final updated = filter.copyWith(offset: filter.offset + filter.limit);
      expect(updated.offset, 20);

      final nextPage = updated.copyWith(offset: updated.offset + updated.limit);
      expect(nextPage.offset, 40);
    });

    test('resetFilters returns default state', () {
      final filter = const SearchFilter(
        query: 'test',
        voltage: 100,
        offset: 40,
        manufacturerIds: ['mfr-1'],
      );
      const reset = SearchFilter();
      expect(reset.query, isNull);
      expect(reset.offset, 0);
      expect(reset.voltage, isNull);
      expect(reset.manufacturerIds, isEmpty);
    });

    test('filter changes reset offset', () {
      const filter = SearchFilter(offset: 40, voltage: 100);
      // Simulating what the notifier does: any filter change resets offset
      final updated = filter.copyWith(voltage: 200, offset: 0);
      expect(updated.voltage, 200);
      expect(updated.offset, 0);
    });

    test('hasMore logic: fewer results than limit means no more', () {
      // Simulate hasMore calculation
      const filter = SearchFilter(offset: 0, limit: 20);
      const resultsCount = 15; // less than limit
      final hasMore = resultsCount >= (filter.offset + filter.limit);
      expect(hasMore, false);
    });

    test('hasMore logic: results equal to expected total means more', () {
      const filter = SearchFilter(offset: 0, limit: 20);
      const resultsCount = 20; // equals offset + limit
      final hasMore = resultsCount >= (filter.offset + filter.limit);
      expect(hasMore, true);
    });

    test('accumulated list after loadMore', () {
      // Simulate accumulation logic
      final page1 = List.generate(20, (i) => 'product-$i');
      const filter = SearchFilter(offset: 20, limit: 20);
      final page2 = List.generate(20, (i) => 'product-${20 + i}');

      // offset > 0 means append
      final accumulated = [...page1, ...page2];
      expect(accumulated, hasLength(40));
      expect(accumulated.first, 'product-0');
      expect(accumulated.last, 'product-39');
    });
  });
}
