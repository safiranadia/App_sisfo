import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_sisfo/repositories/token_repository.dart';
import 'package:app_sisfo/models/userModel.dart';

class UserService {
  static const String _baseUrl = 'http://192.168.1.10:8000/api';
  final TokenRepository _tokenRepo = TokenRepository();

  Future<Map<String, dynamic>> getBorrow() async {
    try {
      final token = await _tokenRepo.getToken();
      if (token == null) {
        return {'error': 'Not authenticated'};
      }

      final userId = await _tokenRepo.getUserId();
      final response = await http.get(
        Uri.parse('$_baseUrl/borrows/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Failed to fetch data (${response.statusCode})',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {'error': 'Request failed: $e'};
    }
  }

  Future<Map<String, dynamic>> getItems() async {
    try {
      final token = await _tokenRepo.getToken();
      if (token == null) {
        return {'error': 'Not authenticated'};
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/items'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Failed to fetch data (${response.statusCode})',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {'error': 'Request failed: $e'};
    }
  }

  Future<Map<String, dynamic>> submitBorrow(Map<String, dynamic> data) async {
    try {
      final token = await _tokenRepo.getToken();
      if (token == null) return {'error': 'Not authenticated'};

      final url = Uri.parse('$_baseUrl/borrows');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Gagal menyimpan data (${response.statusCode})'};
      }
    } catch (e) {
      return {'error': 'Terjadi kesalahan: $e'};
    }
  }

  Future<Map<String, dynamic>> submitReturn(Map<String, dynamic> data) async {
    try {
      final token = await _tokenRepo.getToken();
      if (token == null) return {'error': 'Not authenticated'};

      final url = Uri.parse('$_baseUrl/returns');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Gagal menyimpan data (${response.statusCode})'};
      }
    } catch (e) {
      return {'error': 'Terjadi kesalahan: $e'};
    }
  }
}
