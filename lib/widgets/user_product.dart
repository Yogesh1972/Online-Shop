import 'package:flutter/material.dart';
import 'package:online_shop/provider/product.dart';
import '../Screen/edit_product_screens.dart';
import '../provider/products_provider.dart';
import 'package:provider/provider.dart';

class UserProduct extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProduct(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: MediaQuery.of(context).size.width * 0.29,
        child: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: id);
            },
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
          ),
          IconButton(
            onPressed: () async {
              try {
                Provider.of<Products>(context, listen: false).deleteProduct(id);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Product Deleted')));
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleting content failed')));
              }
            },
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).errorColor,
            ),
          ),
        ]),
      ),
    );
  }
}
