import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String Title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.Title,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(
    String id,
    String Title,
    double Price,
  ) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (exsistingItem) => CartItem(
              id: exsistingItem.id,
              Title: exsistingItem.Title,
              price: (exsistingItem.price),
              quantity: (exsistingItem.quantity + 1)));
    } else {
      _items.putIfAbsent(
          id,
          () => CartItem(
                id: DateTime.now().toString(),
                Title: Title,
                price: Price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  int get Itemcount {
    return _items == null ? 0 : _items.length;
  }

  bool itemInCart(String productId) {
    return _items.containsKey(productId);
  }

  double get TotalAmount {
    var total = 0.0;
    _items.forEach((key, CartItem) {
      total = total + CartItem.price * CartItem.quantity;
    });
    return total;
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id]!.quantity > 1) {
      _items.update(
        id,
        (existigncartItem) => CartItem(
          id: id,
          Title: existigncartItem.Title,
          price: existigncartItem.price,
          quantity: (existigncartItem.quantity - 1),
        ),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }
}
