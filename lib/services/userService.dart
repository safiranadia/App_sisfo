import 'package:app_sisfo/models/borrowModel.dart';
import 'package:app_sisfo/models/itemModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_sisfo/repositories/token_repository.dart';

class UserService {
  static const String _baseUrl = 'http://192.168.1.5:8000/api';
  final TokenRepository _tokenRepo = TokenRepository();

  Future<List<Borrow>> getBorrow() async {
    try {
      final token = await _tokenRepo.getToken();
      if (token == null) return [];

      final userId = await _tokenRepo.getUserId();
      final response = await http.get(
        Uri.parse('$_baseUrl/borrows/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        return data.map((e) => Borrow.fromMap(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getReturn() async {
    try {
      final token = await _tokenRepo.getToken();
      if (token == null) {
        return {'error': 'Not authenticated'};
      }

      final userId = await _tokenRepo.getUserId();
      final response = await http.get(
        Uri.parse('$_baseUrl/returns/$userId'),
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

  Future<List<ItemModel>> getItems() async {
    try {
      final token = await _tokenRepo.getToken();
      if (token == null) {
        return [];
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/items'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'];
        return data.map((e) => ItemModel.fromMap(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
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

  Future<Map<String, dynamic>> getReturnCount() async {
    try {
      final token = await _tokenRepo.getToken();
      if (token == null) return {'error': 'Not authenticated'};

      final userId = await _tokenRepo.getUserId();

      final response = await http.get(
        Uri.parse('$_baseUrl/returnCount/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Gagal mengambil data (${response.statusCode})'};
      }
    } catch (e) {
      return {'error': 'Terjadi kesalahan: $e'};
    }
  }

  Future<Map<String, dynamic>> getBorrowCount() async {
    try {
      final token = await _tokenRepo.getToken();
      if (token == null) return {'error': 'Not authenticated'};

      final userId = await _tokenRepo.getUserId();

      final response = await http.get(
        Uri.parse('$_baseUrl/borrowCount/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Gagal mengambil data (${response.statusCode})'};
      }
    } catch (e) {
      return {'error': 'Terjadi kesalahan: $e'};
    }
  }
}
