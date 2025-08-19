import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_year_project_web_app/model/batch.dart';

/// Service for handling manufacturing-related API calls.
/// Provides methods to fetch batches by company and add new batches.
class ManufacturingService {
  final String baseUrl = 'http://localhost:8083/manufacturing';

  Future<List<Batch>> fetchBatchesByCompanyId(int companyId) async {
    final url = Uri.parse('$baseUrl/company/$companyId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      return decoded.map((json) => Batch.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch batches: ${response.reasonPhrase}');
    }
  }

  Future<Batch> addBatch(Batch batch, int companyId) async {
    final url = Uri.parse(baseUrl);
    final Map<String, dynamic> batchData = batch.toJson();
    batchData['companyId'] = companyId;
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(batchData),
    );

    if (response.statusCode == 201) {
      return Batch.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add batch: ${response.body}');
    }
  }
}
