import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:products_cart/features/cart/domain/entities/cart_item_entity.dart';
import 'package:products_cart/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:products_cart/features/favorite/domain/entities/favorite_entity.dart';
import 'package:products_cart/features/favorite/presentation/cubit/favorite_cubit.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/search_text_field.dart';
import '../cubit/products_list/products_cubit.dart';
import '../widgets/product_card.dart';
import 'product_details_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      //create the cubit obj from the di: and call loadProducts() to get the products when the screen is built.
      providers: [
        BlocProvider<ProductsCubit>(
          create: (_) => sl<ProductsCubit>()..loadProducts(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading || state is ProductsInitial) {
              return const LoadingWidget();
            }
            if (state is ProductsError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<ProductsCubit>().loadProducts(),
              );
            }
            if (state is ProductsLoaded) {
              final products = state.filteredProducts ?? state.allProducts;
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<ProductsCubit>().loadProducts();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12.r),
                        child: const SearchTextField(),
                      ),
                      if (products.isEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 40.h),
                          child: const Center(child: Text('No products found')),
                        )
                      else
                        // grid-responsive: crossAxisCount is derived from the
                        // available width instead of a fixed value, so the
                        // grid adapts to phones, tablets, and orientation
                        // changes instead of staying stuck at 2 columns.
                        LayoutBuilder(
                          builder: (context, constraints) {
                            const cardMaxWidth = 220.0;
                            final crossAxisCount =
                                (constraints.maxWidth / cardMaxWidth)
                                    .floor()
                                    .clamp(2, 6);
                            return GridView.builder(
                              padding: EdgeInsets.all(12.r),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    mainAxisSpacing: 12.h,
                                    crossAxisSpacing: 12.w,
                                    childAspectRatio: 0.7,
                                  ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailsScreen(
                                          productId: product.id,
                                        ),
                                      ),
                                    );
                                  },
                                  onFavoriteTap: () {
                                    final favoriteCubit = context
                                        .read<FavoriteCubit>();
                                    final wasFavorite = favoriteCubit
                                        .isFavorite(product.id);
                                    final favorite = FavoriteEntity(
                                      productId: product.id,
                                      title: product.title,
                                      price: product.price,
                                      image: product.image,
                                    );
                                    favoriteCubit.toggle(favorite);
                                    if (!wasFavorite) {
                                      showSuccessSnackBar(
                                        context,
                                        AppStrings.addedToFavorites,
                                      );
                                    }
                                  },
                                  onAddToCart: () {
                                    final cartItem = CartItemEntity(
                                      id: product.id.toString(),
                                      productId: product.id.toString(),
                                      name: product.title,
                                      price: product.price,
                                      image: product.image,
                                      quantity: 1,
                                    );
                                    context.read<CartCubit>().addItem(cartItem);
                                    showSuccessSnackBar(
                                      context,
                                      AppStrings.addedToCart,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
