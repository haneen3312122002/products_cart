import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../product/presentation/screens/product_details_screen.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CartCubit>()..loadCart(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoading || state is CartInitial) {
              return const LoadingWidget();
            }
            if (state is CartError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<CartCubit>().loadCart(),
              );
            }
            if (state is CartLoaded) {
              // pull-refresh: this screen previously had no refresh gesture.
              if (state.items.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => context.read<CartCubit>().loadCart(),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: const Center(
                            child: Text('Your cart is empty'),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => context.read<CartCubit>().loadCart(),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return CartItemTile(
                            item: item,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailsScreen(
                                    productId: int.parse(item.productId),
                                  ),
                                ),
                              );
                            },
                            // WARNING edited: was re-adding the item to bump
                            // quantity by 1; now calls the dedicated quantity
                            // use case directly.
                            onIncrease: () => context
                                .read<CartCubit>()
                                .updateQuantity(item.id, item.quantity + 1),
                            onDecrease: () => context
                                .read<CartCubit>()
                                .decreaseItemQuantity(item.id),
                            onRemove: () async {
                              final confirmed = await showConfirmDialog(
                                context,
                                title: AppStrings.removeCartItemTitle,
                                message: AppStrings.removeCartItemMessage,
                              );
                              if (confirmed && context.mounted) {
                                context.read<CartCubit>().removeItem(item.id);
                              }
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: AppTextStyles.title),
                          Text(
                            '\$${state.totalPrice.toStringAsFixed(2)}',
                            style: AppTextStyles.heading2,
                          ),
                        ],
                      ),
                    ),
                  ],
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
