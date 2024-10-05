import '../apis/api.dart';
import '../providers/user_data_provider.dart';
import '../utils/helper.dart';
import '../utils/urls.dart';

class ExperienceRepository {
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getExperiences(String resumeId, Map<String, dynamic> params) async {
    try {
      final String accessToken = getAccessToken();
      String queryString = Uri(queryParameters: params).query;
      final String url = '${URLS.kExperienceUrl}$resumeId/list/?$queryString';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }

  getExperienceDetails(String resumeId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kExperienceUrl}$resumeId/details/';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
    }
  }

  updateExperience(
      String experienceId, Map<String, dynamic> experienceData) async {
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
      return Helper().handleApiError(error);
    }
  }

  deleteExperience(String experienceId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kExperienceUrl}$experienceId/destroy/';

      final data = await APIService().sendDeleteRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }
}
