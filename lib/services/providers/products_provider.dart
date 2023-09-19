import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/services/api/product_repository.dart';
import 'package:my_shop/services/models/http_exception.dart';
import 'package:my_shop/services/providers/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  final ProductRepository _repository = ProductRepository();

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

  Future<void> addProduct(
    Product product,
    BuildContext ctx,
  ) async {
    try {
      final Response<dynamic> response =
          await _repository.addProduct(product, ctx);
      final Product newProduct = Product(
        id: response.data['name'],
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
    String id,
    Product newProduct,
    BuildContext ctx,
  ) async {
    final int productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      _repository.updateProduct(id, newProduct, ctx);
      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id, BuildContext ctx) async {
    final int existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await _repository.deleteProduct(id, ctx);

    if (response.statusCode! >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }

  Future<void> fetchAndSetProducts(BuildContext ctx) async {
    try {
      final response = await _repository.fetchAndSetProduct(ctx);
      final extractedData = response.data;
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
