// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchFilter {

// Text search
 String? get query;// Dimension ranges (mm)
 double? get widthMin; double? get widthMax; double? get heightMin; double? get heightMax; double? get depthMin; double? get depthMax; double? get pipeDiameterMin; double? get pipeDiameterMax;// Voltage filter
 int? get voltage;// null = all, 100, 200
// Price range
 int? get priceMin; int? get priceMax;// Manufacturer filter (multiple select)
 List<String> get manufacturerIds;// Category filter
 String? get categoryId;// Include discontinued
 bool get includeDiscontinued;// Pagination
 int get offset; int get limit;
/// Create a copy of SearchFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchFilterCopyWith<SearchFilter> get copyWith => _$SearchFilterCopyWithImpl<SearchFilter>(this as SearchFilter, _$identity);

  /// Serializes this SearchFilter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchFilter&&(identical(other.query, query) || other.query == query)&&(identical(other.widthMin, widthMin) || other.widthMin == widthMin)&&(identical(other.widthMax, widthMax) || other.widthMax == widthMax)&&(identical(other.heightMin, heightMin) || other.heightMin == heightMin)&&(identical(other.heightMax, heightMax) || other.heightMax == heightMax)&&(identical(other.depthMin, depthMin) || other.depthMin == depthMin)&&(identical(other.depthMax, depthMax) || other.depthMax == depthMax)&&(identical(other.pipeDiameterMin, pipeDiameterMin) || other.pipeDiameterMin == pipeDiameterMin)&&(identical(other.pipeDiameterMax, pipeDiameterMax) || other.pipeDiameterMax == pipeDiameterMax)&&(identical(other.voltage, voltage) || other.voltage == voltage)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax)&&const DeepCollectionEquality().equals(other.manufacturerIds, manufacturerIds)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.includeDiscontinued, includeDiscontinued) || other.includeDiscontinued == includeDiscontinued)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query,widthMin,widthMax,heightMin,heightMax,depthMin,depthMax,pipeDiameterMin,pipeDiameterMax,voltage,priceMin,priceMax,const DeepCollectionEquality().hash(manufacturerIds),categoryId,includeDiscontinued,offset,limit);

