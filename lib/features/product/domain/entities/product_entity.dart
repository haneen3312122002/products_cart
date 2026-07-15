import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.description = '',
    this.category = '',
    this.rating = 0.0,
  });

  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  final String category;
  final double rating;

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    image,
    description,
    category,
    rating,
  ];
}
