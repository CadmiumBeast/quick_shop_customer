import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'products_screen.dart';
import 'profile_screen.dart';
import 'customer_support_screen.dart';

class nav extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<nav> {
  int _selectedIndex = 0;

  static List<Widget> _screens = <Widget>[
    HomeScreen(
      token: '',
    ),
    CartScreen(),
    CustomerSupportScreen(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_checkout),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Support',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: isDarkMode
            ? Colors.white
            : Colors.black, // Change unselected item color
        selectedItemColor:
            Colors.blue, // You can also make this color dynamic if needed
        onTap: _onItemTapped,
      ),
    );
  }
}
