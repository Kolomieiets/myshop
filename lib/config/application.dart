import 'package:flutter/material.dart';
import 'package:my_shop/config/custom_route.dart';
import 'package:my_shop/config/router.dart';
import 'package:my_shop/services/providers/auth_provider.dart';
import 'package:my_shop/services/providers/cart.dart';
import 'package:my_shop/services/providers/order.dart';
import 'package:my_shop/services/providers/products_provider.dart';
import 'package:my_shop/presentation/screens/auth_screen/auth_screen.dart';
import 'package:my_shop/presentation/screens/products_overview_screen/products_overview_screen.dart';
import 'package:provider/provider.dart';

class Application extends StatelessWidget {
  const Application({super.key});
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
            routes: MyRouter.routes,
          ),
        ));
  }
}