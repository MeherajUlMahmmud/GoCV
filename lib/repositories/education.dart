import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class EducationRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getEducations(String resumeId, Map<String, dynamic> params) async {
    try {
      final String accessToken = getAccessToken();
      String queryString = Uri(queryParameters: params).query;
      final String url = '${URLS.kEducationUrl}$resumeId/list/?$queryString';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting education list: $error');
      return {
        'status': 500,
        'message': 'Error getting education list: $error',
      };
    }
  }

  getEducationDetails(String educationId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kEducationUrl}$educationId/details/';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting education details: $error');
      return {
        'status': 500,
        'message': 'Error getting education details: $error',
      };
    }
  }

  createEducation(Map<String, dynamic> educationData) async {
    try {
      final String accessToken = getAccessToken();
      const String url = '${URLS.kEducationUrl}create/';

      final data = await APIService().sendPostRequest(
        accessToken,
        educationData,
        url,
      );
      return data;
    } catch (error) {
      print('Error creating education: $error');
      return {
        'status': 500,
        'message': 'Error creating education: $error',
      };
    }
  }

  updateEducation(String educationId, Map<String, dynamic> updatedData) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kEducationUrl}$educationId/update/';

      final data = await APIService().sendPatchRequest(
        accessToken,
        updatedData,
        url,
      );
      return data;
    } catch (error) {
      print('Error updating education: $error');
      return {
        'status': 500,
        'message': 'Error updating education: $error',
      };
    }
  }

  deleteEducation(String educationId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kEducationUrl}$educationId/destroy/';

      final data = await APIService().sendDeleteRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      print('Error deleting education: $error');
      return {
        'status': 500,
        'message': 'Error deleting education: $error',
      };
    }
  }
}
