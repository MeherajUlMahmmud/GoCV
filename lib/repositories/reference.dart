import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class ReferenceRepository {
  // Method to get the access token from UserProvider
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
      print('Error getting reference list: $error');
      return {
        'status': 500,
        'message': 'Error getting reference list: $error',
      };
    }
  }

  getReferenceDetails(String referenceId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kReferenceUrl}$referenceId/details/';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting reference details: $error');
      return {
        'status': 500,
        'message': 'Error getting reference details: $error',
      };
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
      print('Error creating reference: $error');
      return {
        'status': 500,
        'message': 'Error creating reference: $error',
      };
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
      print('Error updating reference: $error');
      return {
        'status': 500,
        'message': 'Error updating reference: $error',
      };
    }
  }

  deleteReference(String referenceId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kReferenceUrl}$referenceId/destroy/';

      final data = await APIService().sendDeleteRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error deleting reference: $error');
      return {
        'status': 500,
        'message': 'Error deleting reference: $error',
      };
    }
  }
}
