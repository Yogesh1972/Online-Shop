import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';
import 'package:provider/provider.dart';

//import '../';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/productDetail';
  // final String Title;

  // ProductDetailScreen(this.Title);

  @override
  Widget build(BuildContext context) {
    final ProductId = ModalRoute.of(context)!.settings.arguments
        as String; // gives Product id
    final loadedProdect = Provider.of<Products>(
      context,
      listen: false,
    ).findById(ProductId);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProdect.Name),
              background: Hero(
                tag: loadedProdect.id,
                child: Image.network(
                  loadedProdect.ImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                loadedProdect.description,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              '₹${loadedProdect.price}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 800),
          ]) //how to render a context
              ) //save as list view
        ], //parts on screen that can scroll
      ),
    );
  }
}
