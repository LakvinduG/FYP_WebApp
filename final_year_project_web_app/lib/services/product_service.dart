import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_year_project_web_app/model/product.dart';

/// Service for handling product-related API calls.
/// Provides methods to fetch products by company and add new products.
class ProductService {
  final String baseUrl = 'http://localhost:8082';

  Future<List<Product>> fetchProductsByCompanyId(int companyId) async {
    final response = await http.get(Uri.parse('$baseUrl/products/companies/$companyId'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products: ${response.reasonPhrase}');
    }
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(productData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add product: ${response.reasonPhrase}');
    }
  }
}
