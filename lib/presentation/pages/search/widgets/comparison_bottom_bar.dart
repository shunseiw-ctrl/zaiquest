import 'package:flutter/material.dart';

class ComparisonBottomBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onClear;
  final VoidCallback onCompare;

  const ComparisonBottomBar({
    super.key,
    required this.selectedCount,
    required this.onClear,
    required this.onCompare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Badge(
              label: Text('$selectedCount'),
              child: const Icon(Icons.compare_arrows),
            ),
            const SizedBox(width: 8),
            Text('$selectedCount 件選択中', style: theme.textTheme.bodyMedium),
            const Spacer(),
            TextButton(
              onPressed: onClear,
              child: const Text('クリア'),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: selectedCount >= 2 ? onCompare : null,
              child: const Text('比較する'),
            ),
          ],
        ),
      ),
    );
  }
}
