import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_year_project_web_app/model/user.dart';

/// Service for handling authentication and related API calls.
class AuthService {
  final String baseUrl = 'http://localhost:8080';
  final String baseUrl2 = 'http://localhost:8081';

  /// Manufacturer Login
  Future<User> manufacturerLogin(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/manufacturer/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  /// Manufacturer Registration
  Future<User> manufacturerRegister(
    String username,
    String email,
    String password,
    String role,
    String company,
  ) async {
    final url = Uri.parse('$baseUrl/auth/manufacturer/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
        'role': role,
        'company': company,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  /// Get Roles from the backend
  Future<List<String>> getRoles() async {
    final url = Uri.parse('$baseUrl/auth/roles');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['roles']);
    } else {
      throw Exception('Failed to fetch roles: ${response.body}');
    }
  }

  /// Get Companies from the backend
  Future<List<String>> getCompanies() async {
    final url = Uri.parse('$baseUrl2/companies/names');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to fetch companies: ${response.body}');
    }
  }
}
