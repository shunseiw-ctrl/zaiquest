// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_memo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserMemo {

 String get id; String get userId; String get productId; int get quantity; String get note;
/// Create a copy of UserMemo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserMemoCopyWith<UserMemo> get copyWith => _$UserMemoCopyWithImpl<UserMemo>(this as UserMemo, _$identity);

  /// Serializes this UserMemo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserMemo&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,productId,quantity,note);

@override
String toString() {
  return 'UserMemo(id: $id, userId: $userId, productId: $productId, quantity: $quantity, note: $note)';
}


}

/// @nodoc
abstract mixin class $UserMemoCopyWith<$Res>  {
  factory $UserMemoCopyWith(UserMemo value, $Res Function(UserMemo) _then) = _$UserMemoCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String productId, int quantity, String note
});




}
/// @nodoc
class _$UserMemoCopyWithImpl<$Res>
    implements $UserMemoCopyWith<$Res> {
  _$UserMemoCopyWithImpl(this._self, this._then);

  final UserMemo _self;
  final $Res Function(UserMemo) _then;

/// Create a copy of UserMemo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? productId = null,Object? quantity = null,Object? note = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserMemo].
extension UserMemoPatterns on UserMemo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserMemo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserMemo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserMemo value)  $default,){
final _that = this;
switch (_that) {
case _UserMemo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserMemo value)?  $default,){
final _that = this;
switch (_that) {
case _UserMemo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String productId,  int quantity,  String note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserMemo() when $default != null:
return $default(_that.id,_that.userId,_that.productId,_that.quantity,_that.note);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String productId,  int quantity,  String note)  $default,) {final _that = this;
switch (_that) {
case _UserMemo():
return $default(_that.id,_that.userId,_that.productId,_that.quantity,_that.note);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String productId,  int quantity,  String note)?  $default,) {final _that = this;
switch (_that) {
case _UserMemo() when $default != null:
return $default(_that.id,_that.userId,_that.productId,_that.quantity,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserMemo implements UserMemo {
  const _UserMemo({required this.id, required this.userId, required this.productId, this.quantity = 1, this.note = ''});
  factory _UserMemo.fromJson(Map<String, dynamic> json) => _$UserMemoFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String productId;
@override@JsonKey() final  int quantity;
@override@JsonKey() final  String note;

/// Create a copy of UserMemo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserMemoCopyWith<_UserMemo> get copyWith => __$UserMemoCopyWithImpl<_UserMemo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserMemoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserMemo&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,productId,quantity,note);

@override
String toString() {
  return 'UserMemo(id: $id, userId: $userId, productId: $productId, quantity: $quantity, note: $note)';
}


}

/// @nodoc
abstract mixin class _$UserMemoCopyWith<$Res> implements $UserMemoCopyWith<$Res> {
  factory _$UserMemoCopyWith(_UserMemo value, $Res Function(_UserMemo) _then) = __$UserMemoCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String productId, int quantity, String note
});




}
/// @nodoc
class __$UserMemoCopyWithImpl<$Res>
    implements _$UserMemoCopyWith<$Res> {
  __$UserMemoCopyWithImpl(this._self, this._then);

  final _UserMemo _self;
  final $Res Function(_UserMemo) _then;

/// Create a copy of UserMemo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? productId = null,Object? quantity = null,Object? note = null,}) {
  return _then(_UserMemo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
