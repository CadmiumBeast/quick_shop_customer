import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:quick_shop_customer/consts.dart';
import 'services/api_service.dart';
import 'views/login_screen.dart';
import 'views/nav.dart';

void main() async {
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
}

class MyApp extends StatelessWidget {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick Shop',
      theme: ThemeData.light().copyWith(
        primaryColor: const Color.fromARGB(255, 2, 22, 39),
        scaffoldBackgroundColor: Colors.white,
        textTheme: ThemeData.light().textTheme,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.grey[800],
        scaffoldBackgroundColor: Colors.black,
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white,
            ),
      ),
      themeMode: ThemeMode
          .system, // Use system theme mode (light or dark based on system settings)
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
