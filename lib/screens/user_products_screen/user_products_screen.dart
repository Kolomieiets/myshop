import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth_provider.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:my_shop/screens/user_products_screen/components/edit_product.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/screens/user_products_screen/components/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatefulWidget {
  const UserProductsScreen({super.key});
  static const String routeName = '/user-products';

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(context);
  }

  @override
  void initState() {
    // _refreshProducts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (_, i) {
              return productsData.items[i].userId ==
                      Provider.of<AuthProvider>(context).id
                  ? Column(
                      children: [
                        UserProductItem(
                          productsData.items[i].id!,
                          productsData.items[i].title,
                          productsData.items[i].imageUrl,
                        ),
                        const Divider(),
                      ],
                    )
                  : const SizedBox();
            },
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
