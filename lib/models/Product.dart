class Product {
  final int id;
  final String name;
  final String color;
  final String size;
  final double price;
  final int stock;
  final int quantity;
  final String description; // Changed to String for text description
  final String image; // Changed to String to store the image URL
  final int cartItemId; // Field to store the cart item ID

  Product({
    required this.id,
    required this.name,
    required this.color,
    required this.size,
    required this.price,
    required this.stock,
    required this.quantity,
    required this.description,
    required this.image,
    required this.cartItemId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0, // Default to 0 if id is null
      name: json['name'] ?? 'Unknown', // Provide a default value for name
      color: json['color'] ?? 'N/A', // Default color
      size: json['size'] ?? 'N/A', // Default size
      price: double.tryParse(json['price'].toString()) ??
          0.0, // Default to 0.0 if parsing fails
      stock: json['stock'] ?? 0, // Default stock to 0
      quantity: json['quantity'] ?? 1, // Default quantity to 1
      description:
          json['description'] ?? 'No description', // Default description text
      image: json['image'] ??
          'https://example.com/default_image.png', // Default image URL
      cartItemId: json['cart_item_id'] ?? 0, // Default cart item ID to 0
    );
  }
}
