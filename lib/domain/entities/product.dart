import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String modelNumber,
    required String name,
    required String manufacturerId,
    String? categoryId,
    // Dimensions (mm)
    double? widthMm,
    double? heightMm,
    double? depthMm,
    double? pipeDiameter,
    // Specs
    int? voltage,
    double? airflow,
    double? noiseLevel,
    double? powerConsumption,
    // Price
    int? listPrice,
    int? streetPrice,
    // Meta
    String? productUrl,
    String? imageUrl,
    String? usage,
    String? description,
    @Default(false) bool isDiscontinued,
    String? predecessorModel,
    // Source
    required String source,
    String? sourceId,
    // Relations (populated after join)
    String? manufacturerName,
    String? categoryName,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
