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
  String bio = 'A passionate user of our services!'; // Sample bio
  String profileImage =
      'https://via.placeholder.com/150'; // Sample profile image

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
        bio = profile['bio'] ?? bio; // Assuming 'bio' can be fetched
        profileImage = profile['profileImage'] ??
            profileImage; // Assuming 'profileImage' can be fetched
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
            UpdateProfilePage(currentName: name, currentEmail: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).brightness == Brightness.dark; // Check for dark mode

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profileImage),
              ),
            ),
            SizedBox(height: 20),

            // Welcome message
            Text(
              'Welcome, $name!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Bio
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              color: Theme.of(context).cardColor, // Use theme color
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.info, size: 30),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bio',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            bio,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Divider
            Divider(height: 20, thickness: 1),

            // Display the customer's name
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(name, style: TextStyle(fontSize: 16)),
            ),

            // Divider
            Divider(height: 20, thickness: 1),

            // Display the customer's email
            ListTile(
              leading: Icon(Icons.email),
              title: Text(
                'Email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(email, style: TextStyle(fontSize: 16)),
            ),

            SizedBox(height: 20),

            // Divider
            Divider(height: 20, thickness: 1),

            // Button to navigate to the Update Profile screen
            Container(
              padding: EdgeInsets.only(left: 16.0),
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Update Profile'),
                onTap: _navigateToUpdateProfile,
                tileColor: isDarkMode
                    ? Colors.black
                    : Colors.white, // Button background color
                textColor: isDarkMode
                    ? Colors.white
                    : Colors.black, // Button text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),

            // Divider
            Divider(height: 20, thickness: 1),

            // Logout button
            Container(
              padding: EdgeInsets.only(left: 16.0),
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: _logout,
                tileColor: isDarkMode
                    ? Colors.black
                    : Colors.white, // Button background color
                textColor: isDarkMode
                    ? Colors.white
                    : Colors.black, // Button text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
