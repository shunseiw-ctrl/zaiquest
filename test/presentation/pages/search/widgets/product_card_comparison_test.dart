import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zaiquest/domain/entities/product.dart';
import 'package:zaiquest/presentation/pages/search/widgets/product_card.dart';

const _testProduct = Product(
  id: 'test-1',
  modelNumber: 'VD-15ZC14',
  name: 'ダクト用換気扇',
  manufacturerId: 'mfr-1',
  source: 'test',
  manufacturerName: 'Panasonic',
);

void main() {
  Widget buildTestWidget({
    bool? isSelectedForComparison,
    ValueChanged<bool>? onComparisonToggle,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: ProductCard(
            product: _testProduct,
            onTap: () {},
            isSelectedForComparison: isSelectedForComparison,
            onComparisonToggle: onComparisonToggle,
          ),
        ),
      ),
    );
  }

  group('ProductCard 比較チェックボックス', () {
    testWidgets('isSelectedForComparison が null の時チェックボックスが非表示',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        isSelectedForComparison: null,
      ));

      expect(find.byType(Checkbox), findsNothing);
    });

    testWidgets('isSelectedForComparison が false の時チェックボックスが表示・未チェック',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        isSelectedForComparison: false,
        onComparisonToggle: (_) {},
      ));

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isFalse);
    });

    testWidgets('isSelectedForComparison が true の時チェックボックスが表示・チェック済み',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        isSelectedForComparison: true,
        onComparisonToggle: (_) {},
      ));

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('チェック切替で onComparisonToggle コールバックが呼ばれること',
        (tester) async {
      bool? toggledValue;

      await tester.pumpWidget(buildTestWidget(
        isSelectedForComparison: false,
        onComparisonToggle: (value) => toggledValue = value,
      ));

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(toggledValue, isNotNull);
    });
  });
}
