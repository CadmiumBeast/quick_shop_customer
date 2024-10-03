class Product {
  final int id;
  final String name;
  final String color;
  final String size;
  final double price;
  final int stock;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.color,
    required this.size,
    required this.price,
    required this.stock,
    required this.quantity,
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
    );
  }
}
