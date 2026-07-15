import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/favorite_entity.dart';
import '../repositories/favorite_repository.dart';

class GetFavorites implements UseCase<List<FavoriteEntity>, NoParams> {
  const GetFavorites(this.repository);

  final FavoriteRepository repository;

  @override
  Future<Either<Failure, List<FavoriteEntity>>> call(NoParams params) {
    return repository.getFavorites();
  }
}
