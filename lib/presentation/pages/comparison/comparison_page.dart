import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/product.dart';
import '../../providers/comparison_providers.dart';

class ComparisonPage extends ConsumerStatefulWidget {
  const ComparisonPage({super.key});

  @override
  ConsumerState<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends ConsumerState<ComparisonPage> {
  final _verticalController = ScrollController();
  final _headerVerticalController = ScrollController();

  @override
  void dispose() {
    _verticalController.dispose();
    _headerVerticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(comparisonSelectionProvider);
    final theme = Theme.of(context);

    if (products.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('商品比較')),
        body: const Center(child: Text('比較する商品が選択されていません')),
      );
    }

    final specs = _buildSpecRows(products);

    return Scaffold(
      appBar: AppBar(
        title: const Text('商品比較'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(comparisonSelectionProvider.notifier).clear();
              context.pop();
            },
            child: const Text('全てクリア'),
          ),
        ],
      ),
      body: _buildComparisonTable(context, ref, products, specs, theme),
    );
  }

  Widget _buildComparisonTable(
    BuildContext context,
    WidgetRef ref,
    List<Product> products,
    List<_SpecRow> specs,
    ThemeData theme,
  ) {
    return Row(
      children: [
        // Fixed label column
        SizedBox(
          width: 100,
          child: Column(
            children: [
              // Header spacer (matches product header height)
              const SizedBox(height: 120),
              const Divider(height: 1),
              // Spec labels
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification) {
                      _verticalController.jumpTo(
                        _headerVerticalController.offset,
                      );
                    }
                    return false;
                  },
                  child: ListView.builder(
                    controller: _headerVerticalController,
                    itemCount: specs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 48,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Text(
                          specs[index].label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        // Scrollable product columns
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: products.length * 140.0,
              child: Column(
                children: [
                  // Product headers
                  SizedBox(
                    height: 120,
                    child: Row(
                      children: products
                          .map((p) =>
                              _buildProductHeader(context, ref, p, theme))
                          .toList(),
                    ),
                  ),
                  const Divider(height: 1),
                  // Spec values
                  Expanded(
                    child: ListView.builder(
                      controller: _verticalController,
                      itemCount: specs.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 48,
                          child: Row(
                            children: specs[index].values.map((cell) {
                              return Container(
                                width: 140,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: cell.isHighlighted
                                      ? theme.colorScheme.primaryContainer
                                          .withValues(alpha: 0.3)
                                      : null,
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                ),
                                child: Text(
                                  cell.display,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: cell.isHighlighted
                                        ? FontWeight.bold
                                        : null,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductHeader(
    BuildContext context,
    WidgetRef ref,
    Product product,
    ThemeData theme,
  ) {
    return SizedBox(
      width: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: product.imageUrl != null
                      ? Semantics(
                          image: true,
                          label: product.modelNumber,
                          child: CachedNetworkImage(
                            imageUrl: product.imageUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => const Icon(
                                Icons.inventory_2,
                                color: Colors.grey),
                          ),
                        )
                      : const Icon(Icons.inventory_2, color: Colors.grey),
                ),
              ),
              Positioned(
                top: -4,
                right: -4,
                child: IconButton(
                  icon: const Icon(Icons.cancel, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    ref
                        .read(comparisonSelectionProvider.notifier)
                        .remove(product.id);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            product.modelNumber,
            style: theme.textTheme.labelSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (product.manufacturerName != null)
            Text(
              product.manufacturerName!,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  List<_SpecRow> _buildSpecRows(List<Product> products) {
    final rows = <_SpecRow>[];

    // Manufacturer
    rows.add(_SpecRow(
      label: 'メーカー',
      values: products
          .map((p) => _CellValue(p.manufacturerName ?? '-'))
          .toList(),
    ));

    // List Price (highlight: lowest)
    final validListPrices =
        products.map((p) => p.listPrice).whereType<int>();
    final minListPrice = validListPrices.isEmpty
        ? null
        : validListPrices.reduce((a, b) => a < b ? a : b);
    rows.add(_SpecRow(
      label: '定価',
      values: products
          .map((p) => _CellValue(
                _formatPrice(p.listPrice),
                isHighlighted: p.listPrice != null &&
                    p.listPrice == minListPrice &&
                    validListPrices.length > 1,
              ))
          .toList(),
    ));

    // Street Price (highlight: lowest)
    final validStreetPrices =
        products.map((p) => p.streetPrice).whereType<int>();
    final minStreetPrice = validStreetPrices.isEmpty
        ? null
        : validStreetPrices.reduce((a, b) => a < b ? a : b);
    rows.add(_SpecRow(
      label: '販売価格',
      values: products
          .map((p) => _CellValue(
                _formatPrice(p.streetPrice),
                isHighlighted: p.streetPrice != null &&
                    p.streetPrice == minStreetPrice &&
                    validStreetPrices.length > 1,
              ))
          .toList(),
    ));

    // Voltage
    rows.add(_SpecRow(
      label: '電圧',
      values: products
          .map((p) =>
              _CellValue(p.voltage != null ? '${p.voltage}V' : '-'))
          .toList(),
    ));

    // Width
    rows.add(_SpecRow(
      label: '幅',
      values: products
          .map((p) => _CellValue(
              p.widthMm != null ? '${p.widthMm!.toInt()} mm' : '-'))
          .toList(),
    ));

    // Height
    rows.add(_SpecRow(
      label: '高さ',
      values: products
          .map((p) => _CellValue(
              p.heightMm != null ? '${p.heightMm!.toInt()} mm' : '-'))
          .toList(),
    ));

    // Depth
    rows.add(_SpecRow(
      label: '奥行',
      values: products
          .map((p) => _CellValue(
              p.depthMm != null ? '${p.depthMm!.toInt()} mm' : '-'))
          .toList(),
    ));

    // Pipe diameter
    rows.add(_SpecRow(
      label: 'パイプ径',
      values: products
          .map((p) => _CellValue(p.pipeDiameter != null
              ? 'φ${p.pipeDiameter!.toInt()} mm'
              : '-'))
          .toList(),
    ));

    // Airflow (highlight: max)
    final validAirflows =
        products.map((p) => p.airflow).whereType<double>();
    final maxAirflow = validAirflows.isEmpty
        ? null
        : validAirflows.reduce((a, b) => a > b ? a : b);
    rows.add(_SpecRow(
      label: '風量',
      values: products
          .map((p) => _CellValue(
                p.airflow != null ? '${p.airflow!.toInt()} m\u00B3/h' : '-',
                isHighlighted: p.airflow != null &&
                    p.airflow == maxAirflow &&
                    validAirflows.length > 1,
              ))
          .toList(),
    ));

    // Noise level (highlight: lowest)
    final validNoise =
        products.map((p) => p.noiseLevel).whereType<double>();
    final minNoise = validNoise.isEmpty
        ? null
        : validNoise.reduce((a, b) => a < b ? a : b);
    rows.add(_SpecRow(
      label: '騒音',
      values: products
          .map((p) => _CellValue(
                p.noiseLevel != null
                    ? '${p.noiseLevel!.toInt()} dB'
                    : '-',
                isHighlighted: p.noiseLevel != null &&
                    p.noiseLevel == minNoise &&
                    validNoise.length > 1,
              ))
          .toList(),
    ));

    // Power consumption (highlight: lowest)
    final validPowers =
        products.map((p) => p.powerConsumption).whereType<double>();
    final minPower = validPowers.isEmpty
        ? null
        : validPowers.reduce((a, b) => a < b ? a : b);
    rows.add(_SpecRow(
      label: '消費電力',
      values: products
          .map((p) => _CellValue(
                p.powerConsumption != null
                    ? '${p.powerConsumption!.toInt()} W'
                    : '-',
                isHighlighted: p.powerConsumption != null &&
                    p.powerConsumption == minPower &&
                    validPowers.length > 1,
              ))
          .toList(),
    ));

    return rows;
  }

  String _formatPrice(int? price) {
    if (price == null) return '-';
    final str = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return '\u00A5${buffer.toString()}';
  }
}

class _SpecRow {
  final String label;
  final List<_CellValue> values;
  const _SpecRow({required this.label, required this.values});
}

class _CellValue {
  final String display;
  final bool isHighlighted;
  const _CellValue(this.display, {this.isHighlighted = false});
}
