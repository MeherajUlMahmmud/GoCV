import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  // Future<Map<String, dynamic>> sendAuthRequest() async {}

  // Future<Map<String, dynamic>> sendAuthorizedAuthRequest() async {}

  Future<Map<String, dynamic>> sendGetRequest(
      String accessToken, String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    return {
      'data': jsonDecode(response.body),
      'status': response.statusCode,
    };
  }

  Future<Map<String, dynamic>> sendPostRequest(
    String accessToken,
    Map<String, dynamic> data,
    String url,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );
      return {
        'data': jsonDecode(response.body),
        'status': response.statusCode,
      };
    } catch (e) {
      print(e.toString());
      return {
        'error': e.toString(),
        'status': 500,
      };
    }
  }

  Future<Map<String, dynamic>> sendPatchRequest(
    String accessToken,
    Map<String, dynamic> data,
    String url,
  ) async {
    print(data);
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );
      return {
        'data': jsonDecode(response.body),
        'status': response.statusCode,
      };
    } catch (e) {
      print(e.toString());
      return {
        'error': e.toString(),
        'status': 500,
      };
    }
  }

  Future<Map<String, dynamic>> sendDeleteRequest(
    String accessToken,
    String url,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      return {
        'status': response.statusCode,
      };
    } catch (e) {
      print(e.toString());
      return {
        'error': e.toString(),
        'status': 500,
      };
    }
  }
}
