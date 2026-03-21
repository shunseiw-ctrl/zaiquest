// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $CachedProductsTable extends CachedProducts
    with TableInfo<$CachedProductsTable, CachedProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelNumberMeta = const VerificationMeta(
    'modelNumber',
  );
  @override
  late final GeneratedColumn<String> modelNumber = GeneratedColumn<String>(
    'model_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manufacturerIdMeta = const VerificationMeta(
    'manufacturerId',
  );
  @override
  late final GeneratedColumn<String> manufacturerId = GeneratedColumn<String>(
    'manufacturer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _widthMmMeta = const VerificationMeta(
    'widthMm',
  );
  @override
  late final GeneratedColumn<double> widthMm = GeneratedColumn<double>(
    'width_mm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMmMeta = const VerificationMeta(
    'heightMm',
  );
  @override
  late final GeneratedColumn<double> heightMm = GeneratedColumn<double>(
    'height_mm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _depthMmMeta = const VerificationMeta(
    'depthMm',
  );
  @override
  late final GeneratedColumn<double> depthMm = GeneratedColumn<double>(
    'depth_mm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pipeDiameterMeta = const VerificationMeta(
    'pipeDiameter',
  );
  @override
  late final GeneratedColumn<double> pipeDiameter = GeneratedColumn<double>(
    'pipe_diameter',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voltageMeta = const VerificationMeta(
    'voltage',
  );
  @override
  late final GeneratedColumn<int> voltage = GeneratedColumn<int>(
    'voltage',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _airflowMeta = const VerificationMeta(
    'airflow',
  );
  @override
  late final GeneratedColumn<double> airflow = GeneratedColumn<double>(
    'airflow',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noiseLevelMeta = const VerificationMeta(
    'noiseLevel',
  );
  @override
  late final GeneratedColumn<double> noiseLevel = GeneratedColumn<double>(
    'noise_level',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _powerConsumptionMeta = const VerificationMeta(
    'powerConsumption',
  );
  @override
  late final GeneratedColumn<double> powerConsumption = GeneratedColumn<double>(
    'power_consumption',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _listPriceMeta = const VerificationMeta(
    'listPrice',
  );
  @override
  late final GeneratedColumn<int> listPrice = GeneratedColumn<int>(
    'list_price',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _streetPriceMeta = const VerificationMeta(
    'streetPrice',
  );
  @override
  late final GeneratedColumn<int> streetPrice = GeneratedColumn<int>(
    'street_price',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productUrlMeta = const VerificationMeta(
    'productUrl',
  );
  @override
  late final GeneratedColumn<String> productUrl = GeneratedColumn<String>(
    'product_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usageMeta = const VerificationMeta('usage');
  @override
  late final GeneratedColumn<String> usage = GeneratedColumn<String>(
    'usage',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDiscontinuedMeta = const VerificationMeta(
    'isDiscontinued',
  );
  @override
  late final GeneratedColumn<bool> isDiscontinued = GeneratedColumn<bool>(
    'is_discontinued',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_discontinued" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _predecessorModelMeta = const VerificationMeta(
    'predecessorModel',
  );
  @override
  late final GeneratedColumn<String> predecessorModel = GeneratedColumn<String>(
    'predecessor_model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _manufacturerNameMeta = const VerificationMeta(
    'manufacturerName',
  );
  @override
  late final GeneratedColumn<String> manufacturerName = GeneratedColumn<String>(
    'manufacturer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta(
    'categoryName',
  );
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    modelNumber,
    name,
    manufacturerId,
    categoryId,
    widthMm,
    heightMm,
    depthMm,
    pipeDiameter,
    voltage,
    airflow,
    noiseLevel,
    powerConsumption,
    listPrice,
    streetPrice,
    productUrl,
    imageUrl,
    usage,
    description,
    isDiscontinued,
    predecessorModel,
    source,
    sourceId,
    manufacturerName,
    categoryName,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('model_number')) {
      context.handle(
        _modelNumberMeta,
        modelNumber.isAcceptableOrUnknown(
          data['model_number']!,
          _modelNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modelNumberMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('manufacturer_id')) {
      context.handle(
        _manufacturerIdMeta,
        manufacturerId.isAcceptableOrUnknown(
          data['manufacturer_id']!,
          _manufacturerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_manufacturerIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('width_mm')) {
      context.handle(
        _widthMmMeta,
        widthMm.isAcceptableOrUnknown(data['width_mm']!, _widthMmMeta),
      );
    }
    if (data.containsKey('height_mm')) {
      context.handle(
        _heightMmMeta,
        heightMm.isAcceptableOrUnknown(data['height_mm']!, _heightMmMeta),
      );
    }
    if (data.containsKey('depth_mm')) {
      context.handle(
        _depthMmMeta,
        depthMm.isAcceptableOrUnknown(data['depth_mm']!, _depthMmMeta),
      );
    }
    if (data.containsKey('pipe_diameter')) {
      context.handle(
        _pipeDiameterMeta,
        pipeDiameter.isAcceptableOrUnknown(
          data['pipe_diameter']!,
          _pipeDiameterMeta,
        ),
      );
    }
    if (data.containsKey('voltage')) {
      context.handle(
        _voltageMeta,
        voltage.isAcceptableOrUnknown(data['voltage']!, _voltageMeta),
      );
    }
    if (data.containsKey('airflow')) {
      context.handle(
        _airflowMeta,
        airflow.isAcceptableOrUnknown(data['airflow']!, _airflowMeta),
      );
    }
    if (data.containsKey('noise_level')) {
      context.handle(
        _noiseLevelMeta,
        noiseLevel.isAcceptableOrUnknown(data['noise_level']!, _noiseLevelMeta),
      );
    }
    if (data.containsKey('power_consumption')) {
      context.handle(
        _powerConsumptionMeta,
        powerConsumption.isAcceptableOrUnknown(
          data['power_consumption']!,
          _powerConsumptionMeta,
        ),
      );
    }
    if (data.containsKey('list_price')) {
      context.handle(
        _listPriceMeta,
        listPrice.isAcceptableOrUnknown(data['list_price']!, _listPriceMeta),
      );
    }
    if (data.containsKey('street_price')) {
      context.handle(
        _streetPriceMeta,
        streetPrice.isAcceptableOrUnknown(
          data['street_price']!,
          _streetPriceMeta,
        ),
      );
    }
    if (data.containsKey('product_url')) {
      context.handle(
        _productUrlMeta,
        productUrl.isAcceptableOrUnknown(data['product_url']!, _productUrlMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('usage')) {
      context.handle(
        _usageMeta,
        usage.isAcceptableOrUnknown(data['usage']!, _usageMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_discontinued')) {
      context.handle(
        _isDiscontinuedMeta,
        isDiscontinued.isAcceptableOrUnknown(
          data['is_discontinued']!,
          _isDiscontinuedMeta,
        ),
      );
    }
    if (data.containsKey('predecessor_model')) {
      context.handle(
        _predecessorModelMeta,
        predecessorModel.isAcceptableOrUnknown(
          data['predecessor_model']!,
          _predecessorModelMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    if (data.containsKey('manufacturer_name')) {
      context.handle(
        _manufacturerNameMeta,
        manufacturerName.isAcceptableOrUnknown(
          data['manufacturer_name']!,
          _manufacturerNameMeta,
        ),
      );
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(
          data['category_name']!,
          _categoryNameMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedProduct(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      modelNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_number'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      manufacturerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manufacturer_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      widthMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}width_mm'],
      ),
      heightMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_mm'],
      ),
      depthMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}depth_mm'],
      ),
      pipeDiameter: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pipe_diameter'],
      ),
      voltage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}voltage'],
      ),
      airflow: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}airflow'],
      ),
      noiseLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}noise_level'],
      ),
      powerConsumption: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}power_consumption'],
      ),
      listPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}list_price'],
      ),
      streetPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}street_price'],
      ),
      productUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_url'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      usage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usage'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isDiscontinued: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_discontinued'],
      )!,
      predecessorModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}predecessor_model'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
      manufacturerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manufacturer_name'],
      ),
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $CachedProductsTable createAlias(String alias) {
    return $CachedProductsTable(attachedDatabase, alias);
  }
}

