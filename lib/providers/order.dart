import 'package:flutter/foundation.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class OrderItemProvider {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItemProvider({
    required this.amount,
    required this.dateTime,
    required this.id,
    required this.products,
  });
}

class Order with ChangeNotifier {
  List<OrderItemProvider> _orders = [];

  List<OrderItemProvider> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        Uri.https('my-shop-bd701-default-rtdb.firebaseio.com', '/orders.json');
    final response = await http.get(url);
    final List<OrderItemProvider> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItemProvider(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final url =
        Uri.https('my-shop-bd701-default-rtdb.firebaseio.com', '/orders.json');
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItemProvider(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ));
    notifyListeners();
  }
}
