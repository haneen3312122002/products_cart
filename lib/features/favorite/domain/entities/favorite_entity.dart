import 'package:equatable/equatable.dart';

class FavoriteEntity extends Equatable {
  const FavoriteEntity({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
  });

  final int productId;
  final String title;
  final double price;
  final String image;

  @override
  List<Object?> get props => [productId, title, price, image];
}
