import 'package:my_shop/services/models/cart_item.dart';

class OrderItemData {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItemData({
    required this.amount,
    required this.dateTime,
    required this.id,
    required this.products,
  });
}