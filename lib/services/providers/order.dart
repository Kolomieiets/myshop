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
    final List<OrderItemData>? extractedData = await repository.getOrder(ctx);

    if (extractedData == null) {
      return;
    } else {
      _orders = extractedData;
    }
    notifyListeners();
  }

  Future<void> addOrder(
    List<CartItem> cartProducts,
    double total,
    BuildContext ctx,
  ) async {
    OrderItemData order = OrderItemData(
      amount: total,
      products: cartProducts,
      dateTime: DateTime.now(),
    );
    repository.addOrder(order, ctx, cartProducts);
    _orders.insert(0, order);
    notifyListeners();
  }
}
