import 'package:flutter/material.dart';
import 'package:my_shop/screens/cart_screen/cart_screen.dart';
import 'package:my_shop/screens/order_screen/orders_screen.dart';
import 'package:my_shop/screens/product_detail_screen/product_detail_screen.dart';
import 'package:my_shop/screens/user_products_screen/components/edit_product.dart';
import 'package:my_shop/screens/user_products_screen/user_products_screen.dart';

class MyRouter {
  static Map<String, Widget Function(BuildContext)> routes = {
    ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
    CartScreen.routeName: (context) => const CartScreen(),
    OrdersScreen.routeName: (context) => const OrdersScreen(),
    UserProductsScreen.routeName: (context) => const UserProductsScreen(),
    EditProductScreen.routeName: (context) => const EditProductScreen(),
  };
}
