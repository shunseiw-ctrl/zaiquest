import '../entities/user_memo.dart';

abstract class MemoRepository {
  Future<UserMemo?> getMemo(String userId, String productId);
  Future<void> saveMemo(UserMemo memo);
  Future<void> deleteMemo(String userId, String productId);
  Future<List<UserMemo>> getUserMemos(String userId);
}
