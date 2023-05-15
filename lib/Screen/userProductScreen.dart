import 'package:flutter/material.dart';
import 'package:online_shop/widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';
import '../widgets/user_product.dart';
import '../Screen/edit_product_screens.dart';

class UserProductScreen extends StatelessWidget {
  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchandset(true);
  }

  const UserProductScreen({super.key});
  static const routeName = '/userProductSscreen';

  @override
  Widget build(BuildContext context) {
    // final productdetail = Provider.of<Products>(context);
    return Scaffold(
      drawer: appDrawer(),
      appBar: AppBar(
        title: const Text('Add Items'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (context, productdetail, _) => Padding(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                          itemBuilder: (context, index) => Column(
                            children: [
                              UserProduct(
                                productdetail.items[index].id,
                                productdetail.items[index].Name,
                                productdetail.items[index].ImageUrl,
                              ),
                              Divider(
                                color: Colors.black,
                              )
                            ],
                          ),
                          itemCount: productdetail.items.length,
                        ),
                      ),
                    )),
      ),
    );
  }
}
