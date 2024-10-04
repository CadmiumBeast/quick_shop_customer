import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import the carousel slider package
import '../models/Product.dart';
import '../services/api_service.dart';
import 'add_to_cart_screen.dart'; // Import the AddToCartScreen

class HomeScreen extends StatefulWidget {
  final String token; // User's authentication token

  HomeScreen({required this.token});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Product>> _tshirtFuture;
  TextEditingController _searchController =
      TextEditingController(); // Controller for search bar
  List<Product> _filteredProducts = []; // Store filtered products

  @override
  void initState() {
    super.initState();
    _tshirtFuture = _apiService.fetchTshirts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Product>>(
        future: _tshirtFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No T-Shirts available'));
          } else {
            final products = snapshot.data!;
            _filteredProducts = products; // Initialize filtered products

            return Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search,
                            color: const Color.fromARGB(255, 26, 0, 71)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15.0),
                      ),
                      onChanged: (value) {
                        // Update filtered products based on search input
                        setState(() {
                          _filteredProducts = products
                              .where((product) => product.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                ),

                // Carousel Slider
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1.0,
                  ),
                  items: products.map((product) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors
                                .grey[300], // Placeholder background color
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Display image from the product
                              Image.network(
                                product.image,
                                fit: BoxFit.cover,
                                height: 120.0, // Adjust height as needed
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.image,
                                      size: 120,
                                      color: Colors
                                          .grey); // Fallback if image fails to load
                                },
                              ),
                              SizedBox(height: 10),
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),

                // Product Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to AddToCartScreen and pass the selected product and token
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddToCartScreen(
                                product: product,
                                token: widget.token,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image section
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey[300],
                                    ),
                                    child: Image.network(
                                      product.image,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.image,
                                            size: 120,
                                            color:
                                                Colors.grey); // Fallback image
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Color: ${product.color} | Size: ${product.size}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
