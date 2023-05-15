import 'package:flutter/material.dart';
import 'package:online_shop/provider/product.dart';
import '../provider/products_provider.dart';
import './product_Item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool fav;
// final List<Product> Product;

  ProductGrid(this.fav);

  @override
  Widget build(BuildContext context) {
    final Product_data = Provider.of<Products>(context);
    final Product = fav ? Product_data.FavItem : Product_data.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: MediaQuery.of(context).size.height * 0.02,
          mainAxisExtent: MediaQuery.of(context).size.height *
              0.345), //how grid is structured
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: Product[index],
        child: ProductItem(
            // Product[index].id,
            // Product[index].ImageUrl,
            // Product[index].Name,
            //Product[index].price,
            ),
      ),
      itemCount: Product.length,
    );
  }
}
