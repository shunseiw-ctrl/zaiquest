// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String get id; String get modelNumber; String get name; String get manufacturerId; String? get categoryId;// Dimensions (mm)
 double? get widthMm; double? get heightMm; double? get depthMm; double? get pipeDiameter;// Specs
 int? get voltage; double? get airflow; double? get noiseLevel; double? get powerConsumption;// Price
 int? get listPrice; int? get streetPrice;// Meta
 String? get productUrl; String? get imageUrl; String? get usage; String? get description; bool get isDiscontinued; String? get predecessorModel;// Source
 String get source; String? get sourceId;// Relations (populated after join)
 String? get manufacturerName; String? get categoryName;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.modelNumber, modelNumber) || other.modelNumber == modelNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.manufacturerId, manufacturerId) || other.manufacturerId == manufacturerId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.widthMm, widthMm) || other.widthMm == widthMm)&&(identical(other.heightMm, heightMm) || other.heightMm == heightMm)&&(identical(other.depthMm, depthMm) || other.depthMm == depthMm)&&(identical(other.pipeDiameter, pipeDiameter) || other.pipeDiameter == pipeDiameter)&&(identical(other.voltage, voltage) || other.voltage == voltage)&&(identical(other.airflow, airflow) || other.airflow == airflow)&&(identical(other.noiseLevel, noiseLevel) || other.noiseLevel == noiseLevel)&&(identical(other.powerConsumption, powerConsumption) || other.powerConsumption == powerConsumption)&&(identical(other.listPrice, listPrice) || other.listPrice == listPrice)&&(identical(other.streetPrice, streetPrice) || other.streetPrice == streetPrice)&&(identical(other.productUrl, productUrl) || other.productUrl == productUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.description, description) || other.description == description)&&(identical(other.isDiscontinued, isDiscontinued) || other.isDiscontinued == isDiscontinued)&&(identical(other.predecessorModel, predecessorModel) || other.predecessorModel == predecessorModel)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.manufacturerName, manufacturerName) || other.manufacturerName == manufacturerName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,modelNumber,name,manufacturerId,categoryId,widthMm,heightMm,depthMm,pipeDiameter,voltage,airflow,noiseLevel,powerConsumption,listPrice,streetPrice,productUrl,imageUrl,usage,description,isDiscontinued,predecessorModel,source,sourceId,manufacturerName,categoryName]);

