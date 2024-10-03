class Product {
  final int id;
  final String name;
  final String color;
  final String size;
  final double price;
  final int stock;
  final String? image; // Add an optional image property

  Product({
    required this.id,
    required this.name,
    required this.color,
    required this.size,
    required this.price,
    required this.stock,
    this.image, // Initialize image property
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      size: json['size'],
      price: double.parse(json['price'].toString()),
      stock: json['stock'],
      image: json['image'] != null ? json['image'] : null, // Handle null image
    );
  }
}
