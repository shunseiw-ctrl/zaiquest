import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zaiquest/domain/entities/product.dart';
import 'package:zaiquest/presentation/providers/comparison_providers.dart';

Product _makeProduct(String id) => Product(
      id: id,
      modelNumber: 'MODEL-$id',
      name: 'テスト商品 $id',
      manufacturerId: 'mfr-1',
      source: 'test',
    );

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('ComparisonSelection Notifier', () {
    test('初期状態が空リストであること', () {
      final state = container.read(comparisonSelectionProvider);
      expect(state, isEmpty);
    });

    test('toggle() で商品を追加できること', () {
      final notifier =
          container.read(comparisonSelectionProvider.notifier);
      final product = _makeProduct('p1');

      notifier.toggle(product);

      final state = container.read(comparisonSelectionProvider);
      expect(state, hasLength(1));
      expect(state.first.id, 'p1');
    });

    test('toggle() で選択済み商品を削除できること', () {
      final notifier =
          container.read(comparisonSelectionProvider.notifier);
      final product = _makeProduct('p1');

      notifier.toggle(product); // add
      notifier.toggle(product); // remove

      final state = container.read(comparisonSelectionProvider);
      expect(state, isEmpty);
    });

    test('isSelected() が選択状態を正しく返すこと', () {
      final notifier =
          container.read(comparisonSelectionProvider.notifier);
      notifier.toggle(_makeProduct('p1'));

      expect(notifier.isSelected('p1'), isTrue);
      expect(notifier.isSelected('p2'), isFalse);
    });

    test('clear() で全商品をクリアできること', () {
      final notifier =
          container.read(comparisonSelectionProvider.notifier);
      notifier.toggle(_makeProduct('p1'));
      notifier.toggle(_makeProduct('p2'));
      notifier.toggle(_makeProduct('p3'));

      notifier.clear();

      final state = container.read(comparisonSelectionProvider);
      expect(state, isEmpty);
    });

    test('remove() で特定商品を削除できること', () {
      final notifier =
          container.read(comparisonSelectionProvider.notifier);
      notifier.toggle(_makeProduct('p1'));
      notifier.toggle(_makeProduct('p2'));
      notifier.toggle(_makeProduct('p3'));

      notifier.remove('p2');

      final state = container.read(comparisonSelectionProvider);
      expect(state, hasLength(2));
      expect(state.map((p) => p.id), containsAll(['p1', 'p3']));
      expect(state.map((p) => p.id), isNot(contains('p2')));
    });

    test('maxItems(4)制限: 5件目はtoggleで追加されないこと', () {
      final notifier =
          container.read(comparisonSelectionProvider.notifier);

      notifier.toggle(_makeProduct('p1'));
      notifier.toggle(_makeProduct('p2'));
      notifier.toggle(_makeProduct('p3'));
      notifier.toggle(_makeProduct('p4'));
      notifier.toggle(_makeProduct('p5')); // should be ignored

      final state = container.read(comparisonSelectionProvider);
      expect(state, hasLength(4));
      expect(state.map((p) => p.id), isNot(contains('p5')));
    });

    test('maxItems到達後でも既存商品のtoggle(削除)は可能', () {
      final notifier =
          container.read(comparisonSelectionProvider.notifier);

      notifier.toggle(_makeProduct('p1'));
      notifier.toggle(_makeProduct('p2'));
      notifier.toggle(_makeProduct('p3'));
      notifier.toggle(_makeProduct('p4'));

      // Remove one by toggling
      notifier.toggle(_makeProduct('p2'));
      final state = container.read(comparisonSelectionProvider);
      expect(state, hasLength(3));
      expect(state.map((p) => p.id), isNot(contains('p2')));
    });

    test('remove() で存在しないIDを指定してもエラーにならないこと', () {
      final notifier =
          container.read(comparisonSelectionProvider.notifier);
      notifier.toggle(_makeProduct('p1'));

      // Should not throw
      notifier.remove('nonexistent');

      final state = container.read(comparisonSelectionProvider);
      expect(state, hasLength(1));
    });
  });
}
