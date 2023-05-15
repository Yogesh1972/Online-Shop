import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_shop/widgets/product_Item.dart';
import 'package:online_shop/widgets/productsGrid.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import '../model/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   Name: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   ImageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   Name: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   ImageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   Name: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   ImageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   Name: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   ImageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  var _ShowFavoritesOnly = false;

  List<Product> get items {
    if (_ShowFavoritesOnly) {
      return _items.where((ProductItems) => ProductItems.Isfavorite).toList();
    }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get FavItem {
    return _items.where((prod) => prod.Isfavorite).toList();
  }
  // void showfavoritesOnly() {
  //   _ShowFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _ShowFavoritesOnly = false;
  //   notifyListeners();
  // }
  String _authtoken;
  String _UserId;

  Products(this._authtoken, this._items, this._UserId);

  Future<void> addProduct(Product pro) async {
    try {
      final url = Uri.parse(
          'https://fluttermealapp-fb15d-default-rtdb.firebaseio.com/products.json?auth=$_authtoken'); //tells firebase to take only products with creatorID == userid
      final response = await http.post(
        url,
        body: json.encode(
          {
            'Name': pro.Name,
            'description': pro.description,
            'ImageUrl': pro.ImageUrl,
            'price': pro.price,
            // 'isFavorite': pro.Isfavorite,
            'creatorID': _UserId
          },
        ),
      );

      final newproduct = Product(
        Name: pro.Name,
        ImageUrl: pro.ImageUrl,
        description: pro.description,
        id: json.decode(response.body)['name'],
        price: pro.price,
      );
      _items.add(newproduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> UpdateProducts(String id, Product newProduct) async {
    final pordindex = _items.indexWhere((prod) => prod.id == id);

    if (pordindex >= 0) {
      final url = Uri.parse(
          'https://fluttermealapp-fb15d-default-rtdb.firebaseio.com/products/$id.json?auth=$_authtoken');
      http.patch(
        url,
        body: json.encode(
          {
            'Name': newProduct.Name,
            'description': newProduct.description,
            'ImageUrl': newProduct.ImageUrl,
            'price': newProduct.price,
          },
        ),
      );
      _items[pordindex] = newProduct;
    } else {
      //print('hello');
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://fluttermealapp-fb15d-default-rtdb.firebaseio.com/products.json?auth=$_authtoken');
    final existingProductIndex = _items.indexWhere((value) => value.id == id);
    var exisingProduct = _items[existingProductIndex];

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, exisingProduct);
      notifyListeners();
      throw Http_Exception('message');
    }
    _items.removeAt(existingProductIndex);
    notifyListeners();
  }

  Future<void> fetchandset([bool filterByUser = false]) async {
    //[] make it optional parameter
    final filterString =
        filterByUser ? '"orderBy="creatorID"&equalTo="$_UserId"' : '';
    final url = Uri.parse(
        'https://fluttermealapp-fb15d-default-rtdb.firebaseio.com/products.json?auth=$_authtoken&$filterString');
    //  try {
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    final url2 = Uri.parse(
        'https://fluttermealapp-fb15d-default-rtdb.firebaseio.com/togglefavorite/$_UserId.json?auth=$_authtoken');
    final Favresponse = await http.get(url2);
    final FavData = json.decode(Favresponse.body); // is the map of body
    final List<Product> loadedProducts = [];
    extractedData.forEach(
      (prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            Name: prodData['Name'],
            description: prodData['description'],
            price: prodData['price'],
            ImageUrl: prodData['ImageUrl'],
            Isfavorite: FavData == null
                ? false
                : FavData[prodId] ??
                    false, //??check if the value is null or not
          ),
        );
      },
    );
    _items = loadedProducts;
    notifyListeners();
    // } catch (error) {
    //   throw (error);
    // }
  }

  void updateUser(String token, String id) {
    this._UserId = id;
    this._authtoken = token;
    notifyListeners();
  }
}
