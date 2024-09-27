import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'views/login_screen.dart';
import 'views/nav.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick shop',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<String?>(
        future: _apiService.getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data != null) {
              return nav();
            } else {
              return LoginScreen();
            }
          }
        },
      ),
    );
  }
}
