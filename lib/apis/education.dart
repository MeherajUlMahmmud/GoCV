import 'dart:convert';
import 'package:gocv/utils/urls.dart';
import 'package:http/http.dart' as http;

class EducationService {
  Future<Map<String, dynamic>> getEducationList(
    String accessToken,
    String resumeId,
  ) async {
    try {
      String url = "${URLS.kEducationUrl}?resume=$resumeId";
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

  Future<Map<String, dynamic>> getEducation(
    String accessToken,
    String educationId,
  ) async {
    try {
      String url = "${URLS.kEducationUrl}$educationId";
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

  Future<Map<String, dynamic>> createEducation(
    String accessToken,
    String resumeId,
    String schoolName,
    String degree,
    String department,
    String gradeScale,
    String grade,
    String? startDate,
    String? endDate,
    String description,
    bool isCurrentlyWorking,
  ) async {
    try {
      String url = URLS.kEducationUrl;
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'resume': resumeId,
          'school_name': schoolName,
          'degree': degree,
          'department': department,
          'grade_scale': gradeScale,
          'grade': grade,
          'start_date': startDate,
          'end_date': endDate,
          'description': description,
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

  Future<Map<String, dynamic>> updateEducation(
    String accessToken,
    String educationId,
    String schoolName,
    String degree,
    String department,
    String gradeScale,
    String grade,
    String? startDate,
    String? endDate,
    String description,
    bool isCurrentlyWorking,
  ) async {
    try {
      String url = "${URLS.kEducationUrl}$educationId/";
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'company_name': schoolName,
          'degree': degree,
          'department': department,
          'grade_scale': gradeScale,
          'grade': grade,
          'start_date': startDate,
          'end_date': endDate,
          'description': description,
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

  Future<Map<String, dynamic>> deleteEducation(
    String accessToken,
    String educationId,
  ) async {
    print(educationId);
    try {
      String url = "${URLS.kEducationUrl}$educationId/";
      print(url);
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 204) {
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
