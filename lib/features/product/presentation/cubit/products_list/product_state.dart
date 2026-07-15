part of 'products_cubit.dart';

@freezed
class ProductsState with _$ProductsState {
  const factory ProductsState.initial() = ProductsInitial;
  const factory ProductsState.loading() = ProductsLoading;
  const factory ProductsState.loaded(
    List<ProductEntity> allProducts,
    List<ProductEntity>? filteredProducts,
    String? query,
  ) = ProductsLoaded;
  const factory ProductsState.error(String message) = ProductsError;
}
