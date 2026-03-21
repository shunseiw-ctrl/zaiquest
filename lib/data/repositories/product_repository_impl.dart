import 'package:flutter/foundation.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/search_filter.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local/drift_database.dart';
import '../datasources/remote/supabase_product_datasource.dart';
import '../models/product_mapper.dart';

class ProductRepositoryImpl implements ProductRepository {
  final SupabaseProductDatasource _remote;
  final AppDatabase _local;

  ProductRepositoryImpl({
    required SupabaseProductDatasource remote,
    required AppDatabase local,
  })  : _remote = remote,
        _local = local;

  @override
  Future<List<Product>> search(SearchFilter filter) async {
    // Offline-first: query local cache immediately
    final localResults = await _local.searchProducts(
      query: filter.query,
      widthMin: filter.widthMin,
      widthMax: filter.widthMax,
      heightMin: filter.heightMin,
      heightMax: filter.heightMax,
      depthMin: filter.depthMin,
      depthMax: filter.depthMax,
      voltage: filter.voltage,
      priceMin: filter.priceMin,
      priceMax: filter.priceMax,
      manufacturerIds: filter.manufacturerIds.isEmpty
          ? null
          : filter.manufacturerIds,
      includeDiscontinued: filter.includeDiscontinued,
      limit: filter.limit,
      offset: filter.offset,
    );

    // Try remote in parallel
    try {
      final remoteResults = await _remote.search(filter);
      final products =
          remoteResults.map(ProductMapper.fromSupabaseJson).toList();

      // Update local cache
      final companions = products.map(ProductMapper.toCachedCompanion).toList();
      await _local.upsertProducts(companions);
      await _local.setLastSyncedAt(DateTime.now());

      return products;
    } catch (e, st) {
      debugPrint('[ProductRepo] Remote search failed: $e');
      debugPrint('[ProductRepo] Stack trace: $st');
      // Offline fallback: return local results
      return localResults.map(ProductMapper.fromCachedProduct).toList();
    }
  }

  @override
  Future<Product?> getById(String id) async {
    try {
      final json = await _remote.getById(id);
      if (json != null) {
        final product = ProductMapper.fromSupabaseJson(json);
        await _local
            .upsertProducts([ProductMapper.toCachedCompanion(product)]);
        return product;
      }
    } catch (e, st) {
      debugPrint('[ProductRepo] getById failed: $e');
      debugPrint('[ProductRepo] Stack trace: $st');
      // Offline fallback
    }

    final cached = await _local.getProduct(id);
    if (cached != null) {
      return ProductMapper.fromCachedProduct(cached);
    }
    return null;
  }

  @override
  Future<List<Product>> getFavorites(String userId) async {
    final results = await _remote.getFavorites(userId);
    return results.map((row) {
      final productJson =
          row['products'] as Map<String, dynamic>;
      return ProductMapper.fromSupabaseJson(productJson);
    }).toList();
  }

  @override
  Future<void> addFavorite(String userId, String productId) async {
    await _remote.addFavorite(userId, productId);
  }

  @override
  Future<void> removeFavorite(String userId, String productId) async {
    await _remote.removeFavorite(userId, productId);
  }

  @override
  Future<bool> isFavorite(String userId, String productId) async {
    return _remote.isFavorite(userId, productId);
  }
}
