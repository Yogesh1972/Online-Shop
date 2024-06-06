//import 'dart:io';

import 'dart:io';

import 'package:flutter/widgets.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../model/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyD0b5N_jPkl1IXODxA8cVOguyvUcn2_RI8");

    // final url =
    //     'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzxxxxxxxxxxxxEbkB-wjedoF8iYENlQ';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      //_autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  // Future<bool> tryAutoLogin() async {
  //   // GET DATA FROM SHARED PREFERENCES
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('userData')) {
  //     return false;
  //   }
  //   final extractedUserData =
  //       json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
  //   final expiryDate = DateTime.parse(extractedUserData['expiry']);

  //   // IF EXPIRED
  //   if (expiryDate.isBefore(DateTime.now())) {
  //     return refreshToken();
  //   }

  //   // IF NOT EXPIRED
  //   _token = extractedUserData['token'];
  //   _userId = extractedUserData['userId'];
  //   _expiryDate = expiryDate;
  //   notifyListeners();
  //   return true;
  // }

  Future<void> logout() async {
    _token = '';
    _userId = '';
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    // GET DATA FROM SHARED PREFERENCES
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    // IF EXPIRED
    if (expiryDate.isBefore(DateTime.now())) {
      return refreshToken();
    }

    // IF NOT EXPIRED
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<bool> refreshToken() async {
    // POST HTTP REQUEST
    final url =
        Uri.parse('https://securetoken.googleapis.com/v1/token?key=[API_KEY]');

    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'grant_type': 'refresh_token',
            'refresh_token': extractedUserData['refreshToken'],
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        return false;
      }
      _token = responseData['id_token'];
      _userId = responseData['user_id'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expires_in'],
          ),
        ),
      );
      notifyListeners();

      // STORE DATA IN SHARED PREFERENCES
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);

      final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
      _authTimer = Timer(Duration(seconds: timeToExpiry), tryAutoLogin);
      return true;
    } catch (error) {
      return false;
    }
  }

  // Future<void> _autoLogout() async{
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('userData')) {
  //      false;
  //   }
  //   final extractedUserData = json.decode(prefs.getString('userData')!) as Map<String, Object>;
  //   final _expiryDate = DateTime.parse(extractedUserData['expiryDate']);

  //   if (_authTimer != null) {
  //     _authTimer!.cancel();
  //   }
  //   final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  // }
}
