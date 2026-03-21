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
  @override
  SearchFilter build() => const SearchFilter();

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void updateWidthRange(double? min, double? max) {
    state = state.copyWith(widthMin: min, widthMax: max);
  }

  void updateHeightRange(double? min, double? max) {
    state = state.copyWith(heightMin: min, heightMax: max);
  }

  void updateDepthRange(double? min, double? max) {
    state = state.copyWith(depthMin: min, depthMax: max);
  }

  void updatePipeDiameterRange(double? min, double? max) {
    state = state.copyWith(pipeDiameterMin: min, pipeDiameterMax: max);
  }

  void updateVoltage(int? voltage) {
    state = state.copyWith(voltage: voltage);
  }

  void updatePriceRange(int? min, int? max) {
    state = state.copyWith(priceMin: min, priceMax: max);
  }

  void toggleManufacturer(String id) {
    final ids = List<String>.from(state.manufacturerIds);
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    state = state.copyWith(manufacturerIds: ids);
  }

  void updateCategory(String? categoryId) {
    state = state.copyWith(categoryId: categoryId);
  }

  void toggleDiscontinued() {
    state = state.copyWith(includeDiscontinued: !state.includeDiscontinued);
  }

  void resetFilters() {
    state = const SearchFilter();
  }

  void loadMore() {
    state = state.copyWith(offset: state.offset + state.limit);
  }
}

// Search results
@riverpod
Future<List<Product>> searchResults(SearchResultsRef ref) async {
  final filter = ref.watch(searchFilterNotifierProvider);
  final repository = ref.watch(productRepositoryProvider);
  return repository.search(filter);
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
