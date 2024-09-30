import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tshirt.dart';

class ApiService {
  final String baseUrl = 'http://192.168.8.169:8000/api';

  // Registration API
  Future<void> register(String name, String email, String password,
      String passwordConfirmation) async {
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
  }

  // Login API
  Future<void> login(String email, String password) async {
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
  }
  // Fetch Profile API
  Future<Map<String, dynamic>> fetchProfile() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

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
    }

    // Update Profile API
    Future<void> updateProfile(String name, String email) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

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
    }
  // Method to retrieve token from SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Logout API
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      await prefs.remove('token');
    }
  }

  // Fetch T-shirts API
  Future<List<Tshirt>> fetchTshirts() async {
    final response = await http.get(Uri.parse('$baseUrl/tshirts'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((tshirt) => Tshirt.fromJson(tshirt)).toList();
    } else {
      throw Exception('Failed to load t-shirts');
    }
  }

  // Add to Cart API
  Future<void> addToCart(int tshirtId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'product_id': tshirtId}),
    );

    if (response.statusCode == 200) {
      print('T-shirt added to cart successfully');
    } else {
      throw Exception('Failed to add t-shirt to cart');
    }
  }
 
}
