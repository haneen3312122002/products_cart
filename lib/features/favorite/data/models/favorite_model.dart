import 'dart:convert';
import '../../domain/entities/favorite_entity.dart';

class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    required super.productId,
    required super.title,
    required super.price,
    required super.image,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      productId: json['productId'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String? ?? '',
    );
  }

  factory FavoriteModel.fromEntity(FavoriteEntity entity) {
    return FavoriteModel(
      productId: entity.productId,
      title: entity.title,
      price: entity.price,
      image: entity.image,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
    };
  }

  static String encodeList(List<FavoriteModel> favorites) {
    return jsonEncode(favorites.map((f) => f.toJson()).toList());
  }

  static List<FavoriteModel> decodeList(String source) {
    final decoded = jsonDecode(source) as List<dynamic>;
    return decoded
        .map((json) => FavoriteModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
