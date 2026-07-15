import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCartItems();

  Future<Either<Failure, void>> addToCart(CartItemEntity item);

  Future<Either<Failure, void>> decreaseQuantity(String cartItemId);

  Future<Either<Failure, void>> removeFromCart(String cartItemId);

  Future<Either<Failure, void>> updateQuantity(String cartItemId, int quantity);

  Future<Either<Failure, void>> clearCart();
}
