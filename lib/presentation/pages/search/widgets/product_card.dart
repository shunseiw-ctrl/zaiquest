import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final bool? isSelectedForComparison;
  final ValueChanged<bool>? onComparisonToggle;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.isSelectedForComparison,
    this.onComparisonToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: product.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: product.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image,
                                color: Colors.grey),
                          ),
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.inventory_2,
                              color: Colors.grey),
                        ),
                ),
              ),
              const SizedBox(width: 12),

              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Model number + manufacturer
                    Row(
                      children: [
                        if (product.manufacturerName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              product.manufacturerName!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        if (product.manufacturerName != null)
                          const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            product.modelNumber,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Product name
                    Text(
                      product.name,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Dimensions
                    Row(
                      children: [
                        if (product.widthMm != null ||
                            product.heightMm != null ||
                            product.depthMm != null)
                          Icon(Icons.straighten,
                              size: 14, color: Colors.grey[600]),
                        if (product.widthMm != null ||
                            product.heightMm != null ||
                            product.depthMm != null)
                          const SizedBox(width: 4),
                        Text(
                          _dimensionText(product),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const Spacer(),
                        if (product.voltage != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${product.voltage}V',
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                      ],
                    ),
                    // Spec chips (airflow, noise, power)
                    if (product.airflow != null ||
                        product.noiseLevel != null ||
                        product.powerConsumption != null) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (product.airflow != null)
                            _specChip(Icons.air, '${product.airflow!.toInt()} m³/h', theme),
                          if (product.noiseLevel != null)
                            _specChip(Icons.volume_up, '${product.noiseLevel!.toInt()} dB', theme),
                          if (product.powerConsumption != null)
                            _specChip(Icons.bolt, '${product.powerConsumption!.toInt()} W', theme),
                        ],
                      ),
                    ],
                    const SizedBox(height: 4),

                    // Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (product.listPrice != null)
                          Text(
                            '¥${_formatPrice(product.listPrice!)}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (product.isDiscontinued)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '廃番',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.red[700],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          ),
        ),
        if (isSelectedForComparison != null)
          Positioned(
            top: 4,
            right: 4,
            child: Checkbox(
              value: isSelectedForComparison!,
              onChanged: (v) => onComparisonToggle?.call(v ?? false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _specChip(IconData icon, String label, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[700]),
          const SizedBox(width: 3),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  String _dimensionText(Product p) {
    final parts = <String>[];
    if (p.widthMm != null) parts.add('W${p.widthMm!.toInt()}');
    if (p.heightMm != null) parts.add('H${p.heightMm!.toInt()}');
    if (p.depthMm != null) parts.add('D${p.depthMm!.toInt()}');
    if (parts.isEmpty) return '';
    return '${parts.join(' × ')} mm';
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
