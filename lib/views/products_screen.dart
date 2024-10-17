import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/Product.dart';
import '../services/api_service.dart';
import 'add_to_cart_screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  HomeScreen({required this.token});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Product>> _tshirtFuture;
  TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _tshirtFuture = _apiService.fetchTshirts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

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
            _filteredProducts = products;

            return OrientationBuilder(
              builder: (context, orientation) {
                return orientation == Orientation.portrait
                    ? _buildPortraitLayout(products, isDarkMode)
                    : _buildLandscapeLayout(products, isDarkMode);
              },
            );
          }
        },
      ),
    );
  }

  // Portrait Layout
  Widget _buildPortraitLayout(List<Product> products, bool isDarkMode) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: _buildProductList(isDarkMode),
        ),
      ],
    );
  }

  // Landscape Layout
  Widget _buildLandscapeLayout(List<Product> products, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(26.0, 44.0, 16.0, 16.0),
                child: _buildSearchBar(products),
              ),
              SizedBox(height: 16.0),
              CarouselSlider(
                options: CarouselOptions(
                  height: 150.0, // Set a shorter height for landscape mode
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                ),
                items: _buildCarouselItems(products, isDarkMode),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: _buildProductList(isDarkMode),
        ),
      ],
    );
  }

  // Search Bar Widget
  Widget _buildSearchBar(List<Product> products) {
    return Container(
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .cardColor,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Reduced shadow intensity for modern look
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: TextStyle(color: Theme
              .of(context)
              .hintColor),
          prefixIcon: Icon(Icons.search, color: Theme
              .of(context)
              .primaryColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15.0),
        ),
        onChanged: (value) {
          setState(() {
            _filteredProducts = products
                .where((product) =>
                product.name.toLowerCase().contains(value.toLowerCase()))
                .toList();
          });
        },
      ),
    );
  }

  // Build Carousel Items
  List<Widget> _buildCarouselItems(List<Product> products, bool isDarkMode) {
    final theme = Theme.of(context);
    return products.map((product) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: isDarkMode ? Colors.grey[800] : Colors
                  .grey[200], // Updated colors
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  product.image,
                  fit: BoxFit.cover,
                  height: 100.0,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image, size: 100, color: Colors.grey);
                  },
                ),
                SizedBox(height: 10),
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 18, // Adjusted text size for better balance
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }).toList();
  }

  // Build Product Grid
  Widget _buildProductList(bool isDarkMode) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddToCartScreen(product: product, token: widget.token),
              ),
            );
          },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(
                color: Colors.grey, // Border color
                width: 1.0, // Border thickness
              ),
            ),
            color: Colors.transparent, // Transparent background
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    // Adjust the width for the image
                    height: 100,
                    // Adjust the height for the image
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    ),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image, size: 60, color: Colors.grey);
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Color: ${product.color} | Size: ${product.size}',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

