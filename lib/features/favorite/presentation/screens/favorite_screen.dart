import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../product/presentation/screens/product_details_screen.dart';
import '../../domain/entities/favorite_entity.dart';
import '../cubit/favorite_cubit.dart';
import '../widgets/favorite_tile.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FavoriteCubit>()..loadFavorites(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Favorites')),
        body: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoading || state is FavoriteInitial) {
              return const LoadingWidget();
            }
            if (state is FavoriteError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<FavoriteCubit>().loadFavorites(),
              );
            }
            if (state is FavoriteLoaded) {
              // pull-refresh: this screen previously had no refresh gesture.
              return RefreshIndicator(
                onRefresh: () => context.read<FavoriteCubit>().loadFavorites(),
                child: state.favorites.isEmpty
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: const Center(
                                child: Text('No favorites yet'),
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.favorites.length,
                        itemBuilder: (context, index) {
                          final FavoriteEntity favorite =
                              state.favorites[index];
                          return FavoriteTile(
                            favorite: favorite,
                            onRemove: () async {
                              final confirmed = await showConfirmDialog(
                                context,
                                title: AppStrings.removeFavoriteTitle,
                                message: AppStrings.removeFavoriteMessage,
                              );
                              if (confirmed && context.mounted) {
                                context.read<FavoriteCubit>().toggle(favorite);
                              }
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailsScreen(
                                    productId: favorite.productId,
                                  ),
                                ),
                              );
                            },
                          );
                        },
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
