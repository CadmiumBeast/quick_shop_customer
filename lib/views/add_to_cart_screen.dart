// Import required packages
import 'package:flutter/material.dart';
import '../models/Product.dart';
import '../services/api_service.dart';

class AddToCartScreen extends StatefulWidget {
  final Product product;
  final String token; // User's authentication token

  AddToCartScreen({required this.product, required this.token});

  @override
  _AddToCartScreenState createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  final ApiService _apiService = ApiService();
  int _quantity = 1; // Default quantity
  bool _isLoading = false; // Loading state for API call
  int _maxQuantity = 10; // Assume maximum quantity limit for this example

  // Method to add product to cart
  void _addToCart() async {
    if (_quantity > _maxQuantity) {
      // Show error if the quantity exceeds the stock limit
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quantity exceeds available stock!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loader during the API call
    });

    try {
      // Call the API service to add the product to the cart
      await _apiService.addToCart(widget.product.id, _quantity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to cart successfully!'),
          backgroundColor: Colors.green, // Success color
        ),
      );
      Navigator.pop(context); // Navigate back after adding to cart
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart: $e'),
          backgroundColor: Colors.red, // Failure color
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loader after the API call
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access current theme (light or dark)
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add to Cart'),
      ),
      body: SingleChildScrollView(
        // Make the body scrollable
        child: Center(
          child: Padding(
            padding: isPortrait
                ? const EdgeInsets.all(16.0) // Padding for portrait mode
                : const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0), // Closer together in landscape mode
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product Image
                Container(
                  width: isPortrait
                      ? 200
                      : 150, // Adjust width based on orientation
                  height: isPortrait
                      ? 200
                      : 150, // Adjust height based on orientation
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Image.network(
                    widget.product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.grey, // Placeholder icon for error
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Product Name
                Text(
                  widget.product.name,
                  style: TextStyle(
                    fontSize: isPortrait
                        ? 22
                        : 18, // Adjust font size for orientation
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color, // Adapt to theme
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                // Product Color and Size
                Text(
                  'Color: ${widget.product.color} | Size: ${widget.product.size}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color, // Adapt to theme
                  ),
                ),
                SizedBox(height: 20),

                // Price and Quantity Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Price: \$${widget.product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            theme.textTheme.bodyLarge?.color, // Adapt to theme
                      ),
                    ),
                    SizedBox(width: 16),

                    // Quantity Selector
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            if (_quantity > 1) {
                              setState(() {
                                _quantity--;
                              });
                            }
                          },
                        ),
                        Text(
                          '$_quantity',
                          style: TextStyle(
                            fontSize: 18,
                            color: theme
                                .textTheme.bodyLarge?.color, // Adapt to theme
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            if (_quantity < _maxQuantity) {
                              setState(() {
                                _quantity++;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Add to Cart Button
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isLoading
                        ? Center(
                            child:
                                CircularProgressIndicator(), // Show loader during the API call
                          )
                        : ElevatedButton.icon(
                            onPressed: _addToCart,
                            icon: Icon(Icons.add_shopping_cart),
                            label: Text('Add to Cart'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.green, // Custom button color
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
