import 'dart:convert';
import 'package:cv_builder/utils/urls.dart';
import 'package:http/http.dart' as http;

class ResumeService {
  Future<Map<String, dynamic>> createResume(
      String accessToken, String userId, String name) async {
    try {
      String url = URLS.kResumeUrl;
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'user': userId,
          'name': name,
        }),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'data': data['data'],
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

  Future<Map<String, dynamic>> getResumeList(
      String accessToken, String userId) async {
    try {
      String url =
          "${URLS.kResumeUrl}?user=$userId&name=&created_at_0=&created_at_1=";
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
          'data': data['data'],
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

  Future<Map<String, dynamic>> getResumeDetails(
      String accessToken, String resumeId) async {
    try {
      String url = "${URLS.kResumeUrl}$resumeId/";
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
          'data': data['data'],
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
