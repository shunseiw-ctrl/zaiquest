import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/entities/search_filter.dart';

class SupabaseProductDatasource {
  final SupabaseClient _client;

  SupabaseProductDatasource(this._client);

  Future<List<Map<String, dynamic>>> search(SearchFilter filter) async {
    var query = _client
        .from('products')
        .select('*, manufacturers(name), categories(name)');

    // Text search on model_number
    if (filter.query != null && filter.query!.isNotEmpty) {
      query = query.ilike('model_number', '%${filter.query}%');
    }

    // Dimension filters
    if (filter.widthMin != null) {
      query = query.gte('width_mm', filter.widthMin!);
    }
    if (filter.widthMax != null) {
      query = query.lte('width_mm', filter.widthMax!);
    }
    if (filter.heightMin != null) {
      query = query.gte('height_mm', filter.heightMin!);
    }
    if (filter.heightMax != null) {
      query = query.lte('height_mm', filter.heightMax!);
    }
    if (filter.depthMin != null) {
      query = query.gte('depth_mm', filter.depthMin!);
    }
    if (filter.depthMax != null) {
      query = query.lte('depth_mm', filter.depthMax!);
    }
    if (filter.pipeDiameterMin != null) {
      query = query.gte('pipe_diameter', filter.pipeDiameterMin!);
    }
    if (filter.pipeDiameterMax != null) {
      query = query.lte('pipe_diameter', filter.pipeDiameterMax!);
    }

    // Voltage filter
    if (filter.voltage != null) {
      query = query.eq('voltage', filter.voltage!);
    }

    // Price range
    if (filter.priceMin != null) {
      query = query.gte('list_price', filter.priceMin!);
    }
    if (filter.priceMax != null) {
      query = query.lte('list_price', filter.priceMax!);
    }

    // Manufacturer filter
    if (filter.manufacturerIds.isNotEmpty) {
      query = query.inFilter('manufacturer_id', filter.manufacturerIds);
    }

    // Category filter
    if (filter.categoryId != null) {
      query = query.eq('category_id', filter.categoryId!);
    }

    // Discontinued filter
    if (!filter.includeDiscontinued) {
      query = query.eq('is_discontinued', false);
    }

    final response = await query
        .order('updated_at', ascending: false)
        .range(filter.offset, filter.offset + filter.limit - 1);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getById(String id) async {
    final response = await _client
        .from('products')
        .select('*, manufacturers(name), categories(name)')
        .eq('id', id)
        .maybeSingle();

    return response;
  }

  Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
    final response = await _client
        .from('user_favorites')
        .select('product_id, products(*, manufacturers(name), categories(name))')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addFavorite(String userId, String productId) async {
    await _client.from('user_favorites').upsert({
      'user_id': userId,
      'product_id': productId,
    });
  }

  Future<void> removeFavorite(String userId, String productId) async {
    await _client
        .from('user_favorites')
        .delete()
        .eq('user_id', userId)
        .eq('product_id', productId);
  }

  Future<bool> isFavorite(String userId, String productId) async {
    final response = await _client
        .from('user_favorites')
        .select('id')
        .eq('user_id', userId)
        .eq('product_id', productId)
        .maybeSingle();

    return response != null;
  }

  Future<List<Map<String, dynamic>>> getManufacturers() async {
    final response = await _client
        .from('manufacturers')
        .select()
        .order('name');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await _client
        .from('categories')
        .select()
        .order('sort_order');

    return List<Map<String, dynamic>>.from(response);
  }

  // Memo methods

  Future<Map<String, dynamic>?> getMemo(
      String userId, String productId) async {
    final response = await _client
        .from('user_memos')
        .select()
        .eq('user_id', userId)
        .eq('product_id', productId)
        .maybeSingle();

    return response;
  }

  Future<void> upsertMemo({
    required String userId,
    required String productId,
    required int quantity,
    required String note,
  }) async {
    await _client.from('user_memos').upsert({
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
      'note': note,
    });
  }

  Future<void> deleteMemo(String userId, String productId) async {
    await _client
        .from('user_memos')
        .delete()
        .eq('user_id', userId)
        .eq('product_id', productId);
  }

  Future<List<Map<String, dynamic>>> getUserMemos(String userId) async {
    final response = await _client
        .from('user_memos')
        .select()
        .eq('user_id', userId)
        .order('updated_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
