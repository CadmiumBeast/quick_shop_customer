import 'package:flutter/material.dart';
import 'package:quick_shop_customer/views/order_screen.dart';
import 'package:quick_shop_customer/widget/topwaveclipper.dart';
import 'cart_screen.dart';
import 'products_screen.dart';
import 'profile_screen.dart';
import 'customer_support_screen.dart';// Import the wave clipper

class nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<nav> {
  int _selectedIndex = 0;

  // Screens list with token passed to HomeScreen
  static List<Widget> _screens = <Widget>[
    HomeScreen(token: ''),
    OrderScreen(),
    CartScreen(),
    CustomerSupportScreen(),
    ProfilePage(profileImage: null, onImagePicked: (File ) {  },),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RetailFusion'),
        backgroundColor: Colors.yellow, // Change app bar color
      ),
      body: Stack(
        children: [
          // Add the wave design
          ClipPath(
            clipper: TopWaveClipper(),
            child: Container(
              height: 30.0, // Adjust height to make the wave more prominent
              decoration: BoxDecoration(
                color: Colors.yellow, // Wave color
              ),
            ),
          ),
          // Content of the selected page
          Padding(
            padding: const EdgeInsets.only(top: 30.0), // Adjust padding to start content below the wave
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.yellow,
        items:const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('asset/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('asset/to-do-list.png')),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('asset/grocery-store.png')),
            label: 'Profile',
          ),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('asset/headphones.png')),
            label: 'Support',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey, // Change unselected item color
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
