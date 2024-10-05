import '../apis/api.dart';
import '../providers/user_data_provider.dart';
import '../utils/helper.dart';
import '../utils/urls.dart';

class CertificateRepository {
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getCertificates(String resumeId, Map<String, dynamic> params) async {
    try {
      final String accessToken = getAccessToken();
      String queryString = Uri(queryParameters: params).query;
      final String url =
          '${URLS.kCertificationUrl}$resumeId/list/?$queryString';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }

  getCertificateDetails(String certificateId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kCertificationUrl}$certificateId/details/';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
    }
  }
}
