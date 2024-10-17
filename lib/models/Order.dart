import 'package:flutter/material.dart';

class Orders{
  final String id;
  final String name;
  final String image;
  final int quantity;
  final double price;

  Orders({
    required this.id,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
  });

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  // make few orders

  static List<Orders> orders = [
    Orders(
      id: '1',
      name: 'Product 1',
      image: 'https://th.bing.com/th/id/R.2af21f9c444c81c77a0f3e2adf4f3d05?rik=qLyoZeqfScELZA&riu=http%3a%2f%2fwww.tshirtloot.com%2fwp-content%2fuploads%2f2016%2f02%2f2-b-1024x1024.png&ehk=IF5ooJi73XLlZbwe1s1YIVaKi0JRcBxQMedRjAtdLAM%3d&risl=&pid=ImgRaw&r=0',
      quantity: 2,
      price: 100.0,
    ),
    Orders(
      id: '2',
      name: 'Product 2',
      image: 'https://static.vecteezy.com/system/resources/previews/013/775/383/original/purple-t-shirt-with-hanger-png.png',
      quantity: 1,
      price: 50.0,
    ),
    Orders(
      id: '3',
      name: 'Product 3',
      image: 'https://pluspng.com/img-png/tshirt-png-red-t-shirt-png-transparent-image-1200.png',
      quantity: 3,
      price: 150.0,
    ),
  ];
}