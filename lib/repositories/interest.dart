import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class InterestRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getInterests(String resumeId, Map<String, dynamic> params) async {
    try {
      final String accessToken = getAccessToken();
      String queryString = Uri(queryParameters: params).query;
      final String url = '${URLS.kInterestUrl}$resumeId/list/?$queryString';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting interest list: $error');
      return {
        'status': 500,
        'message': 'Error getting interest list: $error',
      };
    }
  }

  getInterestDetails(String resumeId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kInterestUrl}$resumeId/details/';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting interest details: $error');
      return {
        'status': 500,
        'message': 'Error getting interest details: $error',
      };
    }
  }

  createInterest(String resumeId, Map<String, dynamic> interestData) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kInterestUrl}$resumeId/create/';

      final data = await APIService().sendPostRequest(
        accessToken,
        interestData,
        url,
      );
      return data;
    } catch (error) {
      print('Error creating interest: $error');
      return {
        'status': 500,
        'message': 'Error creating interest: $error',
      };
    }
  }

  updateInterest(String resumeId, String interestId,
      Map<String, dynamic> interestData) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kInterestUrl}$resumeId/$interestId/update/';

      final data = await APIService().sendPatchRequest(
        accessToken,
        interestData,
        url,
      );
      return data;
    } catch (error) {
      print('Error updating interest: $error');
      return {
        'status': 500,
        'message': 'Error updating interest: $error',
      };
    }
  }
}
