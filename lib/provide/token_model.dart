import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenModel with ChangeNotifier {
  String token;

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print("model: $token");
    notifyListeners();
  }
}