import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/favorite_providers.dart';
import '../../providers/product_providers.dart';
import '../search/widgets/product_card.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('お気に入り'),
      ),
      body: userId == null ? _buildLoginPrompt(context) : _buildList(ref),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'ログインするとお気に入り機能が使えます',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.login),
            label: const Text('ログイン'),
            onPressed: () => context.push('/login'),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(WidgetRef ref) {
    final favoritesAsync = ref.watch(userFavoritesProvider);

    return favoritesAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'お気に入りはまだありません',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Dismissible(
              key: ValueKey(product.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) async {
                final userId = ref.read(currentUserIdProvider)!;
                final repo = ref.read(productRepositoryProvider);
                await repo.removeFavorite(userId, product.id);
                ref.invalidate(userFavoritesProvider);
              },
              child: ProductCard(
                product: product,
                onTap: () => context.push('/product/${product.id}'),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('エラー: $error')),
    );
  }
}
