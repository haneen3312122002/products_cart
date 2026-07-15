import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class AddToCart implements UseCase<void, AddToCartParams> {
  const AddToCart(this.repository);

  final CartRepository repository;

  @override
  Future<Either<Failure, void>> call(AddToCartParams params) {
    return repository.addToCart(params.item);
  }
}

class AddToCartParams extends Equatable {
  const AddToCartParams(this.item);

  final CartItemEntity item;

  @override
  List<Object?> get props => [item];
}
