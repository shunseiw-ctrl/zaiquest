// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchFilter _$SearchFilterFromJson(Map<String, dynamic> json) =>
    _SearchFilter(
      query: json['query'] as String?,
      widthMin: (json['widthMin'] as num?)?.toDouble(),
      widthMax: (json['widthMax'] as num?)?.toDouble(),
      heightMin: (json['heightMin'] as num?)?.toDouble(),
      heightMax: (json['heightMax'] as num?)?.toDouble(),
      depthMin: (json['depthMin'] as num?)?.toDouble(),
      depthMax: (json['depthMax'] as num?)?.toDouble(),
      pipeDiameterMin: (json['pipeDiameterMin'] as num?)?.toDouble(),
      pipeDiameterMax: (json['pipeDiameterMax'] as num?)?.toDouble(),
      voltage: (json['voltage'] as num?)?.toInt(),
      priceMin: (json['priceMin'] as num?)?.toInt(),
      priceMax: (json['priceMax'] as num?)?.toInt(),
      manufacturerIds:
          (json['manufacturerIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      categoryId: json['categoryId'] as String?,
      includeDiscontinued: json['includeDiscontinued'] as bool? ?? false,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
    );

Map<String, dynamic> _$SearchFilterToJson(_SearchFilter instance) =>
    <String, dynamic>{
      'query': instance.query,
      'widthMin': instance.widthMin,
      'widthMax': instance.widthMax,
      'heightMin': instance.heightMin,
      'heightMax': instance.heightMax,
      'depthMin': instance.depthMin,
      'depthMax': instance.depthMax,
      'pipeDiameterMin': instance.pipeDiameterMin,
      'pipeDiameterMax': instance.pipeDiameterMax,
      'voltage': instance.voltage,
      'priceMin': instance.priceMin,
      'priceMax': instance.priceMax,
      'manufacturerIds': instance.manufacturerIds,
      'categoryId': instance.categoryId,
      'includeDiscontinued': instance.includeDiscontinued,
      'offset': instance.offset,
      'limit': instance.limit,
    };
