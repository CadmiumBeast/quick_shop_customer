import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UpdateProfilePage extends StatefulWidget {
  final String currentName;
  final String currentEmail;

  UpdateProfilePage({required this.currentName, required this.currentEmail});

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final ApiService apiService = ApiService();
  late String name;
  late String email;

  @override
  void initState() {
    super.initState();
    name = widget.currentName;
    email = widget.currentEmail;
  }

  Future<void> _updateProfile() async {
    try {
      await apiService.updateProfile(name, email);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')));
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get device orientation
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(title: Text('Update Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content in portrait
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) => setState(() => name = value),
              controller: TextEditingController(text: name),
            ),
            SizedBox(
                height: isPortrait
                    ? 10
                    : 20), // Adjust spacing based on orientation
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) => setState(() => email = value),
              controller: TextEditingController(text: email),
            ),
            SizedBox(height: 20),
            // Use Row for positioning the button
            Row(
              mainAxisAlignment: isPortrait
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text('Update Profile'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
