import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductByIdParams extends Equatable {
  const GetProductByIdParams(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class GetProductById implements UseCase<ProductEntity, GetProductByIdParams> {
  const GetProductById(this.repository);

  final ProductRepository repository;

  @override
  Future<Either<Failure, ProductEntity>> call(GetProductByIdParams params) {
    return repository.getProductById(params.id);
  }
}
