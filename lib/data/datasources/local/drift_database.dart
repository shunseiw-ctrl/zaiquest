import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'drift_database.g.dart';

class CachedProducts extends Table {
  TextColumn get id => text()();
  TextColumn get modelNumber => text()();
  TextColumn get name => text()();
  TextColumn get manufacturerId => text()();
  TextColumn get categoryId => text().nullable()();
  RealColumn get widthMm => real().nullable()();
  RealColumn get heightMm => real().nullable()();
  RealColumn get depthMm => real().nullable()();
  RealColumn get pipeDiameter => real().nullable()();
  IntColumn get voltage => integer().nullable()();
  RealColumn get airflow => real().nullable()();
  RealColumn get noiseLevel => real().nullable()();
  RealColumn get powerConsumption => real().nullable()();
  IntColumn get listPrice => integer().nullable()();
  IntColumn get streetPrice => integer().nullable()();
  TextColumn get productUrl => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get usage => text().nullable()();
  TextColumn get description => text().nullable()();
  BoolColumn get isDiscontinued => boolean().withDefault(const Constant(false))();
  TextColumn get predecessorModel => text().nullable()();
  TextColumn get source => text()();
  TextColumn get sourceId => text().nullable()();
  TextColumn get manufacturerName => text().nullable()();
  TextColumn get categoryName => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [CachedProducts, SyncMeta])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Get last sync timestamp
  Future<DateTime?> getLastSyncedAt() async {
    final row = await (select(syncMeta)
          ..where((t) => t.key.equals('last_synced_at')))
        .getSingleOrNull();
    if (row == null) return null;
    return DateTime.tryParse(row.value);
  }

  // Update last sync timestamp
  Future<void> setLastSyncedAt(DateTime dt) async {
    await into(syncMeta).insertOnConflictUpdate(
      SyncMetaCompanion(
        key: const Value('last_synced_at'),
        value: Value(dt.toIso8601String()),
      ),
    );
  }

  // Upsert products from remote
  Future<void> upsertProducts(List<CachedProductsCompanion> products) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(cachedProducts, products);
    });
  }

  // Search cached products
  Future<List<CachedProduct>> searchProducts({
    String? query,
    double? widthMin,
    double? widthMax,
    double? heightMin,
    double? heightMax,
    double? depthMin,
    double? depthMax,
    int? voltage,
    int? priceMin,
    int? priceMax,
    List<String>? manufacturerIds,
    bool includeDiscontinued = false,
    String sortBy = 'updated_at',
    bool sortAscending = false,
    int limit = 20,
    int offset = 0,
  }) async {
    final q = select(cachedProducts)
      ..limit(limit, offset: offset);

    q.where((t) {
      Expression<bool> condition = const Constant(true);

      if (!includeDiscontinued) {
        condition = condition & t.isDiscontinued.equals(false);
      }
      if (query != null && query.isNotEmpty) {
        condition = condition & t.modelNumber.contains(query);
      }
      if (widthMin != null) {
        condition = condition & t.widthMm.isBiggerOrEqualValue(widthMin);
      }
      if (widthMax != null) {
        condition = condition & t.widthMm.isSmallerOrEqualValue(widthMax);
      }
      if (heightMin != null) {
        condition = condition & t.heightMm.isBiggerOrEqualValue(heightMin);
      }
      if (heightMax != null) {
        condition = condition & t.heightMm.isSmallerOrEqualValue(heightMax);
      }
      if (depthMin != null) {
        condition = condition & t.depthMm.isBiggerOrEqualValue(depthMin);
      }
      if (depthMax != null) {
        condition = condition & t.depthMm.isSmallerOrEqualValue(depthMax);
      }
      if (voltage != null) {
        condition = condition & t.voltage.equals(voltage);
      }
      if (priceMin != null) {
        condition = condition & t.listPrice.isBiggerOrEqualValue(priceMin);
      }
      if (priceMax != null) {
        condition = condition & t.listPrice.isSmallerOrEqualValue(priceMax);
      }
      if (manufacturerIds != null && manufacturerIds.isNotEmpty) {
        condition = condition & t.manufacturerId.isIn(manufacturerIds);
      }

      return condition;
    });

    // Dynamic sort
    final mode =
        sortAscending ? OrderingMode.asc : OrderingMode.desc;
    q.orderBy([
      (t) {
        final column = switch (sortBy) {
          'list_price' => t.listPrice,
          'model_number' => t.modelNumber,
          _ => t.updatedAt,
        };
        return OrderingTerm(expression: column, mode: mode);
      },
    ]);

    return q.get();
  }

  // Get single product
  Future<CachedProduct?> getProduct(String id) async {
    return (select(cachedProducts)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'zaiquest.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
