import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/services/api/api.dart';
import 'package:my_shop/services/providers/auth_provider.dart';
import 'package:my_shop/services/providers/product.dart';
import 'package:provider/provider.dart';

class ProductRepository {
  late final Api _api;

  ProductRepository() {
    _api = Api();
  }

  Future<Response<dynamic>> addProduct(
      Product product, BuildContext ctx) async {
    final url = Uri.https(
        'myshop-f49b2-default-rtdb.firebaseio.com',
        '/products.json',
        {'auth': Provider.of<AuthProvider>(ctx, listen: false).token});

    final response = await _api.post(
      url.toString(),
      data: {
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isFavorite': product.isFavorite,
        'userId': product.userId,
      },
    );

    return response;
  }

  Future<void> updateProduct(
    String id,
    Product newProduct,
    BuildContext ctx,
  ) async {
    final url = Uri.https(
        'myshop-f49b2-default-rtdb.firebaseio.com',
        '/products/$id.json',
        {'auth': Provider.of<AuthProvider>(ctx, listen: false).token});
    await _api.put(url.toString(), data: {
      'title': newProduct.title,
      'description': newProduct.description,
      'price': newProduct.price,
      'imageUrl': newProduct.imageUrl,
      'userId': newProduct.userId,
    });
  }

  Future<Response<dynamic>> deleteProduct(String id, BuildContext ctx) async {
    final url = Uri.https(
        'myshop-f49b2-default-rtdb.firebaseio.com',
        '/products/$id.json',
        {'auth': Provider.of<AuthProvider>(ctx, listen: false).token});

    return await _api.delete(url.toString());
  }

  Future<Response<dynamic>> fetchAndSetProduct(BuildContext ctx) async {
    final url = Uri.https(
        'myshop-f49b2-default-rtdb.firebaseio.com',
        '/products.json',
        {'auth': Provider.of<AuthProvider>(ctx, listen: false).token});

    return await _api.get(url.toString());
  }

  Future<Response<dynamic>> toggleFavorite(
    String id,
    bool isFavorite,
    BuildContext ctx,
  ) async {
    final url = Uri.https(
        'myshop-f49b2-default-rtdb.firebaseio.com',
        '/products/$id.json',
        {'auth': Provider.of<AuthProvider>(ctx, listen: false).token});

    return await _api.patch(
      url.toString(),
      data: {'isFavorite': isFavorite},
    );
  }
}
