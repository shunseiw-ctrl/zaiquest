import 'package:flutter_test/flutter_test.dart';
import 'package:zaiquest/domain/entities/user_memo.dart';

void main() {
  group('UserMemo entity', () {
    test('creates with required fields and defaults', () {
      const memo = UserMemo(
        id: 'memo-1',
        userId: 'user-1',
        productId: 'prod-1',
      );

      expect(memo.id, 'memo-1');
      expect(memo.userId, 'user-1');
      expect(memo.productId, 'prod-1');
      expect(memo.quantity, 1);
      expect(memo.note, '');
    });

    test('creates with all fields', () {
      const memo = UserMemo(
        id: 'memo-2',
        userId: 'user-1',
        productId: 'prod-2',
        quantity: 5,
        note: '2F用',
      );

      expect(memo.quantity, 5);
      expect(memo.note, '2F用');
    });

    test('copyWith works', () {
      const memo = UserMemo(
        id: 'memo-1',
        userId: 'user-1',
        productId: 'prod-1',
      );

      final updated = memo.copyWith(quantity: 3, note: '色指定あり');
      expect(updated.quantity, 3);
      expect(updated.note, '色指定あり');
      expect(updated.id, 'memo-1');
      expect(updated.userId, 'user-1');
    });

    test('fromJson / toJson roundtrip', () {
      const memo = UserMemo(
        id: 'memo-1',
        userId: 'user-1',
        productId: 'prod-1',
        quantity: 2,
        note: 'テストメモ',
      );

      final json = memo.toJson();
      final restored = UserMemo.fromJson(json);
      expect(restored, memo);
    });
  });
}
