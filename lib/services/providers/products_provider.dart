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
      final Product response = await _repository.addProduct(product, ctx);
      _items.insert(0, response);
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

    try {
      await _repository.deleteProduct(id, ctx);
      existingProduct = null;
    } catch (e) {
      _items.insert(existingProductIndex, existingProduct!);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
  }

  Future<void> fetchAndSetProducts(BuildContext ctx) async {
    try {
      final Map<String, Product>? response =
          await _repository.fetchAndSetProduct(ctx);
      if (response == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      response.forEach((prodId, prodData) {
        Product old = prodData;
        loadedProducts.add(
          Product(
            id: prodId,
            userId: old.userId,
            title: old.title,
            description: old.description,
            price: old.price,
            imageUrl: old.imageUrl,
            isFavorite: prodData.isFavorite,
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
