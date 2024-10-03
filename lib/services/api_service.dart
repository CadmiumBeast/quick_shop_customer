import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Product.dart';

class ApiService {
  final String baseUrl = 'http://192.168.8.169:8000/api';

  // Helper function to get the token from SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Registration API
  Future<void> register(String name, String email, String password,
      String passwordConfirmation) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 201) {
        print('Registration successful');
      } else {
        final responseData = json.decode(response.body);
        throw Exception(responseData['message'] ?? 'Failed to register');
      }
    } catch (e) {
      print('Error registering: $e');
      throw Exception('Registration error: $e');
    }
  }

  // Login API
  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      } else {
        final responseData = json.decode(response.body);
        throw Exception(responseData['message'] ?? 'Failed to log in');
      }
    } catch (e) {
      print('Error logging in: $e');
      throw Exception('Login error: $e');
    }
  }

  // Logout API
  Future<void> logout() async {
    try {
      final token = await getToken();

      if (token != null) {
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
      }
    } catch (e) {
      print('Error logging out: $e');
      throw Exception('Logout error: $e');
    }
  }

  // Fetch Profile API
  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final token = await getToken();

      if (token == null) throw Exception('User is not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      throw Exception('Profile fetch error: $e');
    }
  }

  // Update Profile API
  Future<void> updateProfile(String name, String email) async {
    try {
      final token = await getToken();

      if (token == null) throw Exception('User is not authenticated');

      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Profile update error: $e');
    }
  }

  // Fetch T-shirts API (requires authentication)
  Future<List<Product>> fetchTshirts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('User is not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/tshirts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Make sure token is valid and sent
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((tshirt) => Product.fromJson(tshirt)).toList();
    } else {
      print('Error: ${response.body}');
      throw Exception('Failed to load t-shirts');
    }
  }

  // Add T-shirt to cart
  Future<void> addToCart(int tshirtId, int quantity) async {
    final token = await getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/cart/add/$tshirtId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'quantity': quantity}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add to cart');
    }
  }

  // View Cart
  Future<List<dynamic>> viewCart() async {
    final token = await getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await http.get(
      Uri.parse('$baseUrl/cart'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load cart');
    }
  }

  // Remove an item from the cart
  Future<void> removeFromCart(int cartItemId) async {
    final token = await getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await http.delete(
      Uri.parse('$baseUrl/cart/item/$cartItemId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove item from cart');
    }
  }

  // Update cart item quantity
  Future<void> updateCartItem(int cartItemId, int quantity) async {
    final token = await getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await http.put(
      Uri.parse('$baseUrl/cart/item/$cartItemId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'quantity': quantity}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update cart item');
    }
  }

  // Clear the cart
  Future<void> clearCart() async {
    final token = await getToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await http.delete(
      Uri.parse('$baseUrl/cart/clear'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to clear cart');
    }
  }
}
