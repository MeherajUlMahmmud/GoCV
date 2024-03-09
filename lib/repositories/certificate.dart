import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class CertificateRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getCertificates(String resumeId, Map<String, dynamic> params) async {
    try {
      final String accessToken = getAccessToken();
      String queryString = Uri(queryParameters: params).query;
      final String url =
          '${URLS.kCertificationUrl}$resumeId/list/?$queryString';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting certificate list: $error');
      return {
        'status': 500,
        'message': 'Error getting certificate list: $error',
      };
    }
  }

  getCertificateDetails(String certificateId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kCertificationUrl}$certificateId/details/';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting certificate details: $error');
      return {
        'status': 500,
        'message': 'Error getting certificate details: $error',
      };
    }
  }

  createCertificate(String resumeId, Map<String, dynamic> data) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kCertificationUrl}$resumeId/create/';

      final response = await APIService().sendPostRequest(
        accessToken,
        data,
        url,
      );
      return response;
    } catch (error) {
      print('Error creating certificate: $error');
      return {
        'status': 500,
        'message': 'Error creating certificate: $error',
      };
    }
  }

  updateCertificate(
      String resumeId, int certificateId, Map<String, dynamic> data) async {
    try {
      final String accessToken = getAccessToken();
      final String url =
          '${URLS.kCertificationUrl}$resumeId/update/$certificateId/';

      final response = await APIService().sendPatchRequest(
        accessToken,
        data,
        url,
      );
      return response;
    } catch (error) {
      print('Error updating certificate: $error');
      return {
        'status': 500,
        'message': 'Error updating certificate: $error',
      };
    }
  }
}
