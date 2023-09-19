import 'package:flutter/material.dart';
import 'package:my_shop/services/providers/order.dart';
import 'package:my_shop/presentation/widgets/app_drawer.dart';
import 'package:my_shop/presentation/screens/order_screen/components/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static const String routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Order>(context, listen: false)
        .fetchAndSetOrders(context);
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your orders'),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (dataSnapshot.error != null) {
              return const Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Order>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (context, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          },
        ));
  }
}
