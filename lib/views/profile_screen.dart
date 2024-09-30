import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart'; // Ensure to import your LoginScreen
import 'update_profile_screen.dart'; // Ensure to import your new UpdateProfilePage

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiService apiService = ApiService();
  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await apiService.fetchProfile();
      setState(() {
        name = profile['name'];
        email = profile['email'];
      });
    } catch (e) {
      print(e);
    }
  }

  void _logout() async {
    await apiService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _navigateToUpdateProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              UpdateProfilePage(currentName: name, currentEmail: email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the customer's name
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Display the customer's email
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Button to navigate to the Update Profile screen
            ElevatedButton(
              onPressed: _navigateToUpdateProfile,
              child: Text('Update Profile'),
            ),
            SizedBox(height: 20),
            // Logout button
            ElevatedButton(
              onPressed: _logout,
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Customize your button color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