@override
String toString() {
  return 'Product(id: $id, modelNumber: $modelNumber, name: $name, manufacturerId: $manufacturerId, categoryId: $categoryId, widthMm: $widthMm, heightMm: $heightMm, depthMm: $depthMm, pipeDiameter: $pipeDiameter, voltage: $voltage, airflow: $airflow, noiseLevel: $noiseLevel, powerConsumption: $powerConsumption, listPrice: $listPrice, streetPrice: $streetPrice, productUrl: $productUrl, imageUrl: $imageUrl, usage: $usage, description: $description, isDiscontinued: $isDiscontinued, predecessorModel: $predecessorModel, source: $source, sourceId: $sourceId, manufacturerName: $manufacturerName, categoryName: $categoryName)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String modelNumber, String name, String manufacturerId, String? categoryId, double? widthMm, double? heightMm, double? depthMm, double? pipeDiameter, int? voltage, double? airflow, double? noiseLevel, double? powerConsumption, int? listPrice, int? streetPrice, String? productUrl, String? imageUrl, String? usage, String? description, bool isDiscontinued, String? predecessorModel, String source, String? sourceId, String? manufacturerName, String? categoryName
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? modelNumber = null,Object? name = null,Object? manufacturerId = null,Object? categoryId = freezed,Object? widthMm = freezed,Object? heightMm = freezed,Object? depthMm = freezed,Object? pipeDiameter = freezed,Object? voltage = freezed,Object? airflow = freezed,Object? noiseLevel = freezed,Object? powerConsumption = freezed,Object? listPrice = freezed,Object? streetPrice = freezed,Object? productUrl = freezed,Object? imageUrl = freezed,Object? usage = freezed,Object? description = freezed,Object? isDiscontinued = null,Object? predecessorModel = freezed,Object? source = null,Object? sourceId = freezed,Object? manufacturerName = freezed,Object? categoryName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,modelNumber: null == modelNumber ? _self.modelNumber : modelNumber // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,manufacturerId: null == manufacturerId ? _self.manufacturerId : manufacturerId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,widthMm: freezed == widthMm ? _self.widthMm : widthMm // ignore: cast_nullable_to_non_nullable
as double?,heightMm: freezed == heightMm ? _self.heightMm : heightMm // ignore: cast_nullable_to_non_nullable
as double?,depthMm: freezed == depthMm ? _self.depthMm : depthMm // ignore: cast_nullable_to_non_nullable
as double?,pipeDiameter: freezed == pipeDiameter ? _self.pipeDiameter : pipeDiameter // ignore: cast_nullable_to_non_nullable
as double?,voltage: freezed == voltage ? _self.voltage : voltage // ignore: cast_nullable_to_non_nullable
as int?,airflow: freezed == airflow ? _self.airflow : airflow // ignore: cast_nullable_to_non_nullable
as double?,noiseLevel: freezed == noiseLevel ? _self.noiseLevel : noiseLevel // ignore: cast_nullable_to_non_nullable
as double?,powerConsumption: freezed == powerConsumption ? _self.powerConsumption : powerConsumption // ignore: cast_nullable_to_non_nullable
as double?,listPrice: freezed == listPrice ? _self.listPrice : listPrice // ignore: cast_nullable_to_non_nullable
as int?,streetPrice: freezed == streetPrice ? _self.streetPrice : streetPrice // ignore: cast_nullable_to_non_nullable
as int?,productUrl: freezed == productUrl ? _self.productUrl : productUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isDiscontinued: null == isDiscontinued ? _self.isDiscontinued : isDiscontinued // ignore: cast_nullable_to_non_nullable
as bool,predecessorModel: freezed == predecessorModel ? _self.predecessorModel : predecessorModel // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,sourceId: freezed == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String?,manufacturerName: freezed == manufacturerName ? _self.manufacturerName : manufacturerName // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String modelNumber,  String name,  String manufacturerId,  String? categoryId,  double? widthMm,  double? heightMm,  double? depthMm,  double? pipeDiameter,  int? voltage,  double? airflow,  double? noiseLevel,  double? powerConsumption,  int? listPrice,  int? streetPrice,  String? productUrl,  String? imageUrl,  String? usage,  String? description,  bool isDiscontinued,  String? predecessorModel,  String source,  String? sourceId,  String? manufacturerName,  String? categoryName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.modelNumber,_that.name,_that.manufacturerId,_that.categoryId,_that.widthMm,_that.heightMm,_that.depthMm,_that.pipeDiameter,_that.voltage,_that.airflow,_that.noiseLevel,_that.powerConsumption,_that.listPrice,_that.streetPrice,_that.productUrl,_that.imageUrl,_that.usage,_that.description,_that.isDiscontinued,_that.predecessorModel,_that.source,_that.sourceId,_that.manufacturerName,_that.categoryName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String modelNumber,  String name,  String manufacturerId,  String? categoryId,  double? widthMm,  double? heightMm,  double? depthMm,  double? pipeDiameter,  int? voltage,  double? airflow,  double? noiseLevel,  double? powerConsumption,  int? listPrice,  int? streetPrice,  String? productUrl,  String? imageUrl,  String? usage,  String? description,  bool isDiscontinued,  String? predecessorModel,  String source,  String? sourceId,  String? manufacturerName,  String? categoryName)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.modelNumber,_that.name,_that.manufacturerId,_that.categoryId,_that.widthMm,_that.heightMm,_that.depthMm,_that.pipeDiameter,_that.voltage,_that.airflow,_that.noiseLevel,_that.powerConsumption,_that.listPrice,_that.streetPrice,_that.productUrl,_that.imageUrl,_that.usage,_that.description,_that.isDiscontinued,_that.predecessorModel,_that.source,_that.sourceId,_that.manufacturerName,_that.categoryName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String modelNumber,  String name,  String manufacturerId,  String? categoryId,  double? widthMm,  double? heightMm,  double? depthMm,  double? pipeDiameter,  int? voltage,  double? airflow,  double? noiseLevel,  double? powerConsumption,  int? listPrice,  int? streetPrice,  String? productUrl,  String? imageUrl,  String? usage,  String? description,  bool isDiscontinued,  String? predecessorModel,  String source,  String? sourceId,  String? manufacturerName,  String? categoryName)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.modelNumber,_that.name,_that.manufacturerId,_that.categoryId,_that.widthMm,_that.heightMm,_that.depthMm,_that.pipeDiameter,_that.voltage,_that.airflow,_that.noiseLevel,_that.powerConsumption,_that.listPrice,_that.streetPrice,_that.productUrl,_that.imageUrl,_that.usage,_that.description,_that.isDiscontinued,_that.predecessorModel,_that.source,_that.sourceId,_that.manufacturerName,_that.categoryName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({required this.id, required this.modelNumber, required this.name, required this.manufacturerId, this.categoryId, this.widthMm, this.heightMm, this.depthMm, this.pipeDiameter, this.voltage, this.airflow, this.noiseLevel, this.powerConsumption, this.listPrice, this.streetPrice, this.productUrl, this.imageUrl, this.usage, this.description, this.isDiscontinued = false, this.predecessorModel, required this.source, this.sourceId, this.manufacturerName, this.categoryName});
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  String modelNumber;
@override final  String name;
@override final  String manufacturerId;
@override final  String? categoryId;
// Dimensions (mm)
@override final  double? widthMm;
@override final  double? heightMm;
@override final  double? depthMm;
@override final  double? pipeDiameter;
// Specs
@override final  int? voltage;
@override final  double? airflow;
@override final  double? noiseLevel;
@override final  double? powerConsumption;
// Price
@override final  int? listPrice;
@override final  int? streetPrice;
// Meta
@override final  String? productUrl;
@override final  String? imageUrl;
@override final  String? usage;
@override final  String? description;
@override@JsonKey() final  bool isDiscontinued;
@override final  String? predecessorModel;
// Source
@override final  String source;
@override final  String? sourceId;
// Relations (populated after join)
@override final  String? manufacturerName;
@override final  String? categoryName;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.modelNumber, modelNumber) || other.modelNumber == modelNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.manufacturerId, manufacturerId) || other.manufacturerId == manufacturerId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.widthMm, widthMm) || other.widthMm == widthMm)&&(identical(other.heightMm, heightMm) || other.heightMm == heightMm)&&(identical(other.depthMm, depthMm) || other.depthMm == depthMm)&&(identical(other.pipeDiameter, pipeDiameter) || other.pipeDiameter == pipeDiameter)&&(identical(other.voltage, voltage) || other.voltage == voltage)&&(identical(other.airflow, airflow) || other.airflow == airflow)&&(identical(other.noiseLevel, noiseLevel) || other.noiseLevel == noiseLevel)&&(identical(other.powerConsumption, powerConsumption) || other.powerConsumption == powerConsumption)&&(identical(other.listPrice, listPrice) || other.listPrice == listPrice)&&(identical(other.streetPrice, streetPrice) || other.streetPrice == streetPrice)&&(identical(other.productUrl, productUrl) || other.productUrl == productUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.description, description) || other.description == description)&&(identical(other.isDiscontinued, isDiscontinued) || other.isDiscontinued == isDiscontinued)&&(identical(other.predecessorModel, predecessorModel) || other.predecessorModel == predecessorModel)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.manufacturerName, manufacturerName) || other.manufacturerName == manufacturerName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,modelNumber,name,manufacturerId,categoryId,widthMm,heightMm,depthMm,pipeDiameter,voltage,airflow,noiseLevel,powerConsumption,listPrice,streetPrice,productUrl,imageUrl,usage,description,isDiscontinued,predecessorModel,source,sourceId,manufacturerName,categoryName]);

