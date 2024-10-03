class CartItem {
  final String id; 
  final String name; 
  final String color; 
  final String size; 
  final double price; 
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.color,
    required this.size,
    required this.price,
    this.quantity = 1,
  });

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
