import 'package:flutter/material.dart';
import 'package:my_shop/services/providers/cart.dart';
import 'package:my_shop/presentation/screens/cart_screen/components/order_button.dart';
import 'package:my_shop/presentation/screens/cart_screen/components/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your cart')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).primaryTextTheme.titleMedium,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: ((ctx, index) => ChosenCartItem(
                        id: cart.items.values.toList()[index].id,
                        title: cart.items.values.toList()[index].title,
                        price: cart.items.values.toList()[index].price,
                        quantity: cart.items.values.toList()[index].quantity,
                        productId: cart.items.keys.toList()[index],
                      ))))
        ],
      ),
    );
  }
}


