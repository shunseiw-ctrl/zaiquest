import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/memo_repository_impl.dart';
import '../../domain/entities/user_memo.dart';
import '../../domain/repositories/memo_repository.dart';
import 'auth_provider.dart';
import 'product_providers.dart';

part 'memo_providers.g.dart';

@Riverpod(keepAlive: true)
MemoRepository memoRepository(MemoRepositoryRef ref) {
  return MemoRepositoryImpl(
    remote: ref.watch(supabaseProductDatasourceProvider),
  );
}

@riverpod
Future<UserMemo?> productMemo(ProductMemoRef ref, String productId) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;
  final repository = ref.watch(memoRepositoryProvider);
  return repository.getMemo(userId, productId);
}
