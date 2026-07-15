import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  final String id;
  final String productId;
  final String name;
  final double price;
  final String image;
  final int quantity;

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(
      id: id,
      productId: productId,
      name: name,
      price: price,
      image: image,
      quantity: quantity ?? this.quantity,
    );
  }

  // WARNING edited: removed duplicate `totalPrice` getter (identical
  // price * quantity calculation under a second name) — `subtotal` is now
  // the single per-item price getter used everywhere.
  double get subtotal => price * quantity;

  @override
  List<Object?> get props => [id, productId, name, price, image, quantity];
}
