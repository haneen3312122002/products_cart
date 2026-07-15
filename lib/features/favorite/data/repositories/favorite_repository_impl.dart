import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_local_data_source.dart';
import '../models/favorite_model.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  const FavoriteRepositoryImpl({required this.localDataSource});

  final FavoriteLocalDataSource localDataSource;

  @override
  //get all the favorite products from the local data source and return them as a list of FavoriteEntity.
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Right(favorites);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(FavoriteEntity favorite) async {
    try {
      //get the current list of favorites from the local data source and check if the product is already in the list. If it is, remove it; if not, add it.
      final current = await localDataSource.getFavorites();
      //check if the product is already in the list of favorites.(bool)
      final exists = current.any((f) => f.productId == favorite.productId);
      //add or remove the product from the list of favorites based on whether it already exists in the list.
      final updated = exists
          //remove: exists=true
          ? current.where((f) => f.productId != favorite.productId).toList()
          //add: exists=false
          : [...current, FavoriteModel.fromEntity(favorite)];
      //save the updated list:
      await localDataSource.saveFavorites(updated);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int productId) async {
    try {
      final ids = await localDataSource.getFavoriteIds();
      return Right(ids.contains(productId));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
