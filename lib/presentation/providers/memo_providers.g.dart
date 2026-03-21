// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$memoRepositoryHash() => r'b8d55be11e76fd28717e38b5ec81db1c94459787';

/// See also [memoRepository].
@ProviderFor(memoRepository)
final memoRepositoryProvider = Provider<MemoRepository>.internal(
  memoRepository,
  name: r'memoRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$memoRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MemoRepositoryRef = ProviderRef<MemoRepository>;
String _$productMemoHash() => r'956c90d88503307bea9c33033907e1585f1b9a02';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [productMemo].
@ProviderFor(productMemo)
const productMemoProvider = ProductMemoFamily();

/// See also [productMemo].
class ProductMemoFamily extends Family<AsyncValue<UserMemo?>> {
  /// See also [productMemo].
  const ProductMemoFamily();

  /// See also [productMemo].
  ProductMemoProvider call(String productId) {
    return ProductMemoProvider(productId);
  }

  @override
  ProductMemoProvider getProviderOverride(
    covariant ProductMemoProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productMemoProvider';
}

/// See also [productMemo].
class ProductMemoProvider extends AutoDisposeFutureProvider<UserMemo?> {
  /// See also [productMemo].
  ProductMemoProvider(String productId)
    : this._internal(
        (ref) => productMemo(ref as ProductMemoRef, productId),
        from: productMemoProvider,
        name: r'productMemoProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productMemoHash,
        dependencies: ProductMemoFamily._dependencies,
        allTransitiveDependencies: ProductMemoFamily._allTransitiveDependencies,
        productId: productId,
      );

  ProductMemoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    FutureOr<UserMemo?> Function(ProductMemoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductMemoProvider._internal(
        (ref) => create(ref as ProductMemoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<UserMemo?> createElement() {
    return _ProductMemoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductMemoProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductMemoRef on AutoDisposeFutureProviderRef<UserMemo?> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductMemoProviderElement
    extends AutoDisposeFutureProviderElement<UserMemo?>
    with ProductMemoRef {
  _ProductMemoProviderElement(super.provider);

  @override
  String get productId => (origin as ProductMemoProvider).productId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
