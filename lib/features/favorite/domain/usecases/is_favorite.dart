import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/favorite_repository.dart';

class IsFavoriteParams extends Equatable {
  const IsFavoriteParams(this.productId);

  final int productId;

  @override
  List<Object?> get props => [productId];
}

class IsFavorite implements UseCase<bool, IsFavoriteParams> {
  const IsFavorite(this.repository);

  final FavoriteRepository repository;

  @override
  Future<Either<Failure, bool>> call(IsFavoriteParams params) {
    return repository.isFavorite(params.productId);
  }
}
