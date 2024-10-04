import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'nav.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  void _login() async {
    try {
      await _apiService.login(_emailController.text, _passwordController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nav()),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme
    final isDarkMode = theme.brightness == Brightness.dark;

    // Get the width and height of the screen
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Adapt background color
      body: SingleChildScrollView(
        // Make the body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // Center the column in the body
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            children: [
              Container(
                width: screenWidth *
                    0.25, // Set width to a percentage of the screen width
                height: screenWidth *
                    0.25, // Keep height proportional to width for circular shape
                child: ClipOval(
                  child: Image.network(
                    'https://static.vecteezy.com/system/resources/previews/022/927/277/non_2x/clothing-store-logo-design-inspiration-cloth-shop-logo-clothes-logo-illustration-vector.jpg', // Logo URL
                    fit: BoxFit.cover, // Ensures the image covers the circle
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: screenWidth * 0.9, // Set a width for the text fields
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        color: theme.textTheme.bodyLarge
                            ?.color), // Adapt label text color
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: theme.textTheme.bodyLarge?.color ??
                              Colors.grey), // Adapt border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: theme
                              .primaryColor), // Primary color for focused border
                    ),
                  ),
                  style: TextStyle(
                      color:
                          theme.textTheme.bodyLarge?.color), // Adapt text color
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: screenWidth * 0.9, // Set a width for the text fields
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                        color: theme.textTheme.bodyLarge
                            ?.color), // Adapt label text color
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: theme.textTheme.bodyLarge?.color ??
                              Colors.grey), // Adapt border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: theme
                              .primaryColor), // Primary color for focused border
                    ),
                  ),
                  obscureText: true,
                  style: TextStyle(
                      color:
                          theme.textTheme.bodyLarge?.color), // Adapt text color
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme
                      .primaryColor, // Use primary color for button background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: isDarkMode
                          ? Colors.black
                          : Colors.white), // Adapt button text color
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text(
                  'Don\'t have an account? Register',
                  style: TextStyle(
                      color:
                          theme.textTheme.bodyLarge?.color), // Adapt text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
