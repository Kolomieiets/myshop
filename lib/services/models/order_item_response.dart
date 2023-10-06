import 'package:my_shop/services/models/order_item_data.dart';

class OrderItemResponse {
  final Map<String, OrderItemData>? response;

  OrderItemResponse(this.response);

   factory OrderItemResponse.fromJson(Map<String, dynamic>? json) {
    
    Map<String, OrderItemData> newResponse = {};
    if (json == null) {
      return OrderItemResponse(newResponse);
    }
    json.forEach((key, value) {
      newResponse.addAll({key: OrderItemData.fromJson(value)});
    });
    return OrderItemResponse(newResponse);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    response!.forEach((key, value) {
      json.addAll({key: value.toJson()});
    });
    return json;
  }
}
