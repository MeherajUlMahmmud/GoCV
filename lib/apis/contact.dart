import 'dart:convert';
import 'package:gocv/utils/urls.dart';
import 'package:http/http.dart' as http;

class ContactService {
  Future<Map<String, dynamic>> getContactDetails(
    String accessToken,
    String contactId,
  ) async {
    try {
      String url = "${URLS.kContactUrl}$contactId/";
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

  Future<Map<String, dynamic>> updateContactDetails(
    String accessToken,
    String contactId,
    String phoneNumber,
    String email,
    String address,
    String linkedin,
    String facebook,
    String github,
  ) async {
    try {
      String url = "${URLS.kContactUrl}$contactId/";
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'phone_number': phoneNumber,
          'email': email,
          'address': address,
          'linkedin': linkedin,
          'facebook': facebook,
          'github': github,
        }),
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
