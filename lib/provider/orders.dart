import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:online_shop/provider/cart.dart';
import 'package:http/http.dart' as http;

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String UserId;

  Order(this.authToken, this._orders, this.UserId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchandsetorder() async {
    final url = Uri.parse(
        "https://fluttermealapp-fb15d-default-rtdb.firebaseio.com/orders/$UserId.json?auth=$authToken");
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extradedData = json.decode(response.body) as Map<String, dynamic>;
    if (extradedData == null) {
      return;
    }
    extradedData.forEach((OrderId, OrderInfo) {
      loadedOrders.add(OrderItem(
        ID: OrderId,
        amount: OrderInfo['amount'],
        dateTime: DateTime.parse(OrderInfo['Datetime']),
        products: (OrderInfo['products'] as List<dynamic>)
            .map((item) => CartItem(
                id: item['id'],
                Title: item['title'],
                price: item['price'],
                quantity: item['Quantity']))
            .toList(),
      ));
      _orders = loadedOrders.reversed.toList();

      notifyListeners();
    });
  }

  Future<void> addOrder(List<CartItem> cartProducts, double Total) async {
    final url = Uri.parse(
        "https://fluttermealapp-fb15d-default-rtdb.firebaseio.com/orders/$UserId.json?auth=$authToken");
    final timestamp = DateTime.now();
    final repaonse = await http.post(
      url,
      body: json.encode(
        {
          'amount': Total,
          'Datetime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.Title,
                    'Quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        },
      ),
    );

    _orders.insert(
        0,
        OrderItem(
            ID: json.decode(repaonse.body)['name'],
            amount: Total,
            dateTime: DateTime.now(),
            products: cartProducts));
    notifyListeners();
  }
}

class OrderItem {
  final String ID;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem({
    required this.ID,
    required this.amount,
    required this.dateTime,
    required this.products,
  });
}
