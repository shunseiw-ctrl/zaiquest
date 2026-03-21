import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/local/drift_database.dart';
import '../../data/datasources/remote/supabase_product_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/search_filter.dart';
import '../../domain/repositories/product_repository.dart';

part 'product_providers.g.dart';

// Database singleton
@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

// Datasource
@Riverpod(keepAlive: true)
SupabaseProductDatasource supabaseProductDatasource(
    SupabaseProductDatasourceRef ref) {
  return SupabaseProductDatasource(Supabase.instance.client);
}

// Repository
@Riverpod(keepAlive: true)
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepositoryImpl(
    remote: ref.watch(supabaseProductDatasourceProvider),
    local: ref.watch(appDatabaseProvider),
  );
}

// Search filter state
@riverpod
class SearchFilterNotifier extends _$SearchFilterNotifier {
  bool _isLoadingMore = false;

  @override
  SearchFilter build() => const SearchFilter();

  void updateQuery(String query) {
    state = state.copyWith(query: query, offset: 0);
  }

  void updateWidthRange(double? min, double? max) {
    state = state.copyWith(widthMin: min, widthMax: max, offset: 0);
  }

  void updateHeightRange(double? min, double? max) {
    state = state.copyWith(heightMin: min, heightMax: max, offset: 0);
  }

  void updateDepthRange(double? min, double? max) {
    state = state.copyWith(depthMin: min, depthMax: max, offset: 0);
  }

  void updatePipeDiameterRange(double? min, double? max) {
    state = state.copyWith(pipeDiameterMin: min, pipeDiameterMax: max, offset: 0);
  }

  void updateVoltage(int? voltage) {
    state = state.copyWith(voltage: voltage, offset: 0);
  }

  void updatePriceRange(int? min, int? max) {
    state = state.copyWith(priceMin: min, priceMax: max, offset: 0);
  }

  void toggleManufacturer(String id) {
    final ids = List<String>.from(state.manufacturerIds);
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    state = state.copyWith(manufacturerIds: ids, offset: 0);
  }

  void updateCategory(String? categoryId) {
    state = state.copyWith(categoryId: categoryId, offset: 0);
  }

  void toggleDiscontinued() {
    state = state.copyWith(
      includeDiscontinued: !state.includeDiscontinued,
      offset: 0,
    );
  }

  void resetFilters() {
    state = const SearchFilter();
  }

  void loadMore() {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    state = state.copyWith(offset: state.offset + state.limit);
    _isLoadingMore = false;
  }
}

/// Accumulated search results with pagination support.
/// Resets list when offset==0 (filter change), appends when offset>0 (loadMore).
@riverpod
class SearchResultList extends _$SearchResultList {
  @override
  Future<List<Product>> build() async {
    final filter = ref.watch(searchFilterNotifierProvider);
    final repository = ref.watch(productRepositoryProvider);
    final newResults = await repository.search(filter);

    if (filter.offset == 0) {
      // Fresh search: replace entire list
      return newResults;
    }

    // Load more: append to existing list
    final previous = state.valueOrNull ?? [];
    return [...previous, ...newResults];
  }
}

/// Whether there are more results to load.
@riverpod
bool hasMoreResults(HasMoreResultsRef ref) {
  final filter = ref.watch(searchFilterNotifierProvider);
  final results = ref.watch(searchResultListProvider).valueOrNull;
  if (results == null) return true;
  // If we got fewer results than expected for the current page, no more data
  final expectedTotal = filter.offset + filter.limit;
  return results.length >= expectedTotal;
}

// Keep searchResultsProvider for backward compatibility
@riverpod
Future<List<Product>> searchResults(SearchResultsRef ref) async {
  return ref.watch(searchResultListProvider.future);
}

// Single product detail
@riverpod
Future<Product?> productDetail(ProductDetailRef ref, String id) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getById(id);
}

// Manufacturers list (for filter chips)
@riverpod
Future<List<Map<String, dynamic>>> manufacturers(ManufacturersRef ref) async {
  final datasource = ref.watch(supabaseProductDatasourceProvider);
  return datasource.getManufacturers();
}

// Categories list
@riverpod
Future<List<Map<String, dynamic>>> categories(CategoriesRef ref) async {
  final datasource = ref.watch(supabaseProductDatasourceProvider);
  return datasource.getCategories();
}
