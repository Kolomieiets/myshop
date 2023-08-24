import 'package:flutter/material.dart';
import 'package:my_shop/helpers/custom_route.dart';
import 'package:my_shop/providers/auth_provider.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/order.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:my_shop/screens/auth_screen/auth_screen.dart';
import 'package:my_shop/screens/cart_screen/cart_screen.dart';
import 'package:my_shop/screens/user_products_screen/components/edit_product.dart';
import 'package:my_shop/screens/order_screen/orders_screen.dart';
import 'package:my_shop/screens/product_detail_screen/product_detail_screen.dart';
import 'package:my_shop/screens/products_overview_screen/products_overview_screen.dart';
import 'package:my_shop/screens/user_products_screen/user_products_screen.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => ProductsProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => CartProvider(),
          ),
          ChangeNotifierProvider.value(value: Order())
        ],
        child: Consumer<AuthProvider>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              // primarySwatch: Colors.purple,
              colorScheme: const ColorScheme.light(
                secondary: Colors.deepOrange,
                primary: Colors.purple,
              ),
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                },
              ),
            ),
            home: auth.isAuth ? const ProductsOverviewScreen() : const AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (context) =>
                  const ProductDetailScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              UserProductsScreen.routeName: (context) =>
                  const UserProductsScreen(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen(),
            },
          ),
        ));
  }
}
