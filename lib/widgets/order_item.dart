import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/orders.dart' as OI;
import 'package:intl/intl.dart';

import 'dart:math';

class OrderItem extends StatefulWidget {
  final OI.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    //final orderData=Provider.of<Order>(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20 + 160, 200) : 115,
      curve: Curves.bounceIn,
      child: Card(
        borderOnForeground: true,
        margin: EdgeInsets.all(10),
        color: Colors.indigo[200],
        elevation: 10,
        child: Column(
          children: [
            ListTile(
              title: Text('₹${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/YYYY - hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              height: _expanded
                  ? min(widget.order.products.length * 10 + 50, 200)
                  : 0,
              width: double.infinity,
              child: ListView.builder(
                itemBuilder: (context, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      widget.order.products[index].Title,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${widget.order.products[index].quantity}\t x\t ₹${widget.order.products[index].price}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 204, 138, 52)),
                    ),
                  ],
                ),
                itemCount: widget.order.products.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
