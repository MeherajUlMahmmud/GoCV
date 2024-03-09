import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class ExperienceRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getExperiences(String resumeId, Map<String, dynamic> params) async {
    try {
      final String accessToken = getAccessToken();
      String queryString = Uri(queryParameters: params).query;
      final String url = '${URLS.kExperienceUrl}$resumeId/list/?$queryString';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting experience list: $error');
      return {
        'status': 500,
        'message': 'Error getting experience list: $error',
      };
    }
  }

  getExperienceDetails(String resumeId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kExperienceUrl}$resumeId/details/';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting experience details: $error');
      return {
        'status': 500,
        'message': 'Error getting experience details: $error',
      };
    }
  }

  createExperience(
    String resumeId,
    Map<String, dynamic> experienceData,
  ) async {
    try {
      final String accessToken = getAccessToken();
      const String url = '${URLS.kExperienceUrl}create/';

      final data = await APIService().sendPostRequest(
        accessToken,
        experienceData,
        url,
      );
      return data;
    } catch (error) {
      print('Error creating experience: $error');
      return {
        'status': 500,
        'message': 'Error creating experience: $error',
      };
    }
  }

  updateExperience(String resumeId, String experienceId,
      Map<String, dynamic> experienceData) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kExperienceUrl}$experienceId/update/';

      final data = await APIService().sendPatchRequest(
        accessToken,
        experienceData,
        url,
      );
      return data;
    } catch (error) {
      print('Error updating experience: $error');
      return {
        'status': 500,
        'message': 'Error updating experience: $error',
      };
    }
  }

  deleteExperience(String experienceId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kExperienceUrl}$experienceId/destroy/';

      final data = await APIService().sendDeleteRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error deleting experience: $error');
      return {
        'status': 500,
        'message': 'Error deleting experience: $error',
      };
    }
  }
}
