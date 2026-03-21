import '../../domain/entities/product.dart';
import '../datasources/local/drift_database.dart';
import 'package:drift/drift.dart';

class ProductMapper {
  static Product fromSupabaseJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      modelNumber: json['model_number'] as String,
      name: json['name'] as String,
      manufacturerId: json['manufacturer_id'] as String,
      categoryId: json['category_id'] as String?,
      widthMm: (json['width_mm'] as num?)?.toDouble(),
      heightMm: (json['height_mm'] as num?)?.toDouble(),
      depthMm: (json['depth_mm'] as num?)?.toDouble(),
      pipeDiameter: (json['pipe_diameter'] as num?)?.toDouble(),
      voltage: json['voltage'] as int?,
      airflow: (json['airflow'] as num?)?.toDouble(),
      noiseLevel: (json['noise_level'] as num?)?.toDouble(),
      powerConsumption: (json['power_consumption'] as num?)?.toDouble(),
      listPrice: json['list_price'] as int?,
      streetPrice: json['street_price'] as int?,
      productUrl: json['product_url'] as String?,
      imageUrl: json['image_url'] as String?,
      usage: json['usage'] as String?,
      description: json['description'] as String?,
      isDiscontinued: json['is_discontinued'] as bool? ?? false,
      predecessorModel: json['predecessor_model'] as String?,
      source: json['source'] as String,
      sourceId: json['source_id'] as String?,
      manufacturerName: json['manufacturers'] != null
          ? (json['manufacturers'] as Map<String, dynamic>)['name'] as String?
          : null,
      categoryName: json['categories'] != null
          ? (json['categories'] as Map<String, dynamic>)['name'] as String?
          : null,
    );
  }

  static Product fromCachedProduct(CachedProduct cached) {
    return Product(
      id: cached.id,
      modelNumber: cached.modelNumber,
      name: cached.name,
      manufacturerId: cached.manufacturerId,
      categoryId: cached.categoryId,
      widthMm: cached.widthMm,
      heightMm: cached.heightMm,
      depthMm: cached.depthMm,
      pipeDiameter: cached.pipeDiameter,
      voltage: cached.voltage,
      airflow: cached.airflow,
      noiseLevel: cached.noiseLevel,
      powerConsumption: cached.powerConsumption,
      listPrice: cached.listPrice,
      streetPrice: cached.streetPrice,
      productUrl: cached.productUrl,
      imageUrl: cached.imageUrl,
      usage: cached.usage,
      description: cached.description,
      isDiscontinued: cached.isDiscontinued,
      predecessorModel: cached.predecessorModel,
      source: cached.source,
      sourceId: cached.sourceId,
      manufacturerName: cached.manufacturerName,
      categoryName: cached.categoryName,
    );
  }

  static CachedProductsCompanion toCachedCompanion(Product product) {
    return CachedProductsCompanion(
      id: Value(product.id),
      modelNumber: Value(product.modelNumber),
      name: Value(product.name),
      manufacturerId: Value(product.manufacturerId),
      categoryId: Value(product.categoryId),
      widthMm: Value(product.widthMm),
      heightMm: Value(product.heightMm),
      depthMm: Value(product.depthMm),
      pipeDiameter: Value(product.pipeDiameter),
      voltage: Value(product.voltage),
      airflow: Value(product.airflow),
      noiseLevel: Value(product.noiseLevel),
      powerConsumption: Value(product.powerConsumption),
      listPrice: Value(product.listPrice),
      streetPrice: Value(product.streetPrice),
      productUrl: Value(product.productUrl),
      imageUrl: Value(product.imageUrl),
      usage: Value(product.usage),
      description: Value(product.description),
      isDiscontinued: Value(product.isDiscontinued),
      predecessorModel: Value(product.predecessorModel),
      source: Value(product.source),
      sourceId: Value(product.sourceId),
      manufacturerName: Value(product.manufacturerName),
      categoryName: Value(product.categoryName),
    );
  }
}
