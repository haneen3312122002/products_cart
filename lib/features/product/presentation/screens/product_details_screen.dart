import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/favorite_icon_button.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../favorite/domain/entities/favorite_entity.dart';
import '../../../favorite/presentation/cubit/favorite_cubit.dart';
import '../cubit/product_details/product_cubit.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductCubit>()..loadProductById(productId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading || state is ProductInitial) {
              return const LoadingWidget();
            }
            if (state is ProductError) {
              return ErrorView(
                message: state.message,
                onRetry: () =>
                    context.read<ProductCubit>().loadProductById(productId),
              );
            }
            if (state is ProductLoaded) {
              final product = state.product;
              // pull-refresh: this screen previously had no refresh gesture.
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<ProductCubit>().loadProductById(productId),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: product.image.isEmpty
                            ? Container(color: AppColors.border)
                            : Image.network(product.image, fit: BoxFit.contain),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.title, style: AppTextStyles.heading2),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18.r,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  product.rating.toStringAsFixed(1),
                                  style: AppTextStyles.body,
                                ),
                                SizedBox(width: 16.w),
                                Chip(label: Text(product.category)),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: AppTextStyles.heading2.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              product.description,
                              style: AppTextStyles.body,
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final cartItem = CartItemEntity(
                                        id: product.id.toString(),
                                        productId: product.id.toString(),
                                        name: product.title,
                                        price: product.price,
                                        image: product.image,
                                        quantity: 1,
                                      );
                                      context.read<CartCubit>().addItem(
                                        cartItem,
                                      );
                                      showSuccessSnackBar(
                                        context,
                                        AppStrings.addedToCart,
                                      );
                                    },
                                    child: const Text(AppStrings.addToCart),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  height: 52,
                                  width: 52,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: FavoriteIconButton(
                                    productId: product.id,
                                    onPressed: () {
                                      final favoriteCubit = context
                                          .read<FavoriteCubit>();
                                      final wasFavorite = favoriteCubit
                                          .isFavorite(product.id);
                                      favoriteCubit.toggle(
                                        FavoriteEntity(
                                          productId: product.id,
                                          title: product.title,
                                          price: product.price,
                                          image: product.image,
                                        ),
                                      );
                                      if (!wasFavorite) {
                                        showSuccessSnackBar(
                                          context,
                                          AppStrings.addedToFavorites,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
