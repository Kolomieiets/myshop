import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/services/api/order_api.dart';
import 'package:my_shop/services/models/cart_item.dart';
import 'package:my_shop/services/models/order_item_data.dart';
import 'package:my_shop/services/models/order_item_response.dart';
import 'package:my_shop/services/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class OrderRepository {
  late final Dio dio;

  OrderRepository() {
    dio = Dio();
  }

  Future<List<OrderItemData>?> getOrder(BuildContext ctx) async {
    final AuthProvider provider = Provider.of<AuthProvider>(ctx, listen: false);
    final List<OrderItemData> loadedOrders = [];

    late final OrderItemResponse? response;
    try {
      response = await OrderApi(dio).getOrder(provider.id!, provider.token!);
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
    if (response == null) {
      return null;
    }

    response.response!.forEach((key, value) {
      loadedOrders.add(value);
    });
    return loadedOrders;
  }

  void addOrder(OrderItemData order, BuildContext ctx,
      List<CartItem> cartProducts) async {
    final AuthProvider provider = Provider.of<AuthProvider>(ctx, listen: false);
    try {
      await OrderApi(dio).addOrder(
        provider.id!,
        provider.token!,
        order.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
