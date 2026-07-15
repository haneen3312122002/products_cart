import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cart_repository.dart';

class UpdateCartQuantity
    implements UseCase<void, UpdateCartQuantityParams> {
  const UpdateCartQuantity(this.repository);

  final CartRepository repository;

  @override
  Future<Either<Failure, void>> call(UpdateCartQuantityParams params) {
    return repository.updateQuantity(params.cartItemId, params.quantity);
  }
}

class UpdateCartQuantityParams extends Equatable {
  const UpdateCartQuantityParams({
    required this.cartItemId,
    required this.quantity,
  });

  final String cartItemId;
  final int quantity;

  @override
  List<Object?> get props => [cartItemId, quantity];
}
