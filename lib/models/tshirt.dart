class Tshirt {
  final int id;
  final String name;
  final String color;
  final String size;
  final double price;
  final int stock;

  Tshirt({
    required this.id,
    required this.name,
    required this.color,
    required this.size,
    required this.price,
    required this.stock,
  });

  factory Tshirt.fromJson(Map<String, dynamic> json) {
    return Tshirt(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      size: json['size'],
      price: double.parse(json['price']), // Use double.parse() for price
      stock: json['stock'],
    );
  }
}