@override
String toString() {
  return 'Product(id: $id, modelNumber: $modelNumber, name: $name, manufacturerId: $manufacturerId, categoryId: $categoryId, widthMm: $widthMm, heightMm: $heightMm, depthMm: $depthMm, pipeDiameter: $pipeDiameter, voltage: $voltage, airflow: $airflow, noiseLevel: $noiseLevel, powerConsumption: $powerConsumption, listPrice: $listPrice, streetPrice: $streetPrice, productUrl: $productUrl, imageUrl: $imageUrl, usage: $usage, description: $description, isDiscontinued: $isDiscontinued, predecessorModel: $predecessorModel, source: $source, sourceId: $sourceId, manufacturerName: $manufacturerName, categoryName: $categoryName)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String modelNumber, String name, String manufacturerId, String? categoryId, double? widthMm, double? heightMm, double? depthMm, double? pipeDiameter, int? voltage, double? airflow, double? noiseLevel, double? powerConsumption, int? listPrice, int? streetPrice, String? productUrl, String? imageUrl, String? usage, String? description, bool isDiscontinued, String? predecessorModel, String source, String? sourceId, String? manufacturerName, String? categoryName
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? modelNumber = null,Object? name = null,Object? manufacturerId = null,Object? categoryId = freezed,Object? widthMm = freezed,Object? heightMm = freezed,Object? depthMm = freezed,Object? pipeDiameter = freezed,Object? voltage = freezed,Object? airflow = freezed,Object? noiseLevel = freezed,Object? powerConsumption = freezed,Object? listPrice = freezed,Object? streetPrice = freezed,Object? productUrl = freezed,Object? imageUrl = freezed,Object? usage = freezed,Object? description = freezed,Object? isDiscontinued = null,Object? predecessorModel = freezed,Object? source = null,Object? sourceId = freezed,Object? manufacturerName = freezed,Object? categoryName = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,modelNumber: null == modelNumber ? _self.modelNumber : modelNumber // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,manufacturerId: null == manufacturerId ? _self.manufacturerId : manufacturerId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,widthMm: freezed == widthMm ? _self.widthMm : widthMm // ignore: cast_nullable_to_non_nullable
as double?,heightMm: freezed == heightMm ? _self.heightMm : heightMm // ignore: cast_nullable_to_non_nullable
as double?,depthMm: freezed == depthMm ? _self.depthMm : depthMm // ignore: cast_nullable_to_non_nullable
as double?,pipeDiameter: freezed == pipeDiameter ? _self.pipeDiameter : pipeDiameter // ignore: cast_nullable_to_non_nullable
as double?,voltage: freezed == voltage ? _self.voltage : voltage // ignore: cast_nullable_to_non_nullable
as int?,airflow: freezed == airflow ? _self.airflow : airflow // ignore: cast_nullable_to_non_nullable
as double?,noiseLevel: freezed == noiseLevel ? _self.noiseLevel : noiseLevel // ignore: cast_nullable_to_non_nullable
as double?,powerConsumption: freezed == powerConsumption ? _self.powerConsumption : powerConsumption // ignore: cast_nullable_to_non_nullable
as double?,listPrice: freezed == listPrice ? _self.listPrice : listPrice // ignore: cast_nullable_to_non_nullable
as int?,streetPrice: freezed == streetPrice ? _self.streetPrice : streetPrice // ignore: cast_nullable_to_non_nullable
as int?,productUrl: freezed == productUrl ? _self.productUrl : productUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isDiscontinued: null == isDiscontinued ? _self.isDiscontinued : isDiscontinued // ignore: cast_nullable_to_non_nullable
as bool,predecessorModel: freezed == predecessorModel ? _self.predecessorModel : predecessorModel // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,sourceId: freezed == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String?,manufacturerName: freezed == manufacturerName ? _self.manufacturerName : manufacturerName // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
