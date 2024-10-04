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

  void _addToCart() async {
    setState(() {
      _isLoading = true; // Show loader during the API call
    });

    try {
      // Call the API service to add the product to the cart
      await _apiService.addToCart(widget.product.id, _quantity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to cart successfully!')),
      );
      Navigator.pop(context); // Navigate back after adding to cart
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loader after the API call
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the orientation
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add to Cart'),
      ),
      body: Center(
        // Center the entire body content
        child: Padding(
          padding: isPortrait
              ? const EdgeInsets.all(16.0) // Padding for portrait mode
              : const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0), // Closer together in landscape
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center items vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center items horizontally
            children: [
              // Display the product image
              Container(
                width: 200,
                height: 200,
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
              SizedBox(height: 20), // Fixed spacing for both orientations

              // Display product name
              Text(
                widget.product.name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Center the text
              ),
              SizedBox(height: 10), // Fixed spacing for both orientations

              // Display product color and size
              Text(
                'Color: ${widget.product.color} | Size: ${widget.product.size}',
                textAlign: TextAlign.center, // Center the text
              ),
              SizedBox(height: 20), // Fixed spacing for both orientations

              // Row for price and quantity selector
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the row contents
                children: [
                  Text(
                    'Price: \$${widget.product.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 16), // Space between price and quantity
                  // Quantity selector
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
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),

              // Spacer for flexible spacing
              SizedBox(height: 20), // Fixed space before the button

              // Add to cart button
              Row(
                mainAxisSize:
                    MainAxisSize.min, // Make the row take minimum width
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the button in the row
                children: [
                  _isLoading
                      ? Center(
                          child:
                              CircularProgressIndicator(), // Show loader when API is being called
                        )
                      : ElevatedButton(
                          onPressed: _addToCart,
                          child: Text('Add to Cart'),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
