import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cart_repository.dart';

class RemoveFromCart implements UseCase<void, RemoveFromCartParams> {
  const RemoveFromCart(this.repository);

  final CartRepository repository;

  @override
  Future<Either<Failure, void>> call(RemoveFromCartParams params) {
    return repository.removeFromCart(params.cartItemId);
  }
}

class RemoveFromCartParams extends Equatable {
  const RemoveFromCartParams(this.cartItemId);

  final String cartItemId;

  @override
  List<Object?> get props => [cartItemId];
}
