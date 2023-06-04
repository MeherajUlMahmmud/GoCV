import 'dart:convert';
import 'package:gocv/utils/urls.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<Map<String, dynamic>> getUserDetails(
    String accessToken,
    String userId,
  ) async {
    try {
      String url = "${URLS.kUserUrl}$userId";
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

  Future<Map<String, dynamic>> updateApplicantDetails(
    String accessToken,
    String userId,
    String firstName,
    String lastName,
    String phone,
  ) async {
    try {
      String url = "${URLS.kApplicantUrl}$userId/";
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'phone_number': phone,
        }),
      );
      print(response.body);
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
