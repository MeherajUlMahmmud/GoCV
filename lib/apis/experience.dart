import 'dart:convert';
import 'package:gocv/utils/urls.dart';
import 'package:http/http.dart' as http;

class ExpreienceService {
  Future<Map<String, dynamic>> getExperienceList(
    String accessToken,
    String resumeId,
  ) async {
    try {
      String url = "${URLS.kExperienceUrl}?resume=$resumeId";
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

  Future<Map<String, dynamic>> getExperience(
    String accessToken,
    String experienceId,
  ) async {
    try {
      String url = "${URLS.kExperienceUrl}$experienceId";
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

  Future<Map<String, dynamic>> createExperience(
    String accessToken,
    String resumeId,
    String companyName,
    String position,
    String type,
    String startDate,
    String? endDate,
    String description,
    // String salary,
    String companyWebsite,
    bool isCurrentlyWorking,
  ) async {
    try {
      String url = URLS.kExperienceUrl;
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'resume': resumeId,
          'company_name': companyName,
          'position': position,
          'type': type,
          'start_date': startDate,
          'end_date': endDate,
          'description': description,
          // 'salary': salary,
          'company_website': companyWebsite,
          'is_current': isCurrentlyWorking,
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
        print(data);
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

  Future<Map<String, dynamic>> updateExperience(
    String accessToken,
    String experienceId,
    String companyName,
    String position,
    String type,
    String startDate,
    String? endDate,
    String description,
    // String salary,
    String companyWebsite,
    bool isCurrentlyWorking,
  ) async {
    try {
      String url = "${URLS.kExperienceUrl}$experienceId/";
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'company_name': companyName,
          'position': position,
          'type': type,
          'start_date': startDate,
          'end_date': endDate,
          'description': description,
          // 'salary': salary,
          'company_website': companyWebsite,
          'is_current': isCurrentlyWorking,
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
        print(data);
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

  Future<Map<String, dynamic>> deleteExperience(
    String accessToken,
    String experienceId,
  ) async {
    print(experienceId);
    try {
      String url = "${URLS.kExperienceUrl}$experienceId/";
      print(url);
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        return {
          'status': response.statusCode,
        };
      } else {
        final data = jsonDecode(response.body);
        print(data);
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
