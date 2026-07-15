import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartItems implements UseCase<List<CartItemEntity>, NoParams> {
  const GetCartItems(this.repository);

  final CartRepository repository;

  @override
  Future<Either<Failure, List<CartItemEntity>>> call(NoParams params) {
    return repository.getCartItems();
  }
}
