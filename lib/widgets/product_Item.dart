import 'package:flutter/material.dart';
import 'package:online_shop/provider/auth_provider.dart';
import 'package:online_shop/provider/orders.dart';
import '../provider/cart.dart';
import '../provider/products_provider.dart';
import '../Screen/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String Imageurl;
  // final String Title;
  // final double price;

  // ProductItem(
  //   this.id,
  //   this.Imageurl,
  //   this.Title, //this.price
  // );

  @override
  Widget build(BuildContext context) {
    final ProductItems = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authdata = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.black26,
              ),
              borderRadius: BorderRadius.circular(20)),
          color: Colors.grey.shade300,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: ((ctx) => ProductDetailScreen(Title)),
                  //   ),
                  // );

                  Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                      arguments: ProductItems.id);
                },
                child: Hero(
                  //use to float one page over other
                  tag: ProductItems.id, //unuique tag per image
                  child: FadeInImage(
                    placeholder:
                        AssetImage('assets/images/product-placeholder.png'),
                    image: NetworkImage(ProductItems.ImageUrl),
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.27,
                    width: MediaQuery.of(context).size.width * 0.3,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      ProductItems.toggleFavStatus(
                          authdata.token!, authdata.userId!);
                    },
                    icon: Icon(ProductItems.Isfavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    color: Colors.red[500],
                  ),
                  //Icon(Icons.photo_camera_rounded),
                  Text(
                    ProductItems.Name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Consumer<Cart>(
                    builder: (ctx, value, ch) => IconButton(
                      onPressed: () {
                        cart.addItem(
                          ProductItems.id,
                          ProductItems.Name,
                          ProductItems.price,
                        );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            // backgroundColor: Colors.white,
                            content: Text(
                              'Item added to your cart',
                            ),
                            duration: Duration(
                              seconds: 1,
                              milliseconds: 50,
                            ),
                            action: SnackBarAction(
                              label: 'UNDO',
                              textColor: Colors.yellow,
                              onPressed: () {
                                cart.removeSingleItem(ProductItems.id);
                              },
                            ),
                          ),
                        ); //this make connection with nearest scafflod
                      }, //here which is on product overview
                      icon: Icon(
                        cart.itemInCart(ProductItems.id)
                            ? Icons.shopping_cart
                            : Icons.add_shopping_cart,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),

                  //Text('₹${price}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
