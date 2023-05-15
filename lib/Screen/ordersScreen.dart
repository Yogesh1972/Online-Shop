import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../provider/orders.dart' show Order;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';
import '../widgets/drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future _orderFuture;

  Future _obtainOrders() {
    return Provider.of<Order>(context, listen: false).fetchandsetorder();
  }

  @override
  void initState() {
    // TODO: implement initState
    _orderFuture = _obtainOrders();
    super.initState();
  }

  // var _IsLoading = false;
  @override
  // void initState() {
  //   // Future.delayed(
  //   //   Duration.zero,).then((_) async {

  //   _IsLoading = true;                                            //as listen is false
  //                                                                 //the future delayed is not needed as this need to be build only once
  //                                                                 //and init build it before  loadig all the  widegts but Model route cannot be used here as there is no option to listen false
  //    Provider.of<Order>(context, listen: false).fetchandsetorder().then((_) {
  //     setState(() {
  //       _IsLoading = false;
  //     });
  //   });
  //   //  });
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orders = Provider.of<Order>(context); this will lead to infinte loop of extrading data
    return Scaffold(
      drawer: appDrawer(),
      appBar: AppBar(
        title: const Text('YOUR ORDERS'),
      ),
      body: FutureBuilder(
        //this can be not useful as this can be build again if  another widget here needs to be build again
        //better way is to convert into stateful and give a future
        future: _orderFuture, //this will ensure no new future is generated
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Order>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
