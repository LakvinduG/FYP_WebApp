import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/company.dart';

/// Service for fetching company data from the backend.
/// Handles API calls to retrieve company lists and full company details.
/// Attaches JWT tokens for secured endpoints when necessary.
class CompanyService {
  static const String baseUrl = 'http://localhost:8081/companies';

  Future<List<Company>> fetchAllCompanies() async {
    final token = await _getTokenFromPrefs();

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((jsonItem) => Company.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load companies (status: ${response.statusCode})');
    }
  }

  /// Fetch full company details by ID.
  Future<Company> fetchFullCompanyById(int companyId) async {
    final token = await _getTokenFromPrefs();

    final response = await http.get(
      Uri.parse('$baseUrl/$companyId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Company.fromJson(data);
    } else {
      throw Exception('Failed to load full company data (status: ${response.statusCode})');
    }
  }

  /// Helper method to retrieve the JWT token from shared preferences.
  Future<String?> _getTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
