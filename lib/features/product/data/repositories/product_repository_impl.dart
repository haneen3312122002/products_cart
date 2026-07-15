import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  // WARNING edited: ProductLocalDataSource was registered in DI but never
  // injected here, so the offline cache never actually ran. Now the
  // remote fetch caches on success and falls back to the cache when
  // offline or when the request fails.
  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProducts();
        await localDataSource.cacheProducts(products);
        return Right(products);
      } on ServerException catch (e) {
        return _fallbackToCache(ServerFailure(e.message));
      } catch (_) {
        return _fallbackToCache(const ServerFailure());
      }
    }
    return _fallbackToCache(const NetworkFailure());
  }

  Future<Either<Failure, List<ProductEntity>>> _fallbackToCache(
    Failure failure,
  ) async {
    try {
      final cached = await localDataSource.getLastProducts();
      return Right(cached);
    } on CacheException {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.getProductById(id);
        return Right(product);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (_) {
        return const Left(ServerFailure());
      }
    }
    return const Left(NetworkFailure());
  }
}
