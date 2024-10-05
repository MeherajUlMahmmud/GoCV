import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  Map<String, String> _buildHeaders(String accessToken,
      {bool isMultipart = false}) {
    return {
      'Content-Type': isMultipart ? 'multipart/form-data' : 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }

  Future<Map<String, dynamic>> sendGetRequest(
      String accessToken, String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: _buildHeaders(accessToken),
      );
      return {
        'data': jsonDecode(response.body),
        'status': response.statusCode,
      };
    } catch (e) {
      print('Error in GET request: $e');
      return {
        'error': e.toString(),
        'status': 500,
      };
    }
  }

  Future<Map<String, dynamic>> sendPostRequest(
    String accessToken,
    Map<String, dynamic> data,
    String url,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: _buildHeaders(accessToken),
        body: jsonEncode(data),
      );
      return {
        'data': jsonDecode(response.body),
        'status': response.statusCode,
      };
    } catch (e) {
      print('Error in POST request: $e');
      return {
        'error': e.toString(),
        'status': 500,
      };
    }
  }

  Future<Map<String, dynamic>> sendPatchRequest(
    String accessToken,
    Map<String, dynamic> data,
    String url, {
    bool isMultipart = false,
  }) async {
    try {
      if (!isMultipart) {
        final response = await http.patch(
          Uri.parse(url),
          headers: _buildHeaders(accessToken),
          body: jsonEncode(data),
        );
        return {
          'data': jsonDecode(response.body),
          'status': response.statusCode,
        };
      } else {
        final request = http.MultipartRequest(
          'PATCH',
          Uri.parse(url),
        )
          ..headers.addAll(_buildHeaders(accessToken, isMultipart: true))
          ..files.add(
            http.MultipartFile.fromBytes(
              'resume_picture', // This is the key for the file
              data['resume_picture'].readAsBytesSync(), // This is the file
              filename: data['resume_picture']
                  .path
                  .split('/')
                  .last, // This is the file name
            ),
          );

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        return {
          'data': jsonDecode(responseBody),
          'status': response.statusCode,
        };
      }
    } catch (e) {
      print('Error in PATCH request: $e');
      return {
        'error': e.toString(),
        'status': 500,
      };
    }
  }

  Future<Map<String, dynamic>> sendDeleteRequest(
      String accessToken, String url) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: _buildHeaders(accessToken),
      );
      return {
        'status': response.statusCode,
      };
    } catch (e) {
      print('Error in DELETE request: $e');
      return {
        'error': e.toString(),
        'status': 500,
      };
    }
  }
}
