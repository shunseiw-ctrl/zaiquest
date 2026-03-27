import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/comparison_providers.dart';
import '../../providers/product_providers.dart';
import '../../../core/utils/error_helpers.dart';
import 'widgets/comparison_bottom_bar.dart';
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
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final hasMore = ref.read(hasMoreResultsProvider);
      final isLoading = ref.read(searchResultListProvider).isLoading;
      if (hasMore && !isLoading) {
        ref.read(searchFilterNotifierProvider.notifier).loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultListProvider);
    final hasMore = ref.watch(hasMoreResultsProvider);
    final comparisonSelection = ref.watch(comparisonSelectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ZAIQUEST'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            tooltip: 'お気に入り一覧',
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

          // Filter panel (replaces results when open)
          if (_showFilters)
            const Expanded(child: SingleChildScrollView(child: FilterPanel()))
          else ...[
          // Result count + sort
          _buildResultBar(),

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
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= products.length) {
                      // Loading indicator at the bottom
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final product = products[index];
                    final isSelected = ref
                        .read(comparisonSelectionProvider.notifier)
                        .isSelected(product.id);

                    return ProductCard(
                      product: product,
                      onTap: () => context.push('/product/${product.id}'),
                      isSelectedForComparison: isSelected,
                      onComparisonToggle: (_) {
                        final notifier =
                            ref.read(comparisonSelectionProvider.notifier);
                        if (!notifier.isSelected(product.id) &&
                            comparisonSelection.length >=
                                ComparisonSelection.maxItems) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('比較は最大4件までです'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }
                        notifier.toggle(product);
                      },
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
                    Text(friendlyErrorMessage(error)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () =>
                          ref.invalidate(searchResultListProvider),
                      child: const Text('再試行'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ],
        ],
      ),
      bottomNavigationBar: comparisonSelection.isNotEmpty
          ? ComparisonBottomBar(
              selectedCount: comparisonSelection.length,
              onClear: () =>
                  ref.read(comparisonSelectionProvider.notifier).clear(),
              onCompare: () => context.push('/compare'),
            )
          : null,
    );
  }

  Widget _buildResultBar() {
    final countAsync = ref.watch(searchResultCountProvider);
    final filter = ref.watch(searchFilterNotifierProvider);
    final sortLabel = switch ((filter.sortBy, filter.sortAscending)) {
      ('list_price', true) => '価格が安い順',
      ('list_price', false) => '価格が高い順',
      ('model_number', true) => '型番順 (A-Z)',
      _ => '更新日順',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          countAsync.when(
            data: (count) => Text(
              '$count 件',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            loading: () => const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            tooltip: '並び替え',
            onSelected: (value) {
              final notifier =
                  ref.read(searchFilterNotifierProvider.notifier);
              switch (value) {
                case 'updated_at':
                  notifier.updateSort('updated_at', false);
                case 'price_asc':
                  notifier.updateSort('list_price', true);
                case 'price_desc':
                  notifier.updateSort('list_price', false);
                case 'model_number':
                  notifier.updateSort('model_number', true);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'updated_at', child: Text('更新日順')),
              PopupMenuItem(value: 'price_asc', child: Text('価格が安い順')),
              PopupMenuItem(value: 'price_desc', child: Text('価格が高い順')),
              PopupMenuItem(value: 'model_number', child: Text('型番順 (A-Z)')),
            ],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sort, size: 18),
                const SizedBox(width: 4),
                Text(
                  sortLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
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
        tooltip: 'アカウント',
        onPressed: () => context.push('/account'),
      );
    }
    return IconButton(
      icon: const Icon(Icons.person_outline),
      tooltip: 'ログイン',
      onPressed: () => context.push('/login'),
    );
  }

}
