import 'package:flutter/material.dart';
import '../models/Order.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders', style: TextStyle(color: Colors.yellow)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: Orders.orders.length,
          itemBuilder: (context, index) {
            final order = Orders.orders[index];
            return Container(
              margin: EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[900], // Dark card color
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.yellow),
                  ],
                ),
                title: Text(
                  'Order #${order.id}',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  children: [
                    Icon(Icons.local_shipping, color: Colors.yellow),
                    SizedBox(width: 8.0),
                    Text(
                      'Quantity: ${order.quantity}',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                trailing: Text(
                  '\$${order.price}',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
