import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/search_filter.dart';
import '../../../providers/product_providers.dart';

class SearchBarWidget extends ConsumerStatefulWidget {
  final VoidCallback onFilterToggle;
  final bool showFilters;

  const SearchBarWidget({
    super.key,
    required this.onFilterToggle,
    required this.showFilters,
  });

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  final _controller = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: '型番で検索 (例: VD-15ZC)',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _debounceTimer?.cancel();
                        _controller.clear();
                        ref
                            .read(searchFilterNotifierProvider.notifier)
                            .updateQuery('');
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {}); // Update clear button visibility
              _debounceTimer?.cancel();
              _debounceTimer = Timer(const Duration(milliseconds: 300), () {
                ref
                    .read(searchFilterNotifierProvider.notifier)
                    .updateQuery(value);
              });
            },
            onSubmitted: (value) {
              _debounceTimer?.cancel();
              ref
                  .read(searchFilterNotifierProvider.notifier)
                  .updateQuery(value);
            },
          ),
        ),
        const SizedBox(width: 8),
        Badge(
          isLabelVisible: ref.watch(searchFilterNotifierProvider).activeFilterCount > 0,
          label: Text('${ref.watch(searchFilterNotifierProvider).activeFilterCount}'),
          child: IconButton.filledTonal(
            icon: Icon(
              widget.showFilters ? Icons.filter_list_off : Icons.filter_list,
            ),
            onPressed: widget.onFilterToggle,
          ),
        ),
      ],
    );
  }
}
