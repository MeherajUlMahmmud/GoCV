import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class ExperienceRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  Future<Map<String, dynamic>> getExperiences(String resumeId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kExperienceUrl}$resumeId/list/';

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

  Future<Map<String, dynamic>> getExperienceDetails(String resumeId) async {
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
}
