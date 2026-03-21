// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  modelNumber: json['modelNumber'] as String,
  name: json['name'] as String,
  manufacturerId: json['manufacturerId'] as String,
  categoryId: json['categoryId'] as String?,
  widthMm: (json['widthMm'] as num?)?.toDouble(),
  heightMm: (json['heightMm'] as num?)?.toDouble(),
  depthMm: (json['depthMm'] as num?)?.toDouble(),
  pipeDiameter: (json['pipeDiameter'] as num?)?.toDouble(),
  voltage: (json['voltage'] as num?)?.toInt(),
  airflow: (json['airflow'] as num?)?.toDouble(),
  noiseLevel: (json['noiseLevel'] as num?)?.toDouble(),
  powerConsumption: (json['powerConsumption'] as num?)?.toDouble(),
  listPrice: (json['listPrice'] as num?)?.toInt(),
  streetPrice: (json['streetPrice'] as num?)?.toInt(),
  productUrl: json['productUrl'] as String?,
  imageUrl: json['imageUrl'] as String?,
  usage: json['usage'] as String?,
  description: json['description'] as String?,
  isDiscontinued: json['isDiscontinued'] as bool? ?? false,
  predecessorModel: json['predecessorModel'] as String?,
  source: json['source'] as String,
  sourceId: json['sourceId'] as String?,
  manufacturerName: json['manufacturerName'] as String?,
  categoryName: json['categoryName'] as String?,
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'modelNumber': instance.modelNumber,
  'name': instance.name,
  'manufacturerId': instance.manufacturerId,
  'categoryId': instance.categoryId,
  'widthMm': instance.widthMm,
  'heightMm': instance.heightMm,
  'depthMm': instance.depthMm,
  'pipeDiameter': instance.pipeDiameter,
  'voltage': instance.voltage,
  'airflow': instance.airflow,
  'noiseLevel': instance.noiseLevel,
  'powerConsumption': instance.powerConsumption,
  'listPrice': instance.listPrice,
  'streetPrice': instance.streetPrice,
  'productUrl': instance.productUrl,
  'imageUrl': instance.imageUrl,
  'usage': instance.usage,
  'description': instance.description,
  'isDiscontinued': instance.isDiscontinued,
  'predecessorModel': instance.predecessorModel,
  'source': instance.source,
  'sourceId': instance.sourceId,
  'manufacturerName': instance.manufacturerName,
  'categoryName': instance.categoryName,
};
