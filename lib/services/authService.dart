import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_sisfo/repositories/token_repository.dart';

class AuthService {
  static const String _baseUrl = 'http://192.168.1.5:8000/api';
  final TokenRepository _tokenRepo = TokenRepository();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        body: {'email': email, 'password': password},
      );

      print("error nih: $response");
      print("error 2 nih: ${response.body}");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['token'] != null) {
        await _tokenRepo.saveToken(responseData['token']);
      }

      return responseData;
    } catch (e) {
      return {'error': 'Login failed: $e'};
    }
  }
}
