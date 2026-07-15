part of 'product_cubit.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState.initial() = ProductInitial;
  const factory ProductState.loading() = ProductLoading;
  const factory ProductState.loaded(ProductEntity product) = ProductLoaded;
  const factory ProductState.error(String message) = ProductError;
}
