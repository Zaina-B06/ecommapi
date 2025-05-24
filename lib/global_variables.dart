import 'package:http/http.dart' as http;
import 'dart:convert';

// Optionally keep your hardcoded products as fallback (you can remove later)
const List<Map<String, dynamic>> localProducts = [
  {
    'id': '0',
    'title': 'Nike Air Jordan 1',
    'price': 100.35,
    'sizes': [8.0, 8.5, 9.0, 9.5, 10.0, 10.5, 11.0, 11.5],
    'company': 'Nike',
    'imageUrl': 'assets/images/shoes11.png',
  },
  // ... keep your other products if you want
];

class ProductService {
  static const String baseUrl = 'https://fakestoreapi.com';

  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      
      if (response.statusCode == 200) {
        final List<dynamic> apiProducts = jsonDecode(response.body);
        
        // Transform API products to match your existing structure
        return apiProducts.map((apiProduct) {
          return {
            'id': apiProduct['id'].toString(),
            'title': apiProduct['title'],
            'price': apiProduct['price'].toDouble(),
            'sizes': [8.0, 8.5, 9.0, 9.5, 10.0, 10.5, 11.0, 11.5], // Keeping your size options
            'company': _mapCategoryToBrand(apiProduct['category']), // Map API category to your brands
            'imageUrl': apiProduct['image'],
          };
        }).toList();
      } else {
        // Fallback to local products if API fails
        return localProducts;
      }
    } catch (e) {
      // Fallback to local products if there's an error
      return localProducts;
    }
  }

  // Helper to map API categories to your brands
  static String _mapCategoryToBrand(String category) {
    switch (category) {
      case "men's clothing":
        return "Nike";
      case "women's clothing":
        return "Adidas";
      case "electronics":
        return "Puma";
      case "jewelery":
        return "Reebok";
      default:
        return "Generic";
    }
  }
}