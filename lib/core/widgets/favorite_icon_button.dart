import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/favorite/presentation/cubit/favorite_cubit.dart';
import '../theme/app_colors.dart';

// shared favorite toggle icon, reused by the product card and product
// details screen so both stay in sync with FavoriteCubit
class FavoriteIconButton extends StatelessWidget {
  const FavoriteIconButton({
    super.key,
    required this.productId,
    required this.onPressed,
  });

  final int productId;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          final isFavorite = context.read<FavoriteCubit>().isFavorite(
            productId,
          );
          return Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? AppColors.error : AppColors.primary,
          );
        },
      ),
    );
  }
}
