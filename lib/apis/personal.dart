import 'dart:convert';
import 'package:cv_builder/utils/urls.dart';
import 'package:http/http.dart' as http;

class PersonalService {
  Future<Map<String, dynamic>> getPersonalDetails(
    String accessToken,
    String personalId,
  ) async {
    try {
      String url = "${URLS.kPersonalUrl}$personalId/";
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
}
