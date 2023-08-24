import 'package:flutter/material.dart';
import 'package:my_shop/models/http_exception.dart';
import 'package:my_shop/providers/auth_provider.dart';
import 'package:my_shop/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  bool _showFavorite = false;

  List<Product> get items {
    if (_showFavorite) {
      return _items.where((prodItem) => prodItem.isFavorite).toList();
    }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void showFavoritesOnly() {
    _showFavorite = true;
    notifyListeners();
  }

  void showAll() {
    _showFavorite = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product, BuildContext ctx) async {
    final url = Uri.https(
        'myshop-f49b2-default-rtdb.firebaseio.com',
        '/products.json',
        {'auth': Provider.of<AuthProvider>(ctx, listen: false).token});
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
          'userId': product.userId,
        }),
      );
      final Product newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        userId: product.userId,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(
      String id, Product newProduct, BuildContext ctx) async {
    final int productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url = Uri.https(
          'myshop-f49b2-default-rtdb.firebaseio.com',
          '/products/$id.json',
          {'auth': Provider.of<AuthProvider>(ctx, listen: false).token});
      await http.put(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'userId': newProduct.userId,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id, BuildContext ctx) async {
    final url = Uri.https(
        'myshop-f49b2-default-rtdb.firebaseio.com',
        '/products/$id.json',
        {'auth': Provider.of<AuthProvider>(ctx, listen: false).token});
    final int existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }

  Future<void> fetchAndSetProducts(BuildContext ctx) async {
    final url = Uri.https(
        'myshop-f49b2-default-rtdb.firebaseio.com',
        '/products.json',
        {'auth': Provider.of<AuthProvider>(ctx, listen: false).token});

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            userId: prodData['userId'],
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite'] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
