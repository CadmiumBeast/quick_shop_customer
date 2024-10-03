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
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
                'Color: ${widget.product.color} | Size: ${widget.product.size}'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price: \$${widget.product.price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: _isLoading
                  ? Center(
                      child:
                          CircularProgressIndicator()) // Show loader when API is being called
                  : ElevatedButton(
                      onPressed: _addToCart,
                      child: Text('Add to Cart'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
