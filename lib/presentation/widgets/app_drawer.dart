import 'package:flutter/material.dart';
import 'package:my_shop/presentation/screens/order_screen/orders_screen.dart';
import 'package:my_shop/presentation/screens/user_products_screen/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello, friend'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage products'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, UserProductsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
