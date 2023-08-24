import 'package:my_shop/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_shop/models/order_item_data.dart';
import 'package:my_shop/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Order with ChangeNotifier {
  List<OrderItemData> _orders = [];

  List<OrderItemData> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders(BuildContext ctx) async {
    final url = Uri.https(
        'myshop-f49b2-default-rtdb.firebaseio.com',
        '/orders/${Provider.of<AuthProvider>(ctx, listen: false).id}.json',
        {'auth': Provider.of<AuthProvider>(ctx, listen: false).token});
    final response = await http.get(url);
    final List<OrderItemData> loadedOrders = [];
    final extractedData = json.decode(response.body);
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItemData(
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

  Future<void> addOrder(
      List<CartItem> cartProducts, double total, BuildContext ctx) async {
    final timestamp = DateTime.now();
    final url = Uri.https(
        'myshop-f49b2-default-rtdb.firebaseio.com',
        '/orders/${Provider.of<AuthProvider>(ctx, listen: false).id}.json',
        {'auth': Provider.of<AuthProvider>(ctx, listen: false).token});
    final response = await http.post(
      url,
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
      }),
    );
    _orders.insert(
        0,
        OrderItemData(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ));
    notifyListeners();
  }
}
