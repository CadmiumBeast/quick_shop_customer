import 'package:flutter/material.dart';
import '../models/Product.dart';
import '../services/api_service.dart';
import '../services/stripe_service.dart';
import 'update_cart_screen.dart';

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
    _fetchCartItems();
  }

  void _fetchCartItems() async {
    try {
      final cartItems = await _apiService.viewCart();
      setState(() {
        _cartItems = cartItems.map((item) {
          final tshirt = item['tshirt'];
          return Product(
            id: tshirt['id'],
            name: tshirt['name'],
            color: tshirt['color'],
            size: tshirt['size'],
            price: double.parse(tshirt['price']),
            stock: tshirt['stock'],
            quantity: item['quantity'],
            description: tshirt['description'],
            image: tshirt['image'],
            cartItemId: item['id'],
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _removeCartItem(int cartItemId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService.removeFromCart(cartItemId);
      _fetchCartItems();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToUpdateCart(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateCartScreen(product: product),
      ),
    ).then((value) {
      _fetchCartItems();
    });
  }

  void _purchaseItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool paymentSuccess = await StripeService.instance.makePayment();

      if (paymentSuccess) {
        await _apiService.purchaseCart();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase successful!')),
        );

        _fetchCartItems();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed or canceled')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase failed: $_errorMessage')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : _cartItems.isEmpty
                  ? Center(child: Text('Your cart is empty!'))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        bool isWideScreen = constraints.maxWidth > 600;

                        return Column(
                          children: [
                            Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isWideScreen ? 2 : 1,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1.5,
                                ),
                                itemCount: _cartItems.length,
                                itemBuilder: (context, index) {
                                  final product = _cartItems[index];
                                  return Card(
                                    margin: EdgeInsets.all(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 250,
                                            height: 250,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey[200],
                                            ),
                                            child: Image.network(
                                              product.image,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Icon(Icons.image,
                                                    size: 60,
                                                    color: Colors.grey);
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  product.name,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  'Color: ${product.color}',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  'Price: \$${product.price.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  'Quantity: ${product.quantity}',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton.icon(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shadowColor:
                                                            Colors.transparent,
                                                      ),
                                                      onPressed: () =>
                                                          _navigateToUpdateCart(
                                                              product),
                                                      icon: Icon(
                                                        Icons.edit,
                                                        color: Colors.blue,
                                                      ),
                                                      label: Text(
                                                        'Update',
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    ElevatedButton.icon(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shadowColor:
                                                            Colors.transparent,
                                                      ),
                                                      onPressed: () {
                                                        _removeCartItem(
                                                            product.cartItemId);
                                                      },
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                      label: Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .green, // Change to your desired color
                                  ),
                                  onPressed: _cartItems.isEmpty
                                      ? null
                                      : _purchaseItems,
                                  icon: Icon(
                                      Icons.shopping_cart), // Add icon here
                                  label: Text('Purchase'),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
    );
  }
}
