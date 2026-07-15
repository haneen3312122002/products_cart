import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/favorite_entity.dart';
import '../repositories/favorite_repository.dart';

class ToggleFavorite implements UseCase<void, ToggleFavoriteParams> {
  const ToggleFavorite(this.repository);

  final FavoriteRepository repository;

  @override
  Future<Either<Failure, void>> call(ToggleFavoriteParams params) {
    return repository.toggleFavorite(params.favorite);
  }
}

class ToggleFavoriteParams extends Equatable {
  const ToggleFavoriteParams(this.favorite);

  final FavoriteEntity favorite;

  @override
  List<Object?> get props => [favorite];
}
