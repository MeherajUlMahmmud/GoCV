import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/user_data_provider.dart';
import 'package:gocv/utils/urls.dart';

class LanguageRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getLanguages(String resumeId, Map<String, dynamic> params) async {
    try {
      final String accessToken = getAccessToken();
      String queryString = Uri(queryParameters: params).query;
      final String url = '${URLS.kLanguageUrl}$resumeId/list/?$queryString';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting language list: $error');
      return {
        'status': 500,
        'message': 'Error getting language list: $error',
      };
    }
  }

  getLanguageDetails(String languageId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kLanguageUrl}$languageId/details/';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting language details: $error');
      return {
        'status': 500,
        'message': 'Error getting language details: $error',
      };
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
      print('Error creating language: $error');
      return {
        'status': 500,
        'message': 'Error creating language: $error',
      };
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
      print('Error updating language: $error');
      return {
        'status': 500,
        'message': 'Error updating language: $error',
      };
    }
  }
}
