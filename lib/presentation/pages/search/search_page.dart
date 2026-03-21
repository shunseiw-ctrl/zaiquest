import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/product_providers.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/filter_panel.dart';
import 'widgets/product_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ZAIQUEST'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () => context.push('/favorites'),
          ),
          _buildUserIcon(context, ref),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBarWidget(
              onFilterToggle: () {
                setState(() => _showFilters = !_showFilters);
              },
              showFilters: _showFilters,
            ),
          ),

          // Filter panel
          if (_showFilters) const FilterPanel(),

          // Results
          Expanded(
            child: searchResults.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          '検索条件に一致する商品がありません',
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
                    return ProductCard(
                      product: products[index],
                      onTap: () =>
                          context.push('/product/${products[index].id}'),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('エラー: $error'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () =>
                          ref.invalidate(searchResultsProvider),
                      child: const Text('再試行'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserIcon(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);
    if (userId != null) {
      return IconButton(
        icon: const Icon(Icons.person),
        onPressed: () => _showLogoutDialog(context, ref),
      );
    }
    return IconButton(
      icon: const Icon(Icons.person_outline),
      onPressed: () => context.push('/login'),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ログアウト'),
        content: const Text('ログアウトしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).signOut();
              Navigator.of(ctx).pop();
            },
            child: const Text('ログアウト'),
          ),
        ],
      ),
    );
  }
}
