// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_shop/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Product with ChangeNotifier {
  final String? id;
  late String? userId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

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
    final url = Uri.https('myshop-f49b2-default-rtdb.firebaseio.com',
        '/products/$id.json', {'auth': Provider.of<AuthProvider>(ctx, listen: false).token});

    isFavorite = !isFavorite;

    notifyListeners();
    try {
      final response = await http.patch(
        url,
        body: json.encode({'isFavorite': isFavorite}),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
