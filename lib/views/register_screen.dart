import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final ApiService _apiService = ApiService();
  String? _errorMessage; // Variable to hold error messages

  void _register() async {
    // Clear previous error message
    setState(() {
      _errorMessage = null;
    });

    // Get user input
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String passwordConfirmation = _passwordConfirmController.text;

    // Attempt registration
    try {
      await _apiService.register(name, email, password, passwordConfirmation);
      // Navigate to Login screen on success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      // Handle error and set error message
      setState(() {
        _errorMessage = e.toString(); // Update error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Name Field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            // Email Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            // Password Field
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            // Password Confirmation Field
            TextField(
              controller: _passwordConfirmController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // Error Message Display
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            // Register Button
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
            // Navigation to Login Screen
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
