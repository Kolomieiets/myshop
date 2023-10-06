import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/services/api/product_api.dart';
import 'package:my_shop/services/models/product_id.dart';
import 'package:my_shop/services/providers/auth_provider.dart';
import 'package:my_shop/services/providers/product.dart';
import 'package:provider/provider.dart';

class ProductRepository {
  late final Dio _dio;

  ProductRepository() {
    _dio = Dio();
  }

  Future<Product> addProduct(
    Product product,
    BuildContext ctx,
  ) async {
    final AuthProvider provider = Provider.of<AuthProvider>(ctx, listen: false);
    final ProductId response = await ProductApi(_dio).addProduct(
      provider.token!,
      product.toJson(),
    );
    return product.copyWith(id: response.name);
  }

  Future<void> updateProduct(
    String id,
    Product newProduct,
    BuildContext ctx,
  ) async {
    final AuthProvider provider = Provider.of<AuthProvider>(ctx, listen: false);
    await ProductApi(_dio).updateProduct(
      id,
      provider.token!,
      newProduct.toJson(),
    );
  }

  Future<void> deleteProduct(String id, BuildContext ctx) async {
    final AuthProvider provider = Provider.of<AuthProvider>(ctx, listen: false);
    await ProductApi(_dio).deleteProduct(id, provider.token!);
  }

  Future<Map<String, Product>?> fetchAndSetProduct(BuildContext ctx) async {
    final AuthProvider provider = Provider.of<AuthProvider>(ctx, listen: false);

    return await ProductApi(_dio).getProduct(provider.token!);
  }

  Future<void> toggleFavorite(
    String id,
    bool isFavorite,
    BuildContext ctx,
  ) async {
    final AuthProvider provider = Provider.of<AuthProvider>(ctx, listen: false);
    await ProductApi(_dio).toggleFavorite(
        id, provider.token!, {'isFavorite': isFavorite});
  }
}
