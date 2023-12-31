import 'package:flutter/material.dart';
import 'package:my_shop/services/providers/products_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_shop/presentation/screens/products_overview_screen/components/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  const ProductsGrid(this.showFavs, {super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: ((context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: const ProductItem(),
      )),
    );
  }
}
