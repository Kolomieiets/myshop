import 'package:flutter/material.dart';
import 'package:my_shop/services/api/api.dart';
import 'package:my_shop/services/models/cart_item.dart';
import 'package:my_shop/services/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class OrderRepository {
  late final Api _api;

  OrderRepository() {
    _api = Api();
  }

  Future<Map<String, dynamic>?> fetchAndSet(BuildContext ctx) async {
    final AuthProvider provider = Provider.of<AuthProvider>(ctx, listen: false);
    final Uri url = Uri.https(
      'myshop-f49b2-default-rtdb.firebaseio.com',
      '/orders/${provider.id}.json',
      {'auth': provider.token},
    );
    final response = await _api.get(url.toString());
    return response.data;
  }

  Future<Map<String, dynamic>> addOrder(
    List<CartItem> cartProducts,
    double total,
    BuildContext ctx,
  ) async {
    final AuthProvider provider = Provider.of<AuthProvider>(ctx, listen: false);
    final DateTime timestamp = DateTime.now();
    final url = Uri.https(
      'myshop-f49b2-default-rtdb.firebaseio.com',
      '/orders/${provider.id}.json',
      {'auth': provider.token},
    );
    final response = await _api.post(
      url.toString(),
      data: {
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
      },
    );
    return {'id' : response.data['name'], 'time': timestamp};
  }
}
