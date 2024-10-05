import '../apis/api.dart';
import '../providers/user_data_provider.dart';
import '../utils/helper.dart';
import '../utils/urls.dart';

class SkillRepository {
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
      return Helper().handleApiError(error);
    }
  }

  getSkillDetails(String skillId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kSkillUrl}$skillId/details/';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
    }
  }

  deleteSkill(String skillId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kSkillUrl}$skillId/destroy/';

      final data = await APIService().sendDeleteRequest(accessToken, url);
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }
}
