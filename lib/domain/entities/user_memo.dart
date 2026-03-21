import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_memo.freezed.dart';
part 'user_memo.g.dart';

@freezed
abstract class UserMemo with _$UserMemo {
  const factory UserMemo({
    required String id,
    required String userId,
    required String productId,
    @Default(1) int quantity,
    @Default('') String note,
  }) = _UserMemo;

  factory UserMemo.fromJson(Map<String, dynamic> json) =>
      _$UserMemoFromJson(json);
}
