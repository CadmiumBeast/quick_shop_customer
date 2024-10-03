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
  late TextEditingController _quantityController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _quantityController =
        TextEditingController(text: widget.product.quantity.toString());
  }

  // Method to update the cart item
  void _updateCart() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final quantity = int.tryParse(_quantityController.text);
      if (quantity == null || quantity <= 0) {
        throw Exception('Please enter a valid quantity');
      }

      await _apiService.updateCartItem(widget.product.cartItemId, quantity);

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
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
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
                    child:
                        CircularProgressIndicator()) // Show loader while updating
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
