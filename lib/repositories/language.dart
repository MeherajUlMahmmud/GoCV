import '../apis/api.dart';
import '../providers/user_data_provider.dart';
import '../utils/helper.dart';
import '../utils/urls.dart';

class LanguageRepository {
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getLanguages(String resumeId, Map<String, dynamic> params) async {
    try {
      final String accessToken = getAccessToken();
      String queryString = Uri(queryParameters: params).query;
      final String url = '${URLS.kLanguageUrl}$resumeId/list/?$queryString';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }

  getLanguageDetails(String languageId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kLanguageUrl}$languageId/details/';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }

  createLanguage(Map<String, dynamic> languageData) async {
    try {
      final String accessToken = getAccessToken();
      const String url = '${URLS.kLanguageUrl}create/';

      final data = await APIService().sendPostRequest(
        accessToken,
        languageData,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }

  updateLanguage(String languageId, Map<String, dynamic> languageData) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kLanguageUrl}$languageId/update/';

      final data = await APIService().sendPatchRequest(
        accessToken,
        languageData,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }
}
