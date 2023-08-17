import 'package:flutter/material.dart';
import 'package:my_shop/models/http_exception.dart';
import 'package:my_shop/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
  ];



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

  Future<void> addProduct(Product product) async {
    final url = Uri.https(
        'my-shop-bd701-default-rtdb.firebaseio.com', '/products.json');
    // const url = 'https://my-shop-bd701-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );
      final Product newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final int productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url = Uri.https(
          'my-shop-bd701-default-rtdb.firebaseio.com', '/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.https(
        'my-shop-bd701-default-rtdb.firebaseio.com', '/products/$id.json');
    final int existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
     notifyListeners();
     final response = await http.delete(url);
    
      if(response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
    notifyListeners();
        throw HttpException('Could not delete product');
        
      }
    existingProduct = null;

      

     
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(
        'my-shop-bd701-default-rtdb.firebaseio.com', '/products.json');
        
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite'],
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
