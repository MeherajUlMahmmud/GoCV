import 'dart:convert';

import 'package:cv_builder/utils/urls.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      print(URLS.kLoginUrl);
      final response = await http.post(
        Uri.parse(URLS.kLoginUrl),
        body: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'data': data,
          'status': response.statusCode,
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'error': data['detail'],
          'status': response.statusCode,
        };
      }
    } catch (e) {
      print(e.toString());
      return {
        'error': e.toString(),
        'status': 500,
      };
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse(URLS.kRefreshTokenUrl),
        body: {
          'refresh': refreshToken,
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'data': data,
          'status': response.statusCode,
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'error': data['detail'],
          'status': response.statusCode,
        };
      }
    } catch (e) {
      print(e.toString());
      return {
        'error': e.toString(),
        'status': 500,
      };
    }
  }
}
