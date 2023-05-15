import 'package:flutter/material.dart';

import '../provider/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String prodID;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.prodID,
    required this.price,
    required this.quantity,
    required this.title,
    String? Title,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Are you sure ?',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            content: Text('Do you want to remove the item from cart ?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text(
                  'YES',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text(
                  'NO',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(prodID);
      },
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.all(10),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 6,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 40,
              child: Text('₹${price}'),
            ),
            title: Text(title),
            subtitle: Text('Total: ₹${(quantity * price)}'),
            trailing: Text('$quantity X'),
          ),
        ),
      ),
    );
  }
}
