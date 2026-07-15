import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/get_products.dart';
part 'product_state.dart';
part 'products_cubit.freezed.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit({required GetProducts getProducts})
    : _getProducts = getProducts,
      super(const ProductsInitial());

  final GetProducts _getProducts;

  Future<void> loadProducts() async {
    emit(const ProductsLoading());
    final result = await _getProducts(const NoParams());
    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(products, null, null)),
    );
  }

  Future<void> filterProducts(String query) async {
    final currentState = state;
    if (currentState is ProductsLoaded) {
      final filteredProducts = currentState.allProducts
          .where(
            (product) =>
                product.title.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      emit(ProductsLoaded(currentState.allProducts, filteredProducts, query));
    }
  }
}
