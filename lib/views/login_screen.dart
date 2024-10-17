import 'package:flutter/material.dart';
import 'package:quick_shop_customer/widget/topwaveclipper.dart';
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
  bool _isObscured = true; // To track whether the password is hidden or shown

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
       // Dark background
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Custom curved yellow background at the top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: TopWaveClipper(),
                child: Container(
                  color: Colors.yellow,
                  height: 120, // Adjust height as needed
                ),
              ),
            ),

            // Login form
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 120), // Adjusted to fit below the wave
                  // "Welcome Back" Text
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Email TextField
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Password TextField with visibility toggle
                 TextField(
                  controller: _passwordController,
                  obscureText: _isObscured,
                   // Control the visibility of the password

                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off, // Toggle between icons
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured; // Toggle password visibility
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),

                  // "Forgot Password?" link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Forgot Password logic
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.yellow),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.yellow, // Button background color
                        padding: EdgeInsets.symmetric(vertical: 15),
                        
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  // Divider for "or login with"
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'or login with',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Google and Facebook Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Google Button
                      ElevatedButton.icon(
                        onPressed: () {
                          // Google Sign-In logic
                        },
                        icon: Image(image: AssetImage('asset/google.png',),
                        height: 25,
                        width: 25,), // Replace with actual Google icon or Image.asset
                        label: Text('Google'),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(screenWidth - 50, 50), // Same size as Sign Up button
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // Adds space between the buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Facebook Button
                      ElevatedButton.icon(
                        onPressed: () {
                          // Facebook Sign-In logic
                        },
                        icon: Icon(Icons
                            .facebook,
                            color: Colors.blue,
                            size: 25,), // Replace with actual Facebook icon or Image.asset
                        label: Text('Facebook'),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(screenWidth -50, 50), // Same size as Sign Up button
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // "Don't have an account? Sign Up" text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                          );
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(color: Colors.yellow),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// // Custom Clipper for the top yellow wave
// class TopWaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0, size.height); // Start from top left
//     var firstControlPoint = Offset(size.width / 4, size.height - 40);
//     var firstEndPoint = Offset(size.width / 2, size.height - 20);
//     path.quadraticBezierTo(
//         firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

//     var secondControlPoint = Offset(size.width * 3 / 4, size.height);
//     var secondEndPoint = Offset(size.width, size.height - 30);
//     path.quadraticBezierTo(
//         secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

//     path.lineTo(size.width, 0); // Go to the top right corner
//     path.close(); // Close the path
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return false; // No need to reclip
//   }
// }