// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_memo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserMemo _$UserMemoFromJson(Map<String, dynamic> json) => _UserMemo(
  id: json['id'] as String,
  userId: json['userId'] as String,
  productId: json['productId'] as String,
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
  note: json['note'] as String? ?? '',
);

Map<String, dynamic> _$UserMemoToJson(_UserMemo instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'productId': instance.productId,
  'quantity': instance.quantity,
  'note': instance.note,
};
