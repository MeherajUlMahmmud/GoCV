import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class ResumeRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  // Method to fetch resumes
  Future<Map<String, dynamic>> getResumes(String userId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kResumeUrl}list/?user=$userId';

      final data = await APIService().sendGetRequest(accessToken, url);

      // Check if the data contains the expected keys
      if (data.containsKey('status') && data.containsKey('data')) {
        return {
          'status': data['status'] ?? 500,
          'message': data['message'] ?? '',
          'data': data['data']['data'] ?? [],
        };
      } else {
        return {
          'status': 500,
          'message': 'Invalid response format',
          'data': [],
        };
      }
    } catch (error) {
      // Handle errors
      return {
        'status': 500,
        'message': 'Internal Server Error: $error',
        'data': [],
      };
    }
  }

  Future<Map<String, dynamic>> getResumeDetails(String resumeId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kResumeUrl}$resumeId/details/';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting resume details: $error');
      return {
        'status': 500,
        'message': 'Error getting resume details: $error',
      };
    }
  }

  Future<Map<String, dynamic>> createResume(
      Map<String, dynamic> resumeData) async {
    try {
      final String accessToken = getAccessToken();
      const String url = '${URLS.kResumeUrl}create/';
      final data =
          await APIService().sendPostRequest(accessToken, resumeData, url);
      return data;
    } catch (error) {
      print('Error creating resume: $error');
      return {
        'status': 500,
        'message': 'Error creating resume: $error',
      };
    }
  }

  Future<Map<String, dynamic>> deleteResume(String resumeId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kResumeUrl}$resumeId/destroy/';
      final data = await APIService().sendDeleteRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error deleting resume: $error');
      return {
        'status': 500,
        'message': 'Error deleting resume: $error',
      };
    }
  }
}
