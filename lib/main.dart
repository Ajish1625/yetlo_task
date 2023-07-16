import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yetlo_task/viewmodels/login_viewmodel.dart';
import 'package:yetlo_task/views/LoginScreen/login_screen.dart';

// Import your view and viewmodel files

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
      ],
      child: MaterialApp(
        home: LoginScreen(context),
      ),
    );
  }
}
