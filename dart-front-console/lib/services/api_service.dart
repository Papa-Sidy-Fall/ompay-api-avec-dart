import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ApiService {
  final String baseUrl;
  String? _token;

  ApiService(this.baseUrl);

  // Setter pour le token
  void setToken(String token) {
    _token = token;
  }

  // Getter pour le token
  String? get token => _token;

  // Headers de base
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // Méthode GET
  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url, headers: _headers);

    return _handleResponse(response);
  }

  // Méthode POST
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  // Méthode PUT
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(
      url,
      headers: _headers,
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  // Méthode DELETE
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(url, headers: _headers);

    return _handleResponse(response);
  }

  // Gestion des réponses
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      if (body.isEmpty) {
        return {'success': true};
      }
      try {
        return jsonDecode(body);
      } catch (e) {
        throw Exception('Erreur de parsing JSON: $e');
      }
    } else {
      // Essayer de parser l'erreur
      try {
        final errorData = jsonDecode(body);
        throw Exception(errorData['message'] ?? 'Erreur HTTP $statusCode');
      } catch (e) {
        throw Exception('Erreur HTTP $statusCode: $body');
      }
    }
  }
}