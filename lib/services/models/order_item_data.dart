import 'package:json_annotation/json_annotation.dart';
import 'package:my_shop/services/models/cart_item.dart';

part 'order_item_data.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderItemData {
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItemData({
    required this.amount,
    required this.dateTime,
    required this.products,
  });

  factory OrderItemData.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemDataToJson(this);
}