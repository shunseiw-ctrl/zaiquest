import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/product_providers.dart';

class FilterPanel extends ConsumerWidget {
  const FilterPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(searchFilterNotifierProvider);
    final notifier = ref.read(searchFilterNotifierProvider.notifier);
    final manufacturers = ref.watch(manufacturersProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category filter
          Text('カテゴリ', style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          categoriesAsync.when(
            data: (categories) => Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('全て'),
                  selected: filter.categoryId == null,
                  onSelected: (_) => notifier.updateCategory(null),
                ),
                ...categories.map((c) {
                  final id = c['id'] as String;
                  final name = c['name'] as String;
                  return ChoiceChip(
                    label: Text(name),
                    selected: filter.categoryId == id,
                    onSelected: (_) => notifier.updateCategory(
                      filter.categoryId == id ? null : id,
                    ),
                  );
                }),
              ],
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),

          // Voltage toggle
          Text('電圧', style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          SegmentedButton<int?>(
            segments: const [
              ButtonSegment(value: null, label: Text('全て')),
              ButtonSegment(value: 100, label: Text('100V')),
              ButtonSegment(value: 200, label: Text('200V')),
            ],
            selected: {filter.voltage},
            onSelectionChanged: (selected) {
              notifier.updateVoltage(selected.first);
            },
          ),
          const SizedBox(height: 12),

          // Width range
          _DimensionSlider(
            label: '幅 (W)',
            unit: 'mm',
            min: 0,
            max: 1000,
            currentMin: filter.widthMin,
            currentMax: filter.widthMax,
            onChanged: notifier.updateWidthRange,
          ),
          const SizedBox(height: 8),

          // Height range
          _DimensionSlider(
            label: '高さ (H)',
            unit: 'mm',
            min: 0,
            max: 1000,
            currentMin: filter.heightMin,
            currentMax: filter.heightMax,
            onChanged: notifier.updateHeightRange,
          ),
          const SizedBox(height: 8),

          // Depth range
          _DimensionSlider(
            label: '奥行 (D)',
            unit: 'mm',
            min: 0,
            max: 500,
            currentMin: filter.depthMin,
            currentMax: filter.depthMax,
            onChanged: notifier.updateDepthRange,
          ),
          const SizedBox(height: 8),

          // Pipe diameter
          _DimensionSlider(
            label: 'パイプ径',
            unit: 'mm',
            min: 0,
            max: 300,
            currentMin: filter.pipeDiameterMin,
            currentMax: filter.pipeDiameterMax,
            onChanged: notifier.updatePipeDiameterRange,
          ),
          const SizedBox(height: 12),

          // Price range
          _DimensionSlider(
            label: '価格',
            unit: '円',
            min: 0,
            max: 200000,
            divisions: 40,
            currentMin: filter.priceMin?.toDouble(),
            currentMax: filter.priceMax?.toDouble(),
            onChanged: (min, max) {
              notifier.updatePriceRange(min?.toInt(), max?.toInt());
            },
          ),
          const SizedBox(height: 12),

          // Manufacturers
          Text('メーカー', style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          manufacturers.when(
            data: (list) => Wrap(
              spacing: 8,
              children: list.map((m) {
                final id = m['id'] as String;
                final name = m['name'] as String;
                final selected = filter.manufacturerIds.contains(id);
                return FilterChip(
                  label: Text(name),
                  selected: selected,
                  onSelected: (_) => notifier.toggleManufacturer(id),
                );
              }).toList(),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 8),

          // Include discontinued
          SwitchListTile(
            title: const Text('廃番品も表示'),
            value: filter.includeDiscontinued,
            onChanged: (_) => notifier.toggleDiscontinued(),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),

          // Reset button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('フィルタをリセット'),
              onPressed: () => notifier.resetFilters(),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class _DimensionSlider extends StatelessWidget {
  final String label;
  final String unit;
  final double min;
  final double max;
  final int? divisions;
  final double? currentMin;
  final double? currentMax;
  final void Function(double?, double?) onChanged;

  const _DimensionSlider({
    required this.label,
    required this.unit,
    required this.min,
    required this.max,
    this.divisions,
    required this.currentMin,
    required this.currentMax,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final start = currentMin ?? min;
    final end = currentMax ?? max;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.titleSmall),
            Text(
              '${start.toInt()}〜${end.toInt()} $unit',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        RangeSlider(
          values: RangeValues(start, end),
          min: min,
          max: max,
          divisions: divisions ?? ((max - min) ~/ 10).clamp(10, 100),
          onChanged: (values) {
            final newMin = values.start == min ? null : values.start;
            final newMax = values.end == max ? null : values.end;
            onChanged(newMin, newMax);
          },
        ),
      ],
    );
  }
}
