import '../apis/api.dart';
import '../providers/user_data_provider.dart';
import '../utils/helper.dart';
import '../utils/urls.dart';

class ResumeRepository {
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
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
    }
  }

  deleteResume(String resumeId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kResumeUrl}$resumeId/destroy/';

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
