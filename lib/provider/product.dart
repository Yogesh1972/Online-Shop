import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String Name;
  final String description;
  final double price;
  final String ImageUrl;
  bool Isfavorite;

  Product({
    required this.id,
    required this.ImageUrl,
    required this.Name,
    required this.description,
    required this.price,
    this.Isfavorite = false,
  });

  Future<void> toggleFavStatus(String token, String userid) async {
    final url = Uri.parse(
        "https://fluttermealapp-fb15d-default-rtdb.firebaseio.com/togglefavorite/$userid/$id.json?auth=$token");
    var oldstatus = Isfavorite;
    Isfavorite = !Isfavorite;
    notifyListeners();

    try {
      final response = await http.put(
        url,
        body: json.encode(
          Isfavorite,
        ),
      );
      if (response.statusCode > 400) {
        Isfavorite = oldstatus;
        notifyListeners();
      }
    } catch (Error) {
      //as error is not given by try catch block for patch we need use
      //the one reponse.status as it would provide us the error

    }
  }
}
