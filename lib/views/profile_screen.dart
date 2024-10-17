import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'update_profile_screen.dart';

class ProfilePage extends StatefulWidget {
  final File? profileImage; // Receive the profile image
  final Function(File) onImagePicked;

  const ProfilePage({
    Key? key,
    required this.profileImage,
    required this.onImagePicked,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiService apiService = ApiService();
  String name = 'Rifkhan Faris'; // Sample name based on the design
  String profileImage = 'https://via.placeholder.com/150';
  String email = 'No Mail Found';
  File? _profileImage; // Local image to be displayed
  String _address = 'Searching...'; // Store user location
  String _currentpostion = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _getCurrentLocation(); // Fetch user location when the screen loads
    _profileImage = widget.profileImage;
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await apiService.fetchProfile();
      setState(() {
        email = profile['email'];
        name = profile['name'];
        profileImage = profile['profileImage'] ?? profileImage;
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
  Future<void> _pickImageFromProfile() async {
    final ImagePicker _picker = ImagePicker();

    // Show dialog to select image source
    final String? source = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Camera'),
              child: Text('Camera'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'Gallery'),
              child: Text('Gallery'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (source == 'Camera') {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
      _updateProfileImage(pickedFile);
    } else if (source == 'Gallery') {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      _updateProfileImage(pickedFile);
    }
  }

// Helper method to update the profile image
  void _updateProfileImage(XFile? pickedFile) {
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path); // Update local image
      });
      widget.onImagePicked(File(pickedFile.path)); // Notify parent of new image
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions')),
      );
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied (actual value: $permission).')),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentpostion =
      'Lat: ${position.latitude}, Long: ${position.longitude}';
    });

    await _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
        _address = '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting address: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView( // Added scrollable behavior
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40), // Spacing at the top

              // Profile Picture and Edit Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                      child: _profileImage == null ? Icon(Icons.person, size: 40) : null,
                    ),
                    Positioned(
                      bottom: -5,
                      right: -5,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: _pickImageFromProfile,
                        color: Colors.amber,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(CircleBorder()),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
              SizedBox(height: 16),

              // Name
              Center(
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.pin_drop, size: 20),
                    SizedBox(width: 10),
                    Expanded(  // Ensure the text takes only the available space
                      child: Text(
                        _address, // Display the address
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Options (Notifications, Dark Mode, etc.)
              ListTile(
                title: Text('Notifications',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                trailing: Switch(
                  value: false,
                  onChanged: (val) {
                    // Handle notifications toggle
                  },
                ),
              ),
              ListTile(
                title: Text('Dark Mode',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (val) {
                    // Handle dark mode toggle
                  },
                ),
              ),
              ListTile(
                title: Text('Update Profile',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                trailing: Icon(Icons.edit, color: Colors.yellow),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateProfilePage(currentName: name, currentEmail: email, profileImage: _profileImage,)), // Navigate to update profile
                  );
                },
              ),
              ListTile(
                title: Text('Language',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                trailing: Icon(Icons.language, color: Colors.yellow),
              ),
              ListTile(
                title: Text('Help',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                trailing: Icon(Icons.help, color: Colors.yellow),
              ),
              SizedBox(height: 24),

              // Sign Out button
              Center(
                child: TextButton(
                  onPressed: _logout,
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 1.2,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
