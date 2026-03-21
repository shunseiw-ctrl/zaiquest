import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/auth_provider.dart';
import '../../providers/favorite_providers.dart';
import '../../providers/memo_providers.dart';
import '../../providers/product_providers.dart';
import '../../../domain/entities/user_memo.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  final _noteController = TextEditingController();
  int _quantity = 1;
  bool _memoLoaded = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));
    final theme = Theme.of(context);
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('商品詳細'),
        actions: [
          if (userId != null) _buildFavoriteButton(),
        ],
      ),
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return const Center(child: Text('商品が見つかりません'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                if (product.imageUrl != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl!,
                        height: 200,
                        fit: BoxFit.contain,
                        errorWidget: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 100),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Header
                if (product.manufacturerName != null)
                  Chip(label: Text(product.manufacturerName!)),
                const SizedBox(height: 8),
                Text(
                  product.modelNumber,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(product.name, style: theme.textTheme.titleMedium),
                if (product.isDiscontinued)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '廃番${product.predecessorModel != null ? " → 後継: ${product.predecessorModel}" : ""}',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ),
                const SizedBox(height: 24),

                // Price
                if (product.listPrice != null || product.streetPrice != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('価格', style: theme.textTheme.titleSmall),
                          const SizedBox(height: 8),
                          if (product.listPrice != null)
                            _InfoRow('メーカー希望小売価格',
                                '¥${_formatPrice(product.listPrice!)}（税抜）'),
                          if (product.streetPrice != null)
                            _InfoRow('実勢価格',
                                '¥${_formatPrice(product.streetPrice!)}（税込）'),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),

                // Specs
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('仕様', style: theme.textTheme.titleSmall),
                        const SizedBox(height: 8),
                        if (product.widthMm != null)
                          _InfoRow('幅', '${product.widthMm!.toInt()} mm'),
                        if (product.heightMm != null)
                          _InfoRow('高さ', '${product.heightMm!.toInt()} mm'),
                        if (product.depthMm != null)
                          _InfoRow('奥行', '${product.depthMm!.toInt()} mm'),
                        if (product.pipeDiameter != null)
                          _InfoRow(
                              'パイプ径', '${product.pipeDiameter!.toInt()} mm'),
                        if (product.voltage != null)
                          _InfoRow('電圧', '${product.voltage}V'),
                        if (product.airflow != null)
                          _InfoRow('風量', '${product.airflow} m³/h'),
                        if (product.noiseLevel != null)
                          _InfoRow('騒音', '${product.noiseLevel} dB'),
                        if (product.powerConsumption != null)
                          _InfoRow('消費電力', '${product.powerConsumption} W'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Description / Usage
                if (product.usage != null || product.description != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.usage != null) ...[
                            Text('用途', style: theme.textTheme.titleSmall),
                            const SizedBox(height: 4),
                            Text(product.usage!),
                          ],
                          if (product.description != null) ...[
                            const SizedBox(height: 12),
                            Text('説明', style: theme.textTheme.titleSmall),
                            const SizedBox(height: 4),
                            Text(product.description!),
                          ],
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),

                // Memo section (auth only)
                if (userId != null) _buildMemoSection(theme, userId),

                // Source info + link
                if (product.productUrl != null)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('メーカーページを開く'),
                      onPressed: () => _launchUrl(product.productUrl!),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  'データソース: ${product.source}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('エラー: $error')),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    final isFavAsync = ref.watch(isFavoriteProvider(widget.productId));

    return isFavAsync.when(
      data: (isFav) => IconButton(
        icon: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          color: isFav ? Colors.red : null,
        ),
        onPressed: () => _toggleFavorite(isFav),
      ),
      loading: () => const IconButton(
        icon: Icon(Icons.favorite_border),
        onPressed: null,
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Future<void> _toggleFavorite(bool currentlyFavorite) async {
    final userId = ref.read(currentUserIdProvider)!;
    final repo = ref.read(productRepositoryProvider);

    if (currentlyFavorite) {
      await repo.removeFavorite(userId, widget.productId);
    } else {
      await repo.addFavorite(userId, widget.productId);
    }
    ref.invalidate(isFavoriteProvider(widget.productId));
    ref.invalidate(userFavoritesProvider);
  }

  Widget _buildMemoSection(ThemeData theme, String userId) {
    final memoAsync = ref.watch(productMemoProvider(widget.productId));

    return memoAsync.when(
      data: (memo) {
        if (!_memoLoaded) {
          _memoLoaded = true;
          if (memo != null) {
            _quantity = memo.quantity;
            _noteController.text = memo.note;
          }
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('発注メモ', style: theme.textTheme.titleSmall),
                const SizedBox(height: 12),
                // Quantity
                Row(
                  children: [
                    Text('数量', style: TextStyle(color: Colors.grey[600])),
                    const Spacer(),
                    IconButton.filled(
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                      style: IconButton.styleFrom(
                        minimumSize: const Size(36, 36),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$_quantity',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton.filled(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: () => setState(() => _quantity++),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(36, 36),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Note
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'メモ',
                    hintText: '例: 2F用、色指定あり',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('保存'),
                        onPressed: () => _saveMemo(userId),
                      ),
                    ),
                    if (memo != null) ...[
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('削除'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () => _deleteMemo(userId),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Future<void> _saveMemo(String userId) async {
    final repo = ref.read(memoRepositoryProvider);
    await repo.saveMemo(UserMemo(
      id: '',
      userId: userId,
      productId: widget.productId,
      quantity: _quantity,
      note: _noteController.text.trim(),
    ));
    ref.invalidate(productMemoProvider(widget.productId));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('メモを保存しました')),
      );
    }
  }

  Future<void> _deleteMemo(String userId) async {
    final repo = ref.read(memoRepositoryProvider);
    await repo.deleteMemo(userId, widget.productId);
    setState(() {
      _quantity = 1;
      _noteController.clear();
      _memoLoaded = false;
    });
    ref.invalidate(productMemoProvider(widget.productId));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('メモを削除しました')),
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
