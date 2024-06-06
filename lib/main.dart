import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import './Screen/splash_screen.dart';
import 'package:online_shop/Screen/cart_screen.dart';
import 'package:online_shop/Screen/ordersScreen.dart';
import 'package:online_shop/provider/auth_provider.dart';
import 'package:online_shop/provider/orders.dart';
import 'package:provider/provider.dart';

import './helpers/custom_route.dart';
import './Screen/product_overview_screen.dart';
import './Screen/product_detail_screen.dart';
import './provider/products_provider.dart';
import './provider/cart.dart';
import './Screen/userProductScreen.dart';
import './Screen/edit_product_screens.dart';
import './Screen/auth_screen.dart';

void main() {
  runApp(online_shop());
}

class online_shop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products('', [], ''),
            //<provider depend on , provider provide>
            //this depends on a provider and is itself a provider
            update: (ctx, auth, previousproducts) => Products(
              auth.token ?? '',
              previousproducts == null ? [] : previousproducts.items,
              auth.userId ?? '',
            ), //the builder will recive the auth object as the proxy will look for other provider with Auth object
          ), //whenever auth changes this provider will als rebuild
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            create: (_) => Order('', [], ''),
            //<provider depend on , provider provide>
            //this depends on a provider and is itself a provider
            update: (ctx, auth, previousorder) => Order(
              auth.token!,
              previousorder == null ? [] : previousorder.orders,
              auth.userId!,
            ),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) {
            return MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.cyan,
                //  accentColor: Colors.blueGrey,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder(),
                  }, //cannot assign custom route directly a it takes only transitions
                ),
              ),
              home: auth.isAuth != true
                  ? FutureBuilder(
                      builder: ((context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()),
                      future: auth.tryAutoLogin(),
                    )
                  : ProductOverviewScreen(),
              debugShowCheckedModeBanner: false,
              // initialRoute: AuthScreen.routeName,
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                Cart_Screen.routeName: (ctx) => Cart_Screen(),
                OrderScreen.routeName: (ctx) => OrderScreen(),
                UserProductScreen.routeName: (ctx) => UserProductScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
                AuthScreen.routeName: (ctx) => AuthScreen(),
                ProductOverviewScreen.routeName: (ctx) =>
                    ProductOverviewScreen(),
              },
            );
          },
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
      ),
      body: Center(
        child: Text('lets make a shop'),
      ),
    );
  }
}
