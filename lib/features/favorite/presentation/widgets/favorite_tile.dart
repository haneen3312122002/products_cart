import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/favorite_entity.dart';

class FavoriteTile extends StatelessWidget {
  const FavoriteTile({
    super.key,
    required this.favorite,
    this.onRemove,
    this.onTap,
  });

  final FavoriteEntity favorite;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: favorite.image.isEmpty
            ? Container(width: 56.r, height: 56.r, color: AppColors.border)
            : Image.network(
                favorite.image,
                width: 56.r,
                height: 56.r,
                fit: BoxFit.contain,
              ),
      ),
      title: Text(favorite.title, style: AppTextStyles.title),
      subtitle: Text(
        '\$${favorite.price.toStringAsFixed(2)}',
        style: AppTextStyles.caption,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.favorite, color: AppColors.error),
        onPressed: onRemove,
      ),
    );
  }
}
