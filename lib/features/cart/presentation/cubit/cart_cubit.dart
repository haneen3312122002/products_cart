import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/decrease_cart_item_quantity.dart';
import '../../domain/usecases/get_cart_items.dart';
import '../../domain/usecases/remove_from_cart.dart';
import '../../domain/usecases/update_cart_quantity.dart';

part 'cart_state.dart';
part 'cart_cubit.freezed.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({
    required GetCartItems getCartItems,
    required AddToCart addToCart,
    required RemoveFromCart removeFromCart,
    required UpdateCartQuantity updateCartQuantity,
    required DecreaseCartItemQuantity decreaseCartItemQuantity,
  }) : _getCartItems = getCartItems,
       _addToCart = addToCart,
       _removeFromCart = removeFromCart,
       _updateCartQuantity = updateCartQuantity,
       _decreaseCartItemQuantity = decreaseCartItemQuantity,
       super(const CartState.initial());

  final GetCartItems _getCartItems;
  final AddToCart _addToCart;
  final RemoveFromCart _removeFromCart;
  final UpdateCartQuantity _updateCartQuantity;
  final DecreaseCartItemQuantity _decreaseCartItemQuantity;

  Future<void> loadCart() async {
    emit(const CartState.loading());
    final result = await _getCartItems(const NoParams());
    result.fold(
      (failure) => emit(CartState.error(failure.message)),
      (items) => emit(CartState.loaded(items)),
    );
  }

  Future<void> addItem(CartItemEntity item) async {
    final result = await _addToCart(AddToCartParams(item));
    result.fold(
      (failure) => emit(CartState.error(failure.message)),
      (_) => loadCart(),
    );
  }

  Future<void> removeItem(String cartItemId) async {
    final result = await _removeFromCart(RemoveFromCartParams(cartItemId));
    result.fold(
      (failure) => emit(CartState.error(failure.message)),
      (_) => loadCart(),
    );
  }

  Future<void> decreaseItemQuantity(String cartItemId) async {
    final result = await _decreaseCartItemQuantity(
      DecreaseCartItemQuantityParams(cartItemId),
    );
    result.fold(
      (failure) => emit(CartState.error(failure.message)),
      (_) => loadCart(),
    );
  }

  // WARNING edited: use case existed end-to-end (data source + repo) but was
  // never called from the cubit; the +/- buttons used addItem/decreaseItemQuantity
  // instead. Wired it up so quantity can be set directly.
  Future<void> updateQuantity(String cartItemId, int quantity) async {
    final result = await _updateCartQuantity(
      UpdateCartQuantityParams(cartItemId: cartItemId, quantity: quantity),
    );
    result.fold(
      (failure) => emit(CartState.error(failure.message)),
      (_) => loadCart(),
    );
  }
}
