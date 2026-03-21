import '../entities/product.dart';
import '../entities/search_filter.dart';

abstract class ProductRepository {
  Future<List<Product>> search(SearchFilter filter);
  Future<Product?> getById(String id);
  Future<List<Product>> getFavorites(String userId);
  Future<void> addFavorite(String userId, String productId);
  Future<void> removeFavorite(String userId, String productId);
  Future<bool> isFavorite(String userId, String productId);
}
