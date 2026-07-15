import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';

// simple in-memory cache of the last successful product fetch, used as a
// fallback when there is no network connection
// TODO: swap for persistent storage (e.g. Hive) if offline cache should survive restarts
abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getLastProducts();

  Future<void> cacheProducts(List<ProductModel> products);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  List<ProductModel>? _cachedProducts;

  @override
  Future<List<ProductModel>> getLastProducts() async {
    final cached = _cachedProducts;
    if (cached == null) {
      throw const CacheException('No cached products found');
    }
    return cached;
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    _cachedProducts = products;
  }
}
