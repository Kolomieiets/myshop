import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:provider/provider.dart';

class ChosenCartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  const ChosenCartItem({
    required this.productId,
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('Do you want to remove this item from the cart?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);},
                    child: const Text('Yes'),
                  ),
                ],
              );
            });
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text('\$$price'),
                  )),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
