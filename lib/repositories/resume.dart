import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class ResumeRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getResumes(
    String userId,
    Map<String, dynamic> params,
  ) async {
    try {
      final String accessToken = getAccessToken();
      String queryString = Uri(queryParameters: params).query;
      final String url = '${URLS.kResumeUrl}list/?user=$userId&$queryString';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );

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

  getResumeDetails(String resumeId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kResumeUrl}$resumeId/details/';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      print('Error getting resume details: $error');
      return {
        'status': 500,
        'message': 'Error getting resume details: $error',
      };
    }
  }

  getResumePreview(String resumeId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kResumeUrl}$resumeId/preview/';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      print('Error getting resume preview: $error');
      return {
        'status': 500,
        'message': 'Error getting resume preview: $error',
      };
    }
  }

  createResume(Map<String, dynamic> resumeData) async {
    try {
      final String accessToken = getAccessToken();
      const String url = '${URLS.kResumeUrl}create/';
      final data = await APIService().sendPostRequest(
        accessToken,
        resumeData,
        url,
      );
      return data;
    } catch (error) {
      print('Error creating resume: $error');
      return {
        'status': 500,
        'message': 'Error creating resume: $error',
      };
    }
  }

  updateResume(String resumeId, Map<String, dynamic> resumeData) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kResumeUrl}$resumeId/update/';

      final data = await APIService().sendPatchRequest(
        accessToken,
        resumeData,
        url,
      );
      return data;
    } catch (error) {
      print('Error updating resume: $error');
      return {
        'status': 500,
        'message': 'Error updating resume: $error',
      };
    }
  }

  deleteResume(String resumeId) async {
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
