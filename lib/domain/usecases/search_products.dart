import '../entities/product.dart';
import '../entities/search_filter.dart';
import '../repositories/product_repository.dart';

class SearchProducts {
  final ProductRepository _repository;

  SearchProducts(this._repository);

  Future<List<Product>> call(SearchFilter filter) {
    return _repository.search(filter);
  }
}
