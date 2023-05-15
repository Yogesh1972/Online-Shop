import 'package:flutter/material.dart';
import 'package:online_shop/provider/cart.dart';
import 'package:online_shop/provider/products_provider.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';
import '../widgets/product_Item.dart';
import '../widgets/productsGrid.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';
import '../widgets/drawer.dart';

enum filteroption {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/OverViewScreen';
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showOnlyFavdata = false;
  var _init = true;
  var _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    // Provider.of<Products>(context).fetchandset(); wont work
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_init) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchandset().then((_) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context, listen: false);
    return Scaffold(
      drawer: appDrawer(),
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (filteroption SelectedValue) => {
              setState(
                () {
                  if (SelectedValue == filteroption.Favorites) {
                    showOnlyFavdata = true;
                  } else {
                    showOnlyFavdata = false;
                  }
                },
              )
            },
            //shape:ShapeBorder.lerp(00),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorites'),
                value: filteroption.Favorites,
              ),
              PopupMenuItem(
                child: Text('All Items'),
                value: filteroption.All,
              )
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cartdata, ch) =>
                Badge(child: ch!, value: cartdata.Itemcount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(Cart_Screen.routeName);
              },
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(
              showOnlyFavdata,
            ),
    );
  }
}
