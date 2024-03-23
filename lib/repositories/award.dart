import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/user_data_provider.dart';
import 'package:gocv/utils/urls.dart';

class AwardRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getAwards(String resumeId, Map<String, dynamic> params) async {
    try {
      final String accessToken = getAccessToken();
      String queryString = Uri(queryParameters: params).query;
      final String url = '${URLS.kAwardUrl}$resumeId/list/?$queryString';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting award list: $error');
      return {
        'status': 500,
        'message': 'Error getting award list: $error',
      };
    }
  }

  getAwardDetails(String awardId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kAwardUrl}$awardId/details/';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting award details: $error');
      return {
        'status': 500,
        'message': 'Error getting award details: $error',
      };
    }
  }

  createAward(String awardId, Map<String, dynamic> data) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kAwardUrl}$awardId/create/';

      final response = await APIService().sendPostRequest(
        accessToken,
        data,
        url,
      );
      return response;
    } catch (error) {
      print('Error creating award: $error');
      return {
        'status': 500,
        'message': 'Error creating award: $error',
      };
    }
  }

  updateAward(String awardId, Map<String, dynamic> data) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kAwardUrl}$awardId/update/';

      final response = await APIService().sendPatchRequest(
        accessToken,
        data,
        url,
      );
      return response;
    } catch (error) {
      print('Error updating award: $error');
      return {
        'status': 500,
        'message': 'Error updating award: $error',
      };
    }
  }

  deleteAward(String awardId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kAwardUrl}$awardId/destroy/';

      final response = await APIService().sendDeleteRequest(accessToken, url);
      return response;
    } catch (error) {
      print('Error deleting award: $error');
      return {
        'status': 500,
        'message': 'Error deleting award: $error',
      };
    }
  }
}
