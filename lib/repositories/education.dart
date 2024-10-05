import '../apis/api.dart';
import '../providers/user_data_provider.dart';
import '../utils/helper.dart';
import '../utils/urls.dart';

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
      return Helper().handleApiError(error);
    }
  }

  getEducationDetails(String educationId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kEducationUrl}$educationId/details/';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
    }
  }

  updateSerial(String educationId, String newSerial) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kEducationUrl}$educationId/update-serial/';

      final data = await APIService().sendPatchRequest(
        accessToken,
        {
          'new_serial': newSerial,
        },
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
    }
  }
}
