import 'package:flutter/material.dart';
import 'package:my_shop/services/api/product_repository.dart';

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

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, BuildContext ctx) async {
    final bool oldStatus = isFavorite;
    isFavorite = !isFavorite;

    notifyListeners();
    try {
      final response = await _repository.toggleFavorite(id!, isFavorite, ctx);
      if (response.statusCode! >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
