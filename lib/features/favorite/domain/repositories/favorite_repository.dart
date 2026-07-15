import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites();
  Future<Either<Failure, void>> toggleFavorite(FavoriteEntity favorite);
  Future<Either<Failure, bool>> isFavorite(int productId);
}