class CachedProduct extends DataClass implements Insertable<CachedProduct> {
  final String id;
  final String modelNumber;
  final String name;
  final String manufacturerId;
  final String? categoryId;
  final double? widthMm;
  final double? heightMm;
  final double? depthMm;
  final double? pipeDiameter;
  final int? voltage;
  final double? airflow;
  final double? noiseLevel;
  final double? powerConsumption;
  final int? listPrice;
  final int? streetPrice;
  final String? productUrl;
  final String? imageUrl;
  final String? usage;
  final String? description;
  final bool isDiscontinued;
  final String? predecessorModel;
  final String source;
  final String? sourceId;
  final String? manufacturerName;
  final String? categoryName;
  final DateTime? updatedAt;
  const CachedProduct({
    required this.id,
    required this.modelNumber,
    required this.name,
    required this.manufacturerId,
    this.categoryId,
    this.widthMm,
    this.heightMm,
    this.depthMm,
    this.pipeDiameter,
    this.voltage,
    this.airflow,
    this.noiseLevel,
    this.powerConsumption,
    this.listPrice,
    this.streetPrice,
    this.productUrl,
    this.imageUrl,
    this.usage,
    this.description,
    required this.isDiscontinued,
    this.predecessorModel,
    required this.source,
    this.sourceId,
    this.manufacturerName,
    this.categoryName,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['model_number'] = Variable<String>(modelNumber);
    map['name'] = Variable<String>(name);
    map['manufacturer_id'] = Variable<String>(manufacturerId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || widthMm != null) {
      map['width_mm'] = Variable<double>(widthMm);
    }
    if (!nullToAbsent || heightMm != null) {
      map['height_mm'] = Variable<double>(heightMm);
    }
    if (!nullToAbsent || depthMm != null) {
      map['depth_mm'] = Variable<double>(depthMm);
    }
    if (!nullToAbsent || pipeDiameter != null) {
      map['pipe_diameter'] = Variable<double>(pipeDiameter);
    }
    if (!nullToAbsent || voltage != null) {
      map['voltage'] = Variable<int>(voltage);
    }
    if (!nullToAbsent || airflow != null) {
      map['airflow'] = Variable<double>(airflow);
    }
    if (!nullToAbsent || noiseLevel != null) {
      map['noise_level'] = Variable<double>(noiseLevel);
    }
    if (!nullToAbsent || powerConsumption != null) {
      map['power_consumption'] = Variable<double>(powerConsumption);
    }
    if (!nullToAbsent || listPrice != null) {
      map['list_price'] = Variable<int>(listPrice);
    }
    if (!nullToAbsent || streetPrice != null) {
      map['street_price'] = Variable<int>(streetPrice);
    }
    if (!nullToAbsent || productUrl != null) {
      map['product_url'] = Variable<String>(productUrl);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || usage != null) {
      map['usage'] = Variable<String>(usage);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_discontinued'] = Variable<bool>(isDiscontinued);
    if (!nullToAbsent || predecessorModel != null) {
      map['predecessor_model'] = Variable<String>(predecessorModel);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    if (!nullToAbsent || manufacturerName != null) {
      map['manufacturer_name'] = Variable<String>(manufacturerName);
    }
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  CachedProductsCompanion toCompanion(bool nullToAbsent) {
    return CachedProductsCompanion(
      id: Value(id),
      modelNumber: Value(modelNumber),
      name: Value(name),
      manufacturerId: Value(manufacturerId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      widthMm: widthMm == null && nullToAbsent
          ? const Value.absent()
          : Value(widthMm),
      heightMm: heightMm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightMm),
      depthMm: depthMm == null && nullToAbsent
          ? const Value.absent()
          : Value(depthMm),
      pipeDiameter: pipeDiameter == null && nullToAbsent
          ? const Value.absent()
          : Value(pipeDiameter),
      voltage: voltage == null && nullToAbsent
          ? const Value.absent()
          : Value(voltage),
      airflow: airflow == null && nullToAbsent
          ? const Value.absent()
          : Value(airflow),
      noiseLevel: noiseLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(noiseLevel),
      powerConsumption: powerConsumption == null && nullToAbsent
          ? const Value.absent()
          : Value(powerConsumption),
      listPrice: listPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(listPrice),
      streetPrice: streetPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(streetPrice),
      productUrl: productUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(productUrl),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      usage: usage == null && nullToAbsent
          ? const Value.absent()
          : Value(usage),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isDiscontinued: Value(isDiscontinued),
      predecessorModel: predecessorModel == null && nullToAbsent
          ? const Value.absent()
          : Value(predecessorModel),
      source: Value(source),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      manufacturerName: manufacturerName == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturerName),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory CachedProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedProduct(
      id: serializer.fromJson<String>(json['id']),
      modelNumber: serializer.fromJson<String>(json['modelNumber']),
      name: serializer.fromJson<String>(json['name']),
      manufacturerId: serializer.fromJson<String>(json['manufacturerId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      widthMm: serializer.fromJson<double?>(json['widthMm']),
      heightMm: serializer.fromJson<double?>(json['heightMm']),
      depthMm: serializer.fromJson<double?>(json['depthMm']),
      pipeDiameter: serializer.fromJson<double?>(json['pipeDiameter']),
      voltage: serializer.fromJson<int?>(json['voltage']),
      airflow: serializer.fromJson<double?>(json['airflow']),
      noiseLevel: serializer.fromJson<double?>(json['noiseLevel']),
      powerConsumption: serializer.fromJson<double?>(json['powerConsumption']),
      listPrice: serializer.fromJson<int?>(json['listPrice']),
      streetPrice: serializer.fromJson<int?>(json['streetPrice']),
      productUrl: serializer.fromJson<String?>(json['productUrl']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      usage: serializer.fromJson<String?>(json['usage']),
      description: serializer.fromJson<String?>(json['description']),
      isDiscontinued: serializer.fromJson<bool>(json['isDiscontinued']),
      predecessorModel: serializer.fromJson<String?>(json['predecessorModel']),
      source: serializer.fromJson<String>(json['source']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      manufacturerName: serializer.fromJson<String?>(json['manufacturerName']),
      categoryName: serializer.fromJson<String?>(json['categoryName']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'modelNumber': serializer.toJson<String>(modelNumber),
      'name': serializer.toJson<String>(name),
      'manufacturerId': serializer.toJson<String>(manufacturerId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'widthMm': serializer.toJson<double?>(widthMm),
      'heightMm': serializer.toJson<double?>(heightMm),
      'depthMm': serializer.toJson<double?>(depthMm),
      'pipeDiameter': serializer.toJson<double?>(pipeDiameter),
      'voltage': serializer.toJson<int?>(voltage),
      'airflow': serializer.toJson<double?>(airflow),
      'noiseLevel': serializer.toJson<double?>(noiseLevel),
      'powerConsumption': serializer.toJson<double?>(powerConsumption),
      'listPrice': serializer.toJson<int?>(listPrice),
      'streetPrice': serializer.toJson<int?>(streetPrice),
      'productUrl': serializer.toJson<String?>(productUrl),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'usage': serializer.toJson<String?>(usage),
      'description': serializer.toJson<String?>(description),
      'isDiscontinued': serializer.toJson<bool>(isDiscontinued),
      'predecessorModel': serializer.toJson<String?>(predecessorModel),
      'source': serializer.toJson<String>(source),
      'sourceId': serializer.toJson<String?>(sourceId),
      'manufacturerName': serializer.toJson<String?>(manufacturerName),
      'categoryName': serializer.toJson<String?>(categoryName),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  CachedProduct copyWith({
    String? id,
    String? modelNumber,
    String? name,
    String? manufacturerId,
    Value<String?> categoryId = const Value.absent(),
    Value<double?> widthMm = const Value.absent(),
    Value<double?> heightMm = const Value.absent(),
    Value<double?> depthMm = const Value.absent(),
    Value<double?> pipeDiameter = const Value.absent(),
    Value<int?> voltage = const Value.absent(),
    Value<double?> airflow = const Value.absent(),
    Value<double?> noiseLevel = const Value.absent(),
    Value<double?> powerConsumption = const Value.absent(),
    Value<int?> listPrice = const Value.absent(),
    Value<int?> streetPrice = const Value.absent(),
    Value<String?> productUrl = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> usage = const Value.absent(),
    Value<String?> description = const Value.absent(),
    bool? isDiscontinued,
    Value<String?> predecessorModel = const Value.absent(),
    String? source,
    Value<String?> sourceId = const Value.absent(),
    Value<String?> manufacturerName = const Value.absent(),
    Value<String?> categoryName = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => CachedProduct(
    id: id ?? this.id,
    modelNumber: modelNumber ?? this.modelNumber,
    name: name ?? this.name,
    manufacturerId: manufacturerId ?? this.manufacturerId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    widthMm: widthMm.present ? widthMm.value : this.widthMm,
    heightMm: heightMm.present ? heightMm.value : this.heightMm,
    depthMm: depthMm.present ? depthMm.value : this.depthMm,
    pipeDiameter: pipeDiameter.present ? pipeDiameter.value : this.pipeDiameter,
    voltage: voltage.present ? voltage.value : this.voltage,
    airflow: airflow.present ? airflow.value : this.airflow,
    noiseLevel: noiseLevel.present ? noiseLevel.value : this.noiseLevel,
    powerConsumption: powerConsumption.present
        ? powerConsumption.value
        : this.powerConsumption,
    listPrice: listPrice.present ? listPrice.value : this.listPrice,
    streetPrice: streetPrice.present ? streetPrice.value : this.streetPrice,
    productUrl: productUrl.present ? productUrl.value : this.productUrl,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    usage: usage.present ? usage.value : this.usage,
    description: description.present ? description.value : this.description,
    isDiscontinued: isDiscontinued ?? this.isDiscontinued,
    predecessorModel: predecessorModel.present
        ? predecessorModel.value
        : this.predecessorModel,
    source: source ?? this.source,
    sourceId: sourceId.present ? sourceId.value : this.sourceId,
    manufacturerName: manufacturerName.present
        ? manufacturerName.value
        : this.manufacturerName,
    categoryName: categoryName.present ? categoryName.value : this.categoryName,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  CachedProduct copyWithCompanion(CachedProductsCompanion data) {
    return CachedProduct(
      id: data.id.present ? data.id.value : this.id,
      modelNumber: data.modelNumber.present
          ? data.modelNumber.value
          : this.modelNumber,
      name: data.name.present ? data.name.value : this.name,
      manufacturerId: data.manufacturerId.present
          ? data.manufacturerId.value
          : this.manufacturerId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      widthMm: data.widthMm.present ? data.widthMm.value : this.widthMm,
      heightMm: data.heightMm.present ? data.heightMm.value : this.heightMm,
      depthMm: data.depthMm.present ? data.depthMm.value : this.depthMm,
      pipeDiameter: data.pipeDiameter.present
          ? data.pipeDiameter.value
          : this.pipeDiameter,
      voltage: data.voltage.present ? data.voltage.value : this.voltage,
      airflow: data.airflow.present ? data.airflow.value : this.airflow,
      noiseLevel: data.noiseLevel.present
          ? data.noiseLevel.value
          : this.noiseLevel,
      powerConsumption: data.powerConsumption.present
          ? data.powerConsumption.value
          : this.powerConsumption,
      listPrice: data.listPrice.present ? data.listPrice.value : this.listPrice,
      streetPrice: data.streetPrice.present
          ? data.streetPrice.value
          : this.streetPrice,
      productUrl: data.productUrl.present
          ? data.productUrl.value
          : this.productUrl,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      usage: data.usage.present ? data.usage.value : this.usage,
      description: data.description.present
          ? data.description.value
          : this.description,
      isDiscontinued: data.isDiscontinued.present
          ? data.isDiscontinued.value
          : this.isDiscontinued,
      predecessorModel: data.predecessorModel.present
          ? data.predecessorModel.value
          : this.predecessorModel,
      source: data.source.present ? data.source.value : this.source,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      manufacturerName: data.manufacturerName.present
          ? data.manufacturerName.value
          : this.manufacturerName,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedProduct(')
          ..write('id: $id, ')
          ..write('modelNumber: $modelNumber, ')
          ..write('name: $name, ')
          ..write('manufacturerId: $manufacturerId, ')
          ..write('categoryId: $categoryId, ')
          ..write('widthMm: $widthMm, ')
          ..write('heightMm: $heightMm, ')
          ..write('depthMm: $depthMm, ')
          ..write('pipeDiameter: $pipeDiameter, ')
          ..write('voltage: $voltage, ')
          ..write('airflow: $airflow, ')
          ..write('noiseLevel: $noiseLevel, ')
          ..write('powerConsumption: $powerConsumption, ')
          ..write('listPrice: $listPrice, ')
          ..write('streetPrice: $streetPrice, ')
          ..write('productUrl: $productUrl, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('usage: $usage, ')
          ..write('description: $description, ')
          ..write('isDiscontinued: $isDiscontinued, ')
          ..write('predecessorModel: $predecessorModel, ')
          ..write('source: $source, ')
          ..write('sourceId: $sourceId, ')
          ..write('manufacturerName: $manufacturerName, ')
          ..write('categoryName: $categoryName, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    modelNumber,
    name,
    manufacturerId,
    categoryId,
    widthMm,
    heightMm,
    depthMm,
    pipeDiameter,
    voltage,
    airflow,
    noiseLevel,
    powerConsumption,
    listPrice,
    streetPrice,
    productUrl,
    imageUrl,
    usage,
    description,
    isDiscontinued,
    predecessorModel,
    source,
    sourceId,
    manufacturerName,
    categoryName,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedProduct &&
          other.id == this.id &&
          other.modelNumber == this.modelNumber &&
          other.name == this.name &&
          other.manufacturerId == this.manufacturerId &&
          other.categoryId == this.categoryId &&
          other.widthMm == this.widthMm &&
          other.heightMm == this.heightMm &&
          other.depthMm == this.depthMm &&
          other.pipeDiameter == this.pipeDiameter &&
          other.voltage == this.voltage &&
          other.airflow == this.airflow &&
          other.noiseLevel == this.noiseLevel &&
          other.powerConsumption == this.powerConsumption &&
          other.listPrice == this.listPrice &&
          other.streetPrice == this.streetPrice &&
          other.productUrl == this.productUrl &&
          other.imageUrl == this.imageUrl &&
          other.usage == this.usage &&
          other.description == this.description &&
          other.isDiscontinued == this.isDiscontinued &&
          other.predecessorModel == this.predecessorModel &&
          other.source == this.source &&
          other.sourceId == this.sourceId &&
          other.manufacturerName == this.manufacturerName &&
          other.categoryName == this.categoryName &&
          other.updatedAt == this.updatedAt);
}

class CachedProductsCompanion extends UpdateCompanion<CachedProduct> {
  final Value<String> id;
  final Value<String> modelNumber;
  final Value<String> name;
  final Value<String> manufacturerId;
  final Value<String?> categoryId;
  final Value<double?> widthMm;
  final Value<double?> heightMm;
  final Value<double?> depthMm;
  final Value<double?> pipeDiameter;
  final Value<int?> voltage;
  final Value<double?> airflow;
  final Value<double?> noiseLevel;
  final Value<double?> powerConsumption;
  final Value<int?> listPrice;
  final Value<int?> streetPrice;
  final Value<String?> productUrl;
  final Value<String?> imageUrl;
  final Value<String?> usage;
  final Value<String?> description;
  final Value<bool> isDiscontinued;
  final Value<String?> predecessorModel;
  final Value<String> source;
  final Value<String?> sourceId;
  final Value<String?> manufacturerName;
  final Value<String?> categoryName;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const CachedProductsCompanion({
    this.id = const Value.absent(),
    this.modelNumber = const Value.absent(),
    this.name = const Value.absent(),
    this.manufacturerId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.widthMm = const Value.absent(),
    this.heightMm = const Value.absent(),
    this.depthMm = const Value.absent(),
    this.pipeDiameter = const Value.absent(),
    this.voltage = const Value.absent(),
    this.airflow = const Value.absent(),
    this.noiseLevel = const Value.absent(),
    this.powerConsumption = const Value.absent(),
    this.listPrice = const Value.absent(),
    this.streetPrice = const Value.absent(),
    this.productUrl = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.usage = const Value.absent(),
    this.description = const Value.absent(),
    this.isDiscontinued = const Value.absent(),
    this.predecessorModel = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.manufacturerName = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedProductsCompanion.insert({
    required String id,
    required String modelNumber,
    required String name,
    required String manufacturerId,
    this.categoryId = const Value.absent(),
    this.widthMm = const Value.absent(),
    this.heightMm = const Value.absent(),
    this.depthMm = const Value.absent(),
    this.pipeDiameter = const Value.absent(),
    this.voltage = const Value.absent(),
    this.airflow = const Value.absent(),
    this.noiseLevel = const Value.absent(),
    this.powerConsumption = const Value.absent(),
    this.listPrice = const Value.absent(),
    this.streetPrice = const Value.absent(),
    this.productUrl = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.usage = const Value.absent(),
    this.description = const Value.absent(),
    this.isDiscontinued = const Value.absent(),
    this.predecessorModel = const Value.absent(),
    required String source,
    this.sourceId = const Value.absent(),
    this.manufacturerName = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       modelNumber = Value(modelNumber),
       name = Value(name),
       manufacturerId = Value(manufacturerId),
       source = Value(source);
  static Insertable<CachedProduct> custom({
    Expression<String>? id,
    Expression<String>? modelNumber,
    Expression<String>? name,
    Expression<String>? manufacturerId,
    Expression<String>? categoryId,
    Expression<double>? widthMm,
    Expression<double>? heightMm,
    Expression<double>? depthMm,
    Expression<double>? pipeDiameter,
    Expression<int>? voltage,
    Expression<double>? airflow,
    Expression<double>? noiseLevel,
    Expression<double>? powerConsumption,
    Expression<int>? listPrice,
    Expression<int>? streetPrice,
    Expression<String>? productUrl,
    Expression<String>? imageUrl,
    Expression<String>? usage,
    Expression<String>? description,
    Expression<bool>? isDiscontinued,
    Expression<String>? predecessorModel,
    Expression<String>? source,
    Expression<String>? sourceId,
    Expression<String>? manufacturerName,
    Expression<String>? categoryName,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modelNumber != null) 'model_number': modelNumber,
      if (name != null) 'name': name,
      if (manufacturerId != null) 'manufacturer_id': manufacturerId,
      if (categoryId != null) 'category_id': categoryId,
      if (widthMm != null) 'width_mm': widthMm,
      if (heightMm != null) 'height_mm': heightMm,
      if (depthMm != null) 'depth_mm': depthMm,
      if (pipeDiameter != null) 'pipe_diameter': pipeDiameter,
      if (voltage != null) 'voltage': voltage,
      if (airflow != null) 'airflow': airflow,
      if (noiseLevel != null) 'noise_level': noiseLevel,
      if (powerConsumption != null) 'power_consumption': powerConsumption,
      if (listPrice != null) 'list_price': listPrice,
      if (streetPrice != null) 'street_price': streetPrice,
      if (productUrl != null) 'product_url': productUrl,
      if (imageUrl != null) 'image_url': imageUrl,
      if (usage != null) 'usage': usage,
      if (description != null) 'description': description,
      if (isDiscontinued != null) 'is_discontinued': isDiscontinued,
      if (predecessorModel != null) 'predecessor_model': predecessorModel,
      if (source != null) 'source': source,
      if (sourceId != null) 'source_id': sourceId,
      if (manufacturerName != null) 'manufacturer_name': manufacturerName,
      if (categoryName != null) 'category_name': categoryName,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? modelNumber,
    Value<String>? name,
    Value<String>? manufacturerId,
    Value<String?>? categoryId,
    Value<double?>? widthMm,
    Value<double?>? heightMm,
    Value<double?>? depthMm,
    Value<double?>? pipeDiameter,
    Value<int?>? voltage,
    Value<double?>? airflow,
    Value<double?>? noiseLevel,
    Value<double?>? powerConsumption,
    Value<int?>? listPrice,
    Value<int?>? streetPrice,
    Value<String?>? productUrl,
    Value<String?>? imageUrl,
    Value<String?>? usage,
    Value<String?>? description,
    Value<bool>? isDiscontinued,
    Value<String?>? predecessorModel,
    Value<String>? source,
    Value<String?>? sourceId,
    Value<String?>? manufacturerName,
    Value<String?>? categoryName,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return CachedProductsCompanion(
      id: id ?? this.id,
      modelNumber: modelNumber ?? this.modelNumber,
      name: name ?? this.name,
      manufacturerId: manufacturerId ?? this.manufacturerId,
      categoryId: categoryId ?? this.categoryId,
      widthMm: widthMm ?? this.widthMm,
      heightMm: heightMm ?? this.heightMm,
      depthMm: depthMm ?? this.depthMm,
      pipeDiameter: pipeDiameter ?? this.pipeDiameter,
      voltage: voltage ?? this.voltage,
      airflow: airflow ?? this.airflow,
      noiseLevel: noiseLevel ?? this.noiseLevel,
      powerConsumption: powerConsumption ?? this.powerConsumption,
      listPrice: listPrice ?? this.listPrice,
      streetPrice: streetPrice ?? this.streetPrice,
      productUrl: productUrl ?? this.productUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      usage: usage ?? this.usage,
      description: description ?? this.description,
      isDiscontinued: isDiscontinued ?? this.isDiscontinued,
      predecessorModel: predecessorModel ?? this.predecessorModel,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
      manufacturerName: manufacturerName ?? this.manufacturerName,
      categoryName: categoryName ?? this.categoryName,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (modelNumber.present) {
      map['model_number'] = Variable<String>(modelNumber.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (manufacturerId.present) {
      map['manufacturer_id'] = Variable<String>(manufacturerId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (widthMm.present) {
      map['width_mm'] = Variable<double>(widthMm.value);
    }
    if (heightMm.present) {
      map['height_mm'] = Variable<double>(heightMm.value);
    }
    if (depthMm.present) {
      map['depth_mm'] = Variable<double>(depthMm.value);
    }
    if (pipeDiameter.present) {
      map['pipe_diameter'] = Variable<double>(pipeDiameter.value);
    }
    if (voltage.present) {
      map['voltage'] = Variable<int>(voltage.value);
    }
    if (airflow.present) {
      map['airflow'] = Variable<double>(airflow.value);
    }
    if (noiseLevel.present) {
      map['noise_level'] = Variable<double>(noiseLevel.value);
    }
    if (powerConsumption.present) {
      map['power_consumption'] = Variable<double>(powerConsumption.value);
    }
    if (listPrice.present) {
      map['list_price'] = Variable<int>(listPrice.value);
    }
    if (streetPrice.present) {
      map['street_price'] = Variable<int>(streetPrice.value);
    }
    if (productUrl.present) {
      map['product_url'] = Variable<String>(productUrl.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (usage.present) {
      map['usage'] = Variable<String>(usage.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isDiscontinued.present) {
      map['is_discontinued'] = Variable<bool>(isDiscontinued.value);
    }
    if (predecessorModel.present) {
      map['predecessor_model'] = Variable<String>(predecessorModel.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (manufacturerName.present) {
      map['manufacturer_name'] = Variable<String>(manufacturerName.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedProductsCompanion(')
          ..write('id: $id, ')
          ..write('modelNumber: $modelNumber, ')
          ..write('name: $name, ')
          ..write('manufacturerId: $manufacturerId, ')
          ..write('categoryId: $categoryId, ')
          ..write('widthMm: $widthMm, ')
          ..write('heightMm: $heightMm, ')
          ..write('depthMm: $depthMm, ')
          ..write('pipeDiameter: $pipeDiameter, ')
          ..write('voltage: $voltage, ')
          ..write('airflow: $airflow, ')
          ..write('noiseLevel: $noiseLevel, ')
          ..write('powerConsumption: $powerConsumption, ')
          ..write('listPrice: $listPrice, ')
          ..write('streetPrice: $streetPrice, ')
          ..write('productUrl: $productUrl, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('usage: $usage, ')
          ..write('description: $description, ')
          ..write('isDiscontinued: $isDiscontinued, ')
          ..write('predecessorModel: $predecessorModel, ')
          ..write('source: $source, ')
          ..write('sourceId: $sourceId, ')
          ..write('manufacturerName: $manufacturerName, ')
          ..write('categoryName: $categoryName, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetaTable extends SyncMeta
    with TableInfo<$SyncMetaTable, SyncMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetaData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SyncMetaTable createAlias(String alias) {
    return $SyncMetaTable(attachedDatabase, alias);
  }
}

class SyncMetaData extends DataClass implements Insertable<SyncMetaData> {
  final String key;
  final String value;
  const SyncMetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncMetaCompanion toCompanion(bool nullToAbsent) {
    return SyncMetaCompanion(key: Value(key), value: Value(value));
  }

  factory SyncMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SyncMetaData copyWith({String? key, String? value}) =>
      SyncMetaData(key: key ?? this.key, value: value ?? this.value);
  SyncMetaData copyWithCompanion(SyncMetaCompanion data) {
    return SyncMetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetaData &&
          other.key == this.key &&
          other.value == this.value);
}

class SyncMetaCompanion extends UpdateCompanion<SyncMetaData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SyncMetaData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SyncMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedProductsTable cachedProducts = $CachedProductsTable(this);
  late final $SyncMetaTable syncMeta = $SyncMetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedProducts,
    syncMeta,
  ];
}

typedef $$CachedProductsTableCreateCompanionBuilder =
    CachedProductsCompanion Function({
      required String id,
      required String modelNumber,
      required String name,
      required String manufacturerId,
      Value<String?> categoryId,
      Value<double?> widthMm,
      Value<double?> heightMm,
      Value<double?> depthMm,
      Value<double?> pipeDiameter,
      Value<int?> voltage,
      Value<double?> airflow,
      Value<double?> noiseLevel,
      Value<double?> powerConsumption,
      Value<int?> listPrice,
      Value<int?> streetPrice,
      Value<String?> productUrl,
      Value<String?> imageUrl,
      Value<String?> usage,
      Value<String?> description,
      Value<bool> isDiscontinued,
      Value<String?> predecessorModel,
      required String source,
      Value<String?> sourceId,
      Value<String?> manufacturerName,
      Value<String?> categoryName,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$CachedProductsTableUpdateCompanionBuilder =
    CachedProductsCompanion Function({
      Value<String> id,
      Value<String> modelNumber,
      Value<String> name,
      Value<String> manufacturerId,
      Value<String?> categoryId,
      Value<double?> widthMm,
      Value<double?> heightMm,
      Value<double?> depthMm,
      Value<double?> pipeDiameter,
      Value<int?> voltage,
      Value<double?> airflow,
      Value<double?> noiseLevel,
      Value<double?> powerConsumption,
      Value<int?> listPrice,
      Value<int?> streetPrice,
      Value<String?> productUrl,
      Value<String?> imageUrl,
      Value<String?> usage,
      Value<String?> description,
      Value<bool> isDiscontinued,
      Value<String?> predecessorModel,
      Value<String> source,
      Value<String?> sourceId,
      Value<String?> manufacturerName,
      Value<String?> categoryName,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$CachedProductsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelNumber => $composableBuilder(
    column: $table.modelNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manufacturerId => $composableBuilder(
    column: $table.manufacturerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get widthMm => $composableBuilder(
    column: $table.widthMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightMm => $composableBuilder(
    column: $table.heightMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get depthMm => $composableBuilder(
    column: $table.depthMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pipeDiameter => $composableBuilder(
    column: $table.pipeDiameter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get voltage => $composableBuilder(
    column: $table.voltage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get airflow => $composableBuilder(
    column: $table.airflow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get noiseLevel => $composableBuilder(
    column: $table.noiseLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get powerConsumption => $composableBuilder(
    column: $table.powerConsumption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get listPrice => $composableBuilder(
    column: $table.listPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streetPrice => $composableBuilder(
    column: $table.streetPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productUrl => $composableBuilder(
    column: $table.productUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usage => $composableBuilder(
    column: $table.usage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDiscontinued => $composableBuilder(
    column: $table.isDiscontinued,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get predecessorModel => $composableBuilder(
    column: $table.predecessorModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manufacturerName => $composableBuilder(
    column: $table.manufacturerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelNumber => $composableBuilder(
    column: $table.modelNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manufacturerId => $composableBuilder(
    column: $table.manufacturerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get widthMm => $composableBuilder(
    column: $table.widthMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightMm => $composableBuilder(
    column: $table.heightMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get depthMm => $composableBuilder(
    column: $table.depthMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pipeDiameter => $composableBuilder(
    column: $table.pipeDiameter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get voltage => $composableBuilder(
    column: $table.voltage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get airflow => $composableBuilder(
    column: $table.airflow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get noiseLevel => $composableBuilder(
    column: $table.noiseLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get powerConsumption => $composableBuilder(
    column: $table.powerConsumption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get listPrice => $composableBuilder(
    column: $table.listPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streetPrice => $composableBuilder(
    column: $table.streetPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productUrl => $composableBuilder(
    column: $table.productUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usage => $composableBuilder(
    column: $table.usage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDiscontinued => $composableBuilder(
    column: $table.isDiscontinued,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get predecessorModel => $composableBuilder(
    column: $table.predecessorModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manufacturerName => $composableBuilder(
    column: $table.manufacturerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get modelNumber => $composableBuilder(
    column: $table.modelNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get manufacturerId => $composableBuilder(
    column: $table.manufacturerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get widthMm =>
      $composableBuilder(column: $table.widthMm, builder: (column) => column);

  GeneratedColumn<double> get heightMm =>
      $composableBuilder(column: $table.heightMm, builder: (column) => column);

  GeneratedColumn<double> get depthMm =>
      $composableBuilder(column: $table.depthMm, builder: (column) => column);

  GeneratedColumn<double> get pipeDiameter => $composableBuilder(
    column: $table.pipeDiameter,
    builder: (column) => column,
  );

  GeneratedColumn<int> get voltage =>
      $composableBuilder(column: $table.voltage, builder: (column) => column);

  GeneratedColumn<double> get airflow =>
      $composableBuilder(column: $table.airflow, builder: (column) => column);

  GeneratedColumn<double> get noiseLevel => $composableBuilder(
    column: $table.noiseLevel,
    builder: (column) => column,
  );

  GeneratedColumn<double> get powerConsumption => $composableBuilder(
    column: $table.powerConsumption,
    builder: (column) => column,
  );

  GeneratedColumn<int> get listPrice =>
      $composableBuilder(column: $table.listPrice, builder: (column) => column);

  GeneratedColumn<int> get streetPrice => $composableBuilder(
    column: $table.streetPrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productUrl => $composableBuilder(
    column: $table.productUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get usage =>
      $composableBuilder(column: $table.usage, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDiscontinued => $composableBuilder(
    column: $table.isDiscontinued,
    builder: (column) => column,
  );

  GeneratedColumn<String> get predecessorModel => $composableBuilder(
    column: $table.predecessorModel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get manufacturerName => $composableBuilder(
    column: $table.manufacturerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedProductsTable,
          CachedProduct,
          $$CachedProductsTableFilterComposer,
          $$CachedProductsTableOrderingComposer,
          $$CachedProductsTableAnnotationComposer,
          $$CachedProductsTableCreateCompanionBuilder,
          $$CachedProductsTableUpdateCompanionBuilder,
          (
            CachedProduct,
            BaseReferences<_$AppDatabase, $CachedProductsTable, CachedProduct>,
          ),
          CachedProduct,
          PrefetchHooks Function()
        > {
  $$CachedProductsTableTableManager(
    _$AppDatabase db,
    $CachedProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> modelNumber = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> manufacturerId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<double?> widthMm = const Value.absent(),
                Value<double?> heightMm = const Value.absent(),
                Value<double?> depthMm = const Value.absent(),
                Value<double?> pipeDiameter = const Value.absent(),
                Value<int?> voltage = const Value.absent(),
                Value<double?> airflow = const Value.absent(),
                Value<double?> noiseLevel = const Value.absent(),
                Value<double?> powerConsumption = const Value.absent(),
                Value<int?> listPrice = const Value.absent(),
                Value<int?> streetPrice = const Value.absent(),
                Value<String?> productUrl = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> usage = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isDiscontinued = const Value.absent(),
                Value<String?> predecessorModel = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<String?> manufacturerName = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedProductsCompanion(
                id: id,
                modelNumber: modelNumber,
                name: name,
                manufacturerId: manufacturerId,
                categoryId: categoryId,
                widthMm: widthMm,
                heightMm: heightMm,
                depthMm: depthMm,
                pipeDiameter: pipeDiameter,
                voltage: voltage,
                airflow: airflow,
                noiseLevel: noiseLevel,
                powerConsumption: powerConsumption,
                listPrice: listPrice,
                streetPrice: streetPrice,
                productUrl: productUrl,
                imageUrl: imageUrl,
                usage: usage,
                description: description,
                isDiscontinued: isDiscontinued,
                predecessorModel: predecessorModel,
                source: source,
                sourceId: sourceId,
                manufacturerName: manufacturerName,
                categoryName: categoryName,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String modelNumber,
                required String name,
                required String manufacturerId,
                Value<String?> categoryId = const Value.absent(),
                Value<double?> widthMm = const Value.absent(),
                Value<double?> heightMm = const Value.absent(),
                Value<double?> depthMm = const Value.absent(),
                Value<double?> pipeDiameter = const Value.absent(),
                Value<int?> voltage = const Value.absent(),
                Value<double?> airflow = const Value.absent(),
                Value<double?> noiseLevel = const Value.absent(),
                Value<double?> powerConsumption = const Value.absent(),
                Value<int?> listPrice = const Value.absent(),
                Value<int?> streetPrice = const Value.absent(),
                Value<String?> productUrl = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> usage = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isDiscontinued = const Value.absent(),
                Value<String?> predecessorModel = const Value.absent(),
                required String source,
                Value<String?> sourceId = const Value.absent(),
                Value<String?> manufacturerName = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedProductsCompanion.insert(
                id: id,
                modelNumber: modelNumber,
                name: name,
                manufacturerId: manufacturerId,
                categoryId: categoryId,
                widthMm: widthMm,
                heightMm: heightMm,
                depthMm: depthMm,
                pipeDiameter: pipeDiameter,
                voltage: voltage,
                airflow: airflow,
                noiseLevel: noiseLevel,
                powerConsumption: powerConsumption,
                listPrice: listPrice,
                streetPrice: streetPrice,
                productUrl: productUrl,
                imageUrl: imageUrl,
                usage: usage,
                description: description,
                isDiscontinued: isDiscontinued,
                predecessorModel: predecessorModel,
                source: source,
                sourceId: sourceId,
                manufacturerName: manufacturerName,
                categoryName: categoryName,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedProductsTable,
      CachedProduct,
      $$CachedProductsTableFilterComposer,
      $$CachedProductsTableOrderingComposer,
      $$CachedProductsTableAnnotationComposer,
      $$CachedProductsTableCreateCompanionBuilder,
      $$CachedProductsTableUpdateCompanionBuilder,
      (
        CachedProduct,
        BaseReferences<_$AppDatabase, $CachedProductsTable, CachedProduct>,
      ),
      CachedProduct,
      PrefetchHooks Function()
    >;
typedef $$SyncMetaTableCreateCompanionBuilder =
    SyncMetaCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SyncMetaTableUpdateCompanionBuilder =
    SyncMetaCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SyncMetaTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetaTable,
          SyncMetaData,
          $$SyncMetaTableFilterComposer,
          $$SyncMetaTableOrderingComposer,
          $$SyncMetaTableAnnotationComposer,
          $$SyncMetaTableCreateCompanionBuilder,
          $$SyncMetaTableUpdateCompanionBuilder,
          (
            SyncMetaData,
            BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaData>,
          ),
          SyncMetaData,
          PrefetchHooks Function()
        > {
  $$SyncMetaTableTableManager(_$AppDatabase db, $SyncMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SyncMetaCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetaTable,
      SyncMetaData,
      $$SyncMetaTableFilterComposer,
      $$SyncMetaTableOrderingComposer,
      $$SyncMetaTableAnnotationComposer,
      $$SyncMetaTableCreateCompanionBuilder,
      $$SyncMetaTableUpdateCompanionBuilder,
      (
        SyncMetaData,
        BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaData>,
      ),
      SyncMetaData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedProductsTableTableManager get cachedProducts =>
      $$CachedProductsTableTableManager(_db, _db.cachedProducts);
  $$SyncMetaTableTableManager get syncMeta =>
      $$SyncMetaTableTableManager(_db, _db.syncMeta);
}
