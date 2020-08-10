import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';
import 'package:shop_app/screens/edit_products_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : snapshot.error != null
                    ? Center(
                        child: Text('An error occurred!'),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _refreshProducts(context),
                        child: Consumer<Products>(
                          builder: (ctx, productData, _) => Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: productData.items.length,
                              itemBuilder: (_, i) => Column(
                                children: <Widget>[
                                  UserProductItem(
                                    productData.items[i].id,
                                    productData.items[i].title,
                                    productData.items[i].imageUrl,
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
      ),
    );
  }
}
