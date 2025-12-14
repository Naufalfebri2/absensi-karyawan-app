import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<dynamic> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    final response = await http.get(Uri.parse(url), headers: headers);
    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Error ${response.statusCode}");
    }
  }
}
