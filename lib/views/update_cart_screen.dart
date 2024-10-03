import 'package:flutter/material.dart';
import '../models/Product.dart';
import '../services/api_service.dart';

class UpdateCartScreen extends StatefulWidget {
  final Product product;

  UpdateCartScreen({required this.product});

  @override
  _UpdateCartScreenState createState() => _UpdateCartScreenState();
}

class _UpdateCartScreenState extends State<UpdateCartScreen> {
  final ApiService _apiService = ApiService();
  int _quantity = 1; // Initialize quantity to 1
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _quantity = widget.product.quantity; // Set initial quantity from product
  }

  // Method to update the cart item
  void _updateCart() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_quantity <= 0) {
        throw Exception('Please enter a valid quantity');
      }

      await _apiService.updateCartItem(widget.product.cartItemId, _quantity);
      Navigator.pop(context); // Return to the previous screen after updating
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString(); // Display error message if failed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product: ${widget.product.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Price: \$${widget.product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Color: ${widget.product.color}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Using a Stepper for quantity selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantity: $_quantity', style: TextStyle(fontSize: 18)),
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
            SizedBox(height: 20),
            _errorMessage != null
                ? Text(
                    'Error: $_errorMessage',
                    style: TextStyle(color: Colors.red),
                  )
                : SizedBox(),
            SizedBox(height: 20),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  ) // Show loader while updating
                : ElevatedButton(
                    onPressed: _updateCart,
                    child: Text('Update Cart'),
                  ),
          ],
        ),
      ),
    );
  }
}
