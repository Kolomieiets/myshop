import 'package:my_shop/services/api/api.dart';
import 'package:my_shop/services/api/order_repository.dart';
import 'package:my_shop/services/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/services/models/order_item_data.dart';

class Order with ChangeNotifier {
  final OrderRepository repository = OrderRepository();
  List<OrderItemData> _orders = [];
  final Api api = Api();

  List<OrderItemData> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders(BuildContext ctx) async {
    final List<OrderItemData> loadedOrders = [];
    final Map<String, dynamic>? extractedData =
        await repository.fetchAndSet(ctx);

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
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(
    List<CartItem> cartProducts,
    double total,
    BuildContext ctx,
  ) async {
    Map<String, dynamic> response = await repository.addOrder(cartProducts, total, ctx);
    _orders.insert(
        0,
        OrderItemData(
          id: response['id'],
          amount: total,
          products: cartProducts,
          dateTime: response['time'],
        ));
    notifyListeners();
  }
}
