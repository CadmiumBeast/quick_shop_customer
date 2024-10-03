import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/api_service.dart';
import '../models/Product.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Product>> _tshirtFuture;

  @override
  void initState() {
    super.initState();
    _tshirtFuture = _apiService.fetchTshirts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('T-Shirt Listings'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _tshirtFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while fetching data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle any errors
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle the case when no data is available
            return Center(child: Text('No T-Shirts available'));
          } else {
            // Display the list of T-shirts in cards
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: FaIcon(FontAwesomeIcons.tshirt),
                    title: Text(product.name),
                    subtitle:
                        Text('Color: ${product.color} | Size: ${product.size}'),
                    trailing: Text('\$${product.price.toStringAsFixed(2)}'),
                    onTap: () {
                      // Handle card tap (optional, e.g., navigate to details)
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
