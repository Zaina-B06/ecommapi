import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  static Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<void> printProducts() async {
    try {
      final products = await fetchProducts();
      for (var product in products) {
        print('Product: ${product['title']}, Price: ${product['price']}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }
}