import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zaiquest/presentation/pages/search/widgets/comparison_bottom_bar.dart';

void main() {
  Widget buildTestWidget({
    required int selectedCount,
    required VoidCallback onClear,
    required VoidCallback onCompare,
  }) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: ComparisonBottomBar(
          selectedCount: selectedCount,
          onClear: onClear,
          onCompare: onCompare,
        ),
      ),
    );
  }

  group('ComparisonBottomBar', () {
    testWidgets('選択件数が正しく表示されること', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        selectedCount: 3,
        onClear: () {},
        onCompare: () {},
      ));

      expect(find.text('3 件選択中'), findsOneWidget);
    });

    testWidgets('クリアボタンのタップでonClearが呼ばれること', (tester) async {
      var clearCalled = false;

      await tester.pumpWidget(buildTestWidget(
        selectedCount: 2,
        onClear: () => clearCalled = true,
        onCompare: () {},
      ));

      await tester.tap(find.text('クリア'));
      expect(clearCalled, isTrue);
    });

    testWidgets('比較ボタンが2件以上で有効であること', (tester) async {
      var compareCalled = false;

      await tester.pumpWidget(buildTestWidget(
        selectedCount: 2,
        onClear: () {},
        onCompare: () => compareCalled = true,
      ));

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);

      await tester.tap(find.text('比較する'));
      expect(compareCalled, isTrue);
    });

    testWidgets('比較ボタンが1件以下で無効であること', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        selectedCount: 1,
        onClear: () {},
        onCompare: () {},
      ));

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('比較ボタンが0件で無効であること', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        selectedCount: 0,
        onClear: () {},
        onCompare: () {},
      ));

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('比較ボタンタップでonCompareが呼ばれること', (tester) async {
      var compareCalled = false;

      await tester.pumpWidget(buildTestWidget(
        selectedCount: 3,
        onClear: () {},
        onCompare: () => compareCalled = true,
      ));

      await tester.tap(find.text('比較する'));
      expect(compareCalled, isTrue);
    });
  });
}
