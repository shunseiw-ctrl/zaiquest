import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/product.dart';
import 'auth_provider.dart';
import 'product_providers.dart';

part 'favorite_providers.g.dart';

@riverpod
Future<List<Product>> userFavorites(UserFavoritesRef ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  final repository = ref.watch(productRepositoryProvider);
  return repository.getFavorites(userId);
}

@riverpod
Future<bool> isFavorite(IsFavoriteRef ref, String productId) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return false;
  final repository = ref.watch(productRepositoryProvider);
  return repository.isFavorite(userId, productId);
}
