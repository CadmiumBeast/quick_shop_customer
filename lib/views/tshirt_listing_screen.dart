import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/tshirt.dart';  // Assuming you have a Tshirt model

class TshirtListingScreen extends StatefulWidget {
  @override
  _TshirtListingScreenState createState() => _TshirtListingScreenState();
}

class _TshirtListingScreenState extends State<TshirtListingScreen> {
  late Future<List<Tshirt>> futureTshirts;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureTshirts = apiService.fetchTshirts();  // Fetch t-shirts instead of products
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('T-Shirts'),
      ),
      body: FutureBuilder<List<Tshirt>>(
        future: futureTshirts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No t-shirts available'));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var tshirt = snapshot.data![index];
                return Card(
                  child: Column(
                    children: [
                      // If your API returns an image URL, show the t-shirt image
                      // Image.network(tshirt.imageUrl, fit: BoxFit.cover, height: 100),
                      Text(tshirt.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('\$${tshirt.price.toString()}'),
                      ElevatedButton(
                        onPressed: () {
                          apiService.addToCart(tshirt.id);  // Assuming addToCart works for t-shirts
                        },
                        child: Text('Add to Cart'),
                      ),
                    ],
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
