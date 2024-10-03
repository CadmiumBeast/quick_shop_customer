// models/cart_item.dart
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
}
