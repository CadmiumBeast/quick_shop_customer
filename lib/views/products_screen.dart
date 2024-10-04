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
                    ? _buildPortraitLayout(products)
                    : _buildLandscapeLayout(products);
              },
            );
          }
        },
      ),
    );
  }

  // Portrait Layout
  Widget _buildPortraitLayout(List<Product> products) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(26.0, 44.0, 26.0, 16.0),
          child: _buildSearchBar(products),
        ),
        SizedBox(height: 16.0),
        CarouselSlider(
          options: CarouselOptions(
            height: 250.0,
            autoPlay: true,
            aspectRatio: 16 / 9,
            viewportFraction: 1.0,
          ),
          items: _buildCarouselItems(products),
        ),
        SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Products',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: _buildProductGrid(),
        ),
      ],
    );
  }

  // Landscape Layout
  Widget _buildLandscapeLayout(List<Product> products) {
    return Row(
      children: [
        Expanded(
          flex: 1, // Occupies the left side (Search and Carousel)
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(26.0, 44.0, 16.0, 16.0),
                child: _buildSearchBar(products),
              ),
              SizedBox(height: 16.0),
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                ),
                items: _buildCarouselItems(products),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2, // Occupies the right side (Product Grid)
          child: _buildProductGrid(),
        ),
      ],
    );
  }

  // Search Bar Widget
  Widget _buildSearchBar(List<Product> products) {
    return Container(
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
          prefixIcon:
              Icon(Icons.search, color: const Color.fromARGB(255, 26, 0, 71)),
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
  List<Widget> _buildCarouselItems(List<Product> products) {
    return products.map((product) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.grey[300],
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      );
    }).toList();
  }

  // Build Product Grid
  Widget _buildProductGrid() {
    return GridView.builder(
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddToCartScreen(product: product, token: widget.token),
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
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.image,
                              size: 120, color: Colors.grey);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Color: ${product.color} | Size: ${product.size}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