@override
String toString() {
  return 'SearchFilter(query: $query, widthMin: $widthMin, widthMax: $widthMax, heightMin: $heightMin, heightMax: $heightMax, depthMin: $depthMin, depthMax: $depthMax, pipeDiameterMin: $pipeDiameterMin, pipeDiameterMax: $pipeDiameterMax, voltage: $voltage, priceMin: $priceMin, priceMax: $priceMax, manufacturerIds: $manufacturerIds, categoryId: $categoryId, includeDiscontinued: $includeDiscontinued, offset: $offset, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $SearchFilterCopyWith<$Res>  {
  factory $SearchFilterCopyWith(SearchFilter value, $Res Function(SearchFilter) _then) = _$SearchFilterCopyWithImpl;
@useResult
$Res call({
 String? query, double? widthMin, double? widthMax, double? heightMin, double? heightMax, double? depthMin, double? depthMax, double? pipeDiameterMin, double? pipeDiameterMax, int? voltage, int? priceMin, int? priceMax, List<String> manufacturerIds, String? categoryId, bool includeDiscontinued, int offset, int limit
});




}
/// @nodoc
class _$SearchFilterCopyWithImpl<$Res>
    implements $SearchFilterCopyWith<$Res> {
  _$SearchFilterCopyWithImpl(this._self, this._then);

  final SearchFilter _self;
  final $Res Function(SearchFilter) _then;

/// Create a copy of SearchFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = freezed,Object? widthMin = freezed,Object? widthMax = freezed,Object? heightMin = freezed,Object? heightMax = freezed,Object? depthMin = freezed,Object? depthMax = freezed,Object? pipeDiameterMin = freezed,Object? pipeDiameterMax = freezed,Object? voltage = freezed,Object? priceMin = freezed,Object? priceMax = freezed,Object? manufacturerIds = null,Object? categoryId = freezed,Object? includeDiscontinued = null,Object? offset = null,Object? limit = null,}) {
  return _then(_self.copyWith(
query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,widthMin: freezed == widthMin ? _self.widthMin : widthMin // ignore: cast_nullable_to_non_nullable
as double?,widthMax: freezed == widthMax ? _self.widthMax : widthMax // ignore: cast_nullable_to_non_nullable
as double?,heightMin: freezed == heightMin ? _self.heightMin : heightMin // ignore: cast_nullable_to_non_nullable
as double?,heightMax: freezed == heightMax ? _self.heightMax : heightMax // ignore: cast_nullable_to_non_nullable
as double?,depthMin: freezed == depthMin ? _self.depthMin : depthMin // ignore: cast_nullable_to_non_nullable
as double?,depthMax: freezed == depthMax ? _self.depthMax : depthMax // ignore: cast_nullable_to_non_nullable
as double?,pipeDiameterMin: freezed == pipeDiameterMin ? _self.pipeDiameterMin : pipeDiameterMin // ignore: cast_nullable_to_non_nullable
as double?,pipeDiameterMax: freezed == pipeDiameterMax ? _self.pipeDiameterMax : pipeDiameterMax // ignore: cast_nullable_to_non_nullable
as double?,voltage: freezed == voltage ? _self.voltage : voltage // ignore: cast_nullable_to_non_nullable
as int?,priceMin: freezed == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as int?,priceMax: freezed == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as int?,manufacturerIds: null == manufacturerIds ? _self.manufacturerIds : manufacturerIds // ignore: cast_nullable_to_non_nullable
as List<String>,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,includeDiscontinued: null == includeDiscontinued ? _self.includeDiscontinued : includeDiscontinued // ignore: cast_nullable_to_non_nullable
as bool,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchFilter].
extension SearchFilterPatterns on SearchFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchFilter value)  $default,){
final _that = this;
switch (_that) {
case _SearchFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchFilter value)?  $default,){
final _that = this;
switch (_that) {
case _SearchFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? query,  double? widthMin,  double? widthMax,  double? heightMin,  double? heightMax,  double? depthMin,  double? depthMax,  double? pipeDiameterMin,  double? pipeDiameterMax,  int? voltage,  int? priceMin,  int? priceMax,  List<String> manufacturerIds,  String? categoryId,  bool includeDiscontinued,  int offset,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchFilter() when $default != null:
return $default(_that.query,_that.widthMin,_that.widthMax,_that.heightMin,_that.heightMax,_that.depthMin,_that.depthMax,_that.pipeDiameterMin,_that.pipeDiameterMax,_that.voltage,_that.priceMin,_that.priceMax,_that.manufacturerIds,_that.categoryId,_that.includeDiscontinued,_that.offset,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? query,  double? widthMin,  double? widthMax,  double? heightMin,  double? heightMax,  double? depthMin,  double? depthMax,  double? pipeDiameterMin,  double? pipeDiameterMax,  int? voltage,  int? priceMin,  int? priceMax,  List<String> manufacturerIds,  String? categoryId,  bool includeDiscontinued,  int offset,  int limit)  $default,) {final _that = this;
switch (_that) {
case _SearchFilter():
return $default(_that.query,_that.widthMin,_that.widthMax,_that.heightMin,_that.heightMax,_that.depthMin,_that.depthMax,_that.pipeDiameterMin,_that.pipeDiameterMax,_that.voltage,_that.priceMin,_that.priceMax,_that.manufacturerIds,_that.categoryId,_that.includeDiscontinued,_that.offset,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? query,  double? widthMin,  double? widthMax,  double? heightMin,  double? heightMax,  double? depthMin,  double? depthMax,  double? pipeDiameterMin,  double? pipeDiameterMax,  int? voltage,  int? priceMin,  int? priceMax,  List<String> manufacturerIds,  String? categoryId,  bool includeDiscontinued,  int offset,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _SearchFilter() when $default != null:
return $default(_that.query,_that.widthMin,_that.widthMax,_that.heightMin,_that.heightMax,_that.depthMin,_that.depthMax,_that.pipeDiameterMin,_that.pipeDiameterMax,_that.voltage,_that.priceMin,_that.priceMax,_that.manufacturerIds,_that.categoryId,_that.includeDiscontinued,_that.offset,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchFilter implements SearchFilter {
  const _SearchFilter({this.query, this.widthMin, this.widthMax, this.heightMin, this.heightMax, this.depthMin, this.depthMax, this.pipeDiameterMin, this.pipeDiameterMax, this.voltage, this.priceMin, this.priceMax, final  List<String> manufacturerIds = const [], this.categoryId, this.includeDiscontinued = false, this.offset = 0, this.limit = 20}): _manufacturerIds = manufacturerIds;
  factory _SearchFilter.fromJson(Map<String, dynamic> json) => _$SearchFilterFromJson(json);

// Text search
@override final  String? query;
// Dimension ranges (mm)
@override final  double? widthMin;
@override final  double? widthMax;
@override final  double? heightMin;
@override final  double? heightMax;
@override final  double? depthMin;
@override final  double? depthMax;
@override final  double? pipeDiameterMin;
@override final  double? pipeDiameterMax;
// Voltage filter
@override final  int? voltage;
// null = all, 100, 200
// Price range
@override final  int? priceMin;
@override final  int? priceMax;
// Manufacturer filter (multiple select)
 final  List<String> _manufacturerIds;
// Manufacturer filter (multiple select)
@override@JsonKey() List<String> get manufacturerIds {
  if (_manufacturerIds is EqualUnmodifiableListView) return _manufacturerIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_manufacturerIds);
}

// Category filter
@override final  String? categoryId;
// Include discontinued
@override@JsonKey() final  bool includeDiscontinued;
// Pagination
@override@JsonKey() final  int offset;
@override@JsonKey() final  int limit;

/// Create a copy of SearchFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchFilterCopyWith<_SearchFilter> get copyWith => __$SearchFilterCopyWithImpl<_SearchFilter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchFilterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchFilter&&(identical(other.query, query) || other.query == query)&&(identical(other.widthMin, widthMin) || other.widthMin == widthMin)&&(identical(other.widthMax, widthMax) || other.widthMax == widthMax)&&(identical(other.heightMin, heightMin) || other.heightMin == heightMin)&&(identical(other.heightMax, heightMax) || other.heightMax == heightMax)&&(identical(other.depthMin, depthMin) || other.depthMin == depthMin)&&(identical(other.depthMax, depthMax) || other.depthMax == depthMax)&&(identical(other.pipeDiameterMin, pipeDiameterMin) || other.pipeDiameterMin == pipeDiameterMin)&&(identical(other.pipeDiameterMax, pipeDiameterMax) || other.pipeDiameterMax == pipeDiameterMax)&&(identical(other.voltage, voltage) || other.voltage == voltage)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax)&&const DeepCollectionEquality().equals(other._manufacturerIds, _manufacturerIds)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.includeDiscontinued, includeDiscontinued) || other.includeDiscontinued == includeDiscontinued)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query,widthMin,widthMax,heightMin,heightMax,depthMin,depthMax,pipeDiameterMin,pipeDiameterMax,voltage,priceMin,priceMax,const DeepCollectionEquality().hash(_manufacturerIds),categoryId,includeDiscontinued,offset,limit);

@override
String toString() {
  return 'SearchFilter(query: $query, widthMin: $widthMin, widthMax: $widthMax, heightMin: $heightMin, heightMax: $heightMax, depthMin: $depthMin, depthMax: $depthMax, pipeDiameterMin: $pipeDiameterMin, pipeDiameterMax: $pipeDiameterMax, voltage: $voltage, priceMin: $priceMin, priceMax: $priceMax, manufacturerIds: $manufacturerIds, categoryId: $categoryId, includeDiscontinued: $includeDiscontinued, offset: $offset, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$SearchFilterCopyWith<$Res> implements $SearchFilterCopyWith<$Res> {
  factory _$SearchFilterCopyWith(_SearchFilter value, $Res Function(_SearchFilter) _then) = __$SearchFilterCopyWithImpl;
@override @useResult
$Res call({
 String? query, double? widthMin, double? widthMax, double? heightMin, double? heightMax, double? depthMin, double? depthMax, double? pipeDiameterMin, double? pipeDiameterMax, int? voltage, int? priceMin, int? priceMax, List<String> manufacturerIds, String? categoryId, bool includeDiscontinued, int offset, int limit
});




}
/// @nodoc
class __$SearchFilterCopyWithImpl<$Res>
    implements _$SearchFilterCopyWith<$Res> {
  __$SearchFilterCopyWithImpl(this._self, this._then);

  final _SearchFilter _self;
  final $Res Function(_SearchFilter) _then;

/// Create a copy of SearchFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = freezed,Object? widthMin = freezed,Object? widthMax = freezed,Object? heightMin = freezed,Object? heightMax = freezed,Object? depthMin = freezed,Object? depthMax = freezed,Object? pipeDiameterMin = freezed,Object? pipeDiameterMax = freezed,Object? voltage = freezed,Object? priceMin = freezed,Object? priceMax = freezed,Object? manufacturerIds = null,Object? categoryId = freezed,Object? includeDiscontinued = null,Object? offset = null,Object? limit = null,}) {
  return _then(_SearchFilter(
query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,widthMin: freezed == widthMin ? _self.widthMin : widthMin // ignore: cast_nullable_to_non_nullable
as double?,widthMax: freezed == widthMax ? _self.widthMax : widthMax // ignore: cast_nullable_to_non_nullable
as double?,heightMin: freezed == heightMin ? _self.heightMin : heightMin // ignore: cast_nullable_to_non_nullable
as double?,heightMax: freezed == heightMax ? _self.heightMax : heightMax // ignore: cast_nullable_to_non_nullable
as double?,depthMin: freezed == depthMin ? _self.depthMin : depthMin // ignore: cast_nullable_to_non_nullable
as double?,depthMax: freezed == depthMax ? _self.depthMax : depthMax // ignore: cast_nullable_to_non_nullable
as double?,pipeDiameterMin: freezed == pipeDiameterMin ? _self.pipeDiameterMin : pipeDiameterMin // ignore: cast_nullable_to_non_nullable
as double?,pipeDiameterMax: freezed == pipeDiameterMax ? _self.pipeDiameterMax : pipeDiameterMax // ignore: cast_nullable_to_non_nullable
as double?,voltage: freezed == voltage ? _self.voltage : voltage // ignore: cast_nullable_to_non_nullable
as int?,priceMin: freezed == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as int?,priceMax: freezed == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as int?,manufacturerIds: null == manufacturerIds ? _self._manufacturerIds : manufacturerIds // ignore: cast_nullable_to_non_nullable
as List<String>,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,includeDiscontinued: null == includeDiscontinued ? _self.includeDiscontinued : includeDiscontinued // ignore: cast_nullable_to_non_nullable
as bool,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
