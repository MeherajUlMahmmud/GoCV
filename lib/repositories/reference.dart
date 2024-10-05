import '../apis/api.dart';
import '../providers/user_data_provider.dart';
import '../utils/helper.dart';
import '../utils/urls.dart';

class ReferenceRepository {
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getReferences(String resumeId, Map<String, dynamic> params) async {
    try {
      final String accessToken = getAccessToken();
      String queryString = Uri(queryParameters: params).query;
      final String url = '${URLS.kReferenceUrl}$resumeId/list/?$queryString';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }

  getReferenceDetails(String referenceId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kReferenceUrl}$referenceId/details/';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }

  createReference(Map<String, dynamic> referenceData) async {
    try {
      final String accessToken = getAccessToken();
      const String url = '${URLS.kReferenceUrl}create/';

      final data = await APIService().sendPostRequest(
        accessToken,
        referenceData,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }

  updateReference(
    String referenceId,
    Map<String, dynamic> referenceData,
  ) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kReferenceUrl}$referenceId/update/';

      final data = await APIService().sendPatchRequest(
        accessToken,
        referenceData,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }

  deleteReference(String referenceId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kReferenceUrl}$referenceId/destroy/';

      final data = await APIService().sendDeleteRequest(accessToken, url);
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }
}
