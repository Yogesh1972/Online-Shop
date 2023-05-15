import 'package:flutter/material.dart';
import '../helpers/custom_route.dart';
import '../provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../Screen/ordersScreen.dart';
import '../Screen/userProductScreen.dart';

class appDrawer extends StatelessWidget {
  const appDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('App'),
            automaticallyImplyLeading:
                false, //donot give a back button on appbar
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payment'),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
              Navigator.of(context).pushReplacement(
                CustomRoute(
                  builder: (ctx) => OrderScreen(),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Add Product'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(
                  '/'); // woulf ensure that if we logout it will go to auth screen
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
