class CartItem {
  final String id; // Unique identifier for the cart item
  final String name; // Product name
  final String color; // Product color
  final String size; // Product size
  final double price; // Product price
  int quantity; // Quantity of the product

  CartItem({
    required this.id,
    required this.name,
    required this.color,
    required this.size,
    required this.price,
    this.quantity = 1,
  });

  // Factory method to create a CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'].toString(),
      name: json['tshirt']['name'],
      color: json['tshirt']['color'],
      size: json['tshirt']['size'],
      price: json['tshirt']['price'].toDouble(),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'size': size,
      'price': price,
      'quantity': quantity,
    };
  }
}
