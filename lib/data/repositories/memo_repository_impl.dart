import '../../domain/entities/user_memo.dart';
import '../../domain/repositories/memo_repository.dart';
import '../datasources/remote/supabase_product_datasource.dart';

class MemoRepositoryImpl implements MemoRepository {
  final SupabaseProductDatasource _remote;

  MemoRepositoryImpl({required SupabaseProductDatasource remote})
      : _remote = remote;

  @override
  Future<UserMemo?> getMemo(String userId, String productId) async {
    final json = await _remote.getMemo(userId, productId);
    if (json == null) return null;
    return UserMemo(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      productId: json['product_id'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      note: (json['note'] as String?) ?? '',
    );
  }

  @override
  Future<void> saveMemo(UserMemo memo) async {
    await _remote.upsertMemo(
      userId: memo.userId,
      productId: memo.productId,
      quantity: memo.quantity,
      note: memo.note,
    );
  }

  @override
  Future<void> deleteMemo(String userId, String productId) async {
    await _remote.deleteMemo(userId, productId);
  }

  @override
  Future<List<UserMemo>> getUserMemos(String userId) async {
    final rows = await _remote.getUserMemos(userId);
    return rows
        .map((json) => UserMemo(
              id: json['id'] as String,
              userId: json['user_id'] as String,
              productId: json['product_id'] as String,
              quantity: (json['quantity'] as num?)?.toInt() ?? 1,
              note: (json['note'] as String?) ?? '',
            ))
        .toList();
  }
}
