import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class APIService {
  // Future<Map<String, dynamic>> sendAuthRequest() async {}

  // Future<Map<String, dynamic>> sendAuthorizedAuthRequest() async {}

  Future<Map<String, dynamic>> sendGetRequest(
      String accessToken, String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
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

  // Future<Map<String, dynamic>> sendPostRequest() async {}

  Future<Map<String, dynamic>> sendPatchRequest(
    String accessToken,
    Map<String, dynamic> data,
    String url,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'data': data,
          'status': response.statusCode,
        };
      } else {
        final data = jsonDecode(response.body);
        print(data);
        return {
          'error': data['detail'] ?? 'Something went wrong',
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

  // Future<Map<String, dynamic>> sendDeleteRequest() async {}
}
