import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/product.dart';

part 'comparison_providers.g.dart';

@Riverpod(keepAlive: true)
class ComparisonSelection extends _$ComparisonSelection {
  static const maxItems = 4;

  @override
  List<Product> build() => [];

  void toggle(Product product) {
    final exists = state.any((p) => p.id == product.id);
    if (exists) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      if (state.length >= maxItems) return;
      state = [...state, product];
    }
  }

  bool isSelected(String productId) => state.any((p) => p.id == productId);

  void clear() => state = [];

  void remove(String productId) =>
      state = state.where((p) => p.id != productId).toList();
}
