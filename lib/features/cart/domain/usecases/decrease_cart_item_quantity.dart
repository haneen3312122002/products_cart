import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cart_repository.dart';

class DecreaseCartItemQuantity
    implements UseCase<void, DecreaseCartItemQuantityParams> {
  const DecreaseCartItemQuantity(this.repository);

  final CartRepository repository;

  @override
  Future<Either<Failure, void>> call(DecreaseCartItemQuantityParams params) {
    return repository.decreaseQuantity(params.cartItemId);
  }
}

class DecreaseCartItemQuantityParams extends Equatable {
  const DecreaseCartItemQuantityParams(this.cartItemId);

  final String cartItemId;

  @override
  List<Object?> get props => [cartItemId];
}
