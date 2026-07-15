part of 'cart_cubit.dart';

@freezed
class CartState with _$CartState {
  const factory CartState.initial() = CartInitial;
  const factory CartState.loading() = CartLoading;
  const factory CartState.loaded(List<CartItemEntity> items) = CartLoaded;
  const factory CartState.error(String message) = CartError;
}

extension CartLoadedTotal on CartLoaded {
  double get totalPrice => items.fold(0, (sum, item) => sum + item.subtotal);
}
