import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:products_cart/features/product/domain/usecases/get_product_by_id.dart';
import '../../../domain/entities/product_entity.dart';

part 'product_state.dart';
// WARNING edited: removed leftover Arabic dev comment (no functional change)
part 'product_cubit.freezed.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit({required GetProductById getProductById})
    : _getProductById = getProductById,
      super(const ProductInitial());

  final GetProductById _getProductById;

  Future<void> loadProductById(int id) async {
    emit(const ProductLoading());
    final result = await _getProductById(GetProductByIdParams(id));
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (product) => emit(ProductLoaded(product)),
    );
  }
}
