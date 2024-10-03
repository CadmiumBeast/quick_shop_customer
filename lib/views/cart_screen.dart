import 'package:flutter/material.dart';
import '../models/Product.dart'; // Import your Product model
import '../services/api_service.dart';
import 'update_cart_screen.dart'; // Import the UpdateCartScreen

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _cartItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCartItems(); // Fetch cart items when the screen is initialized
  }

  // Method to fetch cart items
  void _fetchCartItems() async {
    try {
      final cartItems = await _apiService.viewCart();
      setState(() {
        _cartItems = cartItems.map((item) {
          final tshirt = item['tshirt']; // Access the 'tshirt' object
          return Product(
            id: tshirt['id'],
            name: tshirt['name'],
            color: tshirt['color'],
            size: tshirt['size'],
            price: double.parse(tshirt['price']),
            stock: tshirt['stock'],
            quantity: item['quantity'],
            cartItemId:
                item['id'], // Assuming your API returns the cart item ID
          );
        }).toList();
        _isLoading = false; // Stop loading after fetching items
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading in case of an error
        _errorMessage = e.toString(); // Set the error message
      });
    }
  }

  // Method to remove an item from the cart
  void _removeCartItem(int cartItemId) async {
    setState(() {
      _isLoading = true; // Show loading while the deletion is in progress
    });

    try {
      await _apiService
          .removeFromCart(cartItemId); // Call the API to remove item
      _fetchCartItems(); // Refresh the cart after the item is removed
    } catch (e) {
      setState(() {
        _errorMessage =
            e.toString(); // Show error message if something goes wrong
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop loading once the operation is done
      });
    }
  }

  void _navigateToUpdateCart(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateCartScreen(
            product: product), // Pass the product to UpdateCartScreen
      ),
    ).then((value) {
      // Refresh the cart items after returning from UpdateCartScreen
      _fetchCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator()) // Show loader while fetching
          : _errorMessage != null
              ? Center(
                  child: Text('Error: $_errorMessage')) // Show error message
              : _cartItems.isEmpty
                  ? Center(
                      child:
                          Text('Your cart is empty!')) // No items in the cart
                  : ListView.builder(
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final product = _cartItems[index];
                        return Card(
                          margin: EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Color: ${product.color}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Price: \$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Quantity: ${product.quantity}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          _navigateToUpdateCart(product),
                                      child: Text('Update'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _removeCartItem(product
                                            .cartItemId!); // Call delete function
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
