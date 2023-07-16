import 'package:flutter/material.dart';

import '../views/HomeScreen/home_screen.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoggedIn = false;

  String email = '';
  String password = '';

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void setEmail(String value) {
    if (isValidEmail(value)) {
      email = value;
    } else {
      showSnackBar('Invalid email');
    }
    notifyListeners();
  }

  void setPassword(String value) {
    if (isValidPassword(value)) {
      password = value;
    } else {
      showSnackBar('Invalid password');
    }
    notifyListeners();
  }

  bool isValidEmail(String value) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(value);
  }

  bool isValidPassword(String value) {
    return value.length >= 6;
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState?.showSnackBar(snackBar);
  }

  Future<void> login(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    isLoggedIn = true;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }
}
