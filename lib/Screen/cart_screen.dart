import 'package:flutter/material.dart';
import '../provider/cart.dart' show Cart;
import 'package:provider/provider.dart';
import '../widgets/cart_Item.dart';
import '../provider/orders.dart';

class Cart_Screen extends StatelessWidget {
  static const routeName = '/cartScreen';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Order>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Item'),
      ),
      body: Column(
        children: [
          Card(
            // color: Colors.amber,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '₹${cart.TotalAmount}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Theme.of(context).backgroundColor,
                  ),

                  orderButton(cart: cart, orders: orders)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => CartItem(
                id: cart.items.values.toList()[index].id,
                prodID: cart.items.keys.toList()[index],
                title: cart.items.values.toList()[index].Title,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
              ),
              itemCount: cart.Itemcount,
            ),
          ),
        ],
      ),
    );
  }
}

class orderButton extends StatefulWidget {
  const orderButton({
    Key? key,
    required this.cart,
    required this.orders,
  }) : super(key: key);

  final Cart cart;
  final Order orders;

  @override
  State<orderButton> createState() => _orderButtonState();
}

class _orderButtonState extends State<orderButton> {
  var _Isloading = false;
  @override
  Widget build(BuildContext context) {
    return _Isloading
        ? SizedBox(
            child: CircularProgressIndicator(),
            height: 20.0,
            width: 20.0,
          )
        : TextButton(
            onPressed: widget.cart.TotalAmount <= 0
                ? null
                : () async {
                    setState(() {
                      _Isloading = true;
                    });
                    await widget.orders.addOrder(
                        widget.cart.items.values.toList(),
                        widget.cart.TotalAmount);
                    setState(() {
                      _Isloading = false;
                    });
                    widget.cart.clearCart();
                  },
            child: Text(
              'Place Order',
              style: TextStyle(
                  color: Colors.amber[800],
                  //fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          );
  }
}
