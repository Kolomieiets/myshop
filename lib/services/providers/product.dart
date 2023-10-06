import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_shop/services/api/product_repository.dart';

part 'product.g.dart';

@JsonSerializable()
class Product with ChangeNotifier {
  final String? id;
  late String? userId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  final ProductRepository _repository = ProductRepository();

  Product({
    required this.id,
    this.userId,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    id,
    userId,
    title,
    description,
    price,
    imageUrl,
    isFavorite = false,
  }) {
    return Product(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, BuildContext ctx) async {
    final bool oldStatus = isFavorite;
    isFavorite = !isFavorite;

    notifyListeners();
    try {
      await _repository.toggleFavorite(id!, isFavorite, ctx);
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
