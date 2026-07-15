import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    this.onTap,
    this.onIncrease,
    this.onDecrease,
    this.onRemove,
  });

  final CartItemEntity item;
  final VoidCallback? onTap;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: item.image.isEmpty
            ? Container(width: 56.r, height: 56.r, color: AppColors.border)
            : Image.network(
                item.image,
                width: 56.r,
                height: 56.r,
                fit: BoxFit.contain,
              ),
      ),
      title: Text(item.name, style: AppTextStyles.title),
      subtitle: Text(
        'Subtotal: \$${item.subtotal.toStringAsFixed(2)}',
        style: AppTextStyles.caption,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: onDecrease,
          ),
          Text('${item.quantity}', style: AppTextStyles.body),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: onIncrease,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
