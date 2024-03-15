import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class SkillRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getSkills(String resumeId, Map<String, dynamic> params) async {
    try {
      final String accessToken = getAccessToken();
      String queryString = Uri(queryParameters: params).query;
      final String url = '${URLS.kSkillUrl}$resumeId/list/?$queryString';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting skill list: $error');
      return {
        'status': 500,
        'message': 'Error getting skill list: $error',
      };
    }
  }

  getSkillDetails(String skillId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kSkillUrl}$skillId/details/';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting skill details: $error');
      return {
        'status': 500,
        'message': 'Error getting skill details: $error',
      };
    }
  }

  createSkill(Map<String, dynamic> skillData) async {
    try {
      final String accessToken = getAccessToken();
      const String url = '${URLS.kSkillUrl}create/';

      final data = await APIService().sendPostRequest(
        accessToken,
        skillData,
        url,
      );
      return data;
    } catch (error) {
      print('Error creating skill: $error');
      return {
        'status': 500,
        'message': 'Error creating skill: $error',
      };
    }
  }

  updateSkill(String skillId, Map<String, dynamic> skillData) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kSkillUrl}$skillId/update/';

      final data = await APIService().sendPatchRequest(
        accessToken,
        skillData,
        url,
      );
      return data;
    } catch (error) {
      print('Error updating skill: $error');
      return {
        'status': 500,
        'message': 'Error updating skill: $error',
      };
    }
  }

  deleteSkill(String skillId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kSkillUrl}$skillId/destroy/';

      final data = await APIService().sendDeleteRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error deleting skill: $error');
      return {
        'status': 500,
        'message': 'Error deleting skill: $error',
      };
    }
  }
}
