import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:zaiquest/data/datasources/local/drift_database.dart';
import 'package:zaiquest/data/datasources/remote/supabase_product_datasource.dart';
import 'package:zaiquest/data/repositories/product_repository_impl.dart';
import 'package:zaiquest/domain/entities/search_filter.dart';

class MockSupabaseDatasource extends Mock implements SupabaseProductDatasource {}

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  late MockSupabaseDatasource mockRemote;
  late MockAppDatabase mockLocal;
  late ProductRepositoryImpl repository;

  const testFilter = SearchFilter();

  final testSupabaseJson = {
    'id': 'test-1',
    'model_number': 'VD-15ZC14',
    'name': 'ダクト用換気扇',
    'manufacturer_id': 'mfr-1',
    'category_id': null,
    'width_mm': null,
    'height_mm': null,
    'depth_mm': null,
    'pipe_diameter': null,
    'voltage': 100,
    'airflow': null,
    'noise_level': null,
    'power_consumption': null,
    'list_price': 12800,
    'street_price': null,
    'product_url': null,
    'image_url': null,
    'usage': null,
    'description': null,
    'is_discontinued': false,
    'predecessor_model': null,
    'source': 'taroto',
    'source_id': '123',
    'manufacturers': {'name': 'Mitsubishi'},
    'categories': null,
  };

  setUp(() {
    mockRemote = MockSupabaseDatasource();
    mockLocal = MockAppDatabase();
    repository = ProductRepositoryImpl(
      remote: mockRemote,
      local: mockLocal,
    );
  });

  setUpAll(() {
    registerFallbackValue(const SearchFilter());
    registerFallbackValue(<CachedProductsCompanion>[]);
  });

  group('search()', () {
    test('returns remote results on success', () async {
      when(() => mockLocal.searchProducts(
            query: any(named: 'query'),
            widthMin: any(named: 'widthMin'),
            widthMax: any(named: 'widthMax'),
            heightMin: any(named: 'heightMin'),
            heightMax: any(named: 'heightMax'),
            depthMin: any(named: 'depthMin'),
            depthMax: any(named: 'depthMax'),
            voltage: any(named: 'voltage'),
            priceMin: any(named: 'priceMin'),
            priceMax: any(named: 'priceMax'),
            manufacturerIds: any(named: 'manufacturerIds'),
            includeDiscontinued: any(named: 'includeDiscontinued'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => []);

      when(() => mockRemote.search(any()))
          .thenAnswer((_) async => [testSupabaseJson]);

      when(() => mockLocal.upsertProducts(any()))
          .thenAnswer((_) async {});
      when(() => mockLocal.setLastSyncedAt(any()))
          .thenAnswer((_) async {});

      final results = await repository.search(testFilter);

      expect(results, hasLength(1));
      expect(results.first.modelNumber, 'VD-15ZC14');
      verify(() => mockLocal.upsertProducts(any())).called(1);
    });

    test('falls back to local cache on remote error', () async {
      when(() => mockLocal.searchProducts(
            query: any(named: 'query'),
            widthMin: any(named: 'widthMin'),
            widthMax: any(named: 'widthMax'),
            heightMin: any(named: 'heightMin'),
            heightMax: any(named: 'heightMax'),
            depthMin: any(named: 'depthMin'),
            depthMax: any(named: 'depthMax'),
            voltage: any(named: 'voltage'),
            priceMin: any(named: 'priceMin'),
            priceMax: any(named: 'priceMax'),
            manufacturerIds: any(named: 'manufacturerIds'),
            includeDiscontinued: any(named: 'includeDiscontinued'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => []);

      when(() => mockRemote.search(any()))
          .thenThrow(Exception('Network error'));

      final results = await repository.search(testFilter);

      expect(results, isEmpty);
      verifyNever(() => mockLocal.upsertProducts(any()));
    });

    test('getById returns remote product on success', () async {
      when(() => mockRemote.getById('test-1'))
          .thenAnswer((_) async => testSupabaseJson);
      when(() => mockLocal.upsertProducts(any()))
          .thenAnswer((_) async {});

      final result = await repository.getById('test-1');

      expect(result, isNotNull);
      expect(result!.id, 'test-1');
    });

    test('getById falls back to local on remote error', () async {
      when(() => mockRemote.getById('test-1'))
          .thenThrow(Exception('Network error'));
      when(() => mockLocal.getProduct('test-1'))
          .thenAnswer((_) async => null);

      final result = await repository.getById('test-1');

      expect(result, isNull);
    });
  });
}
