import '../apis/api.dart';
import '../providers/user_data_provider.dart';
import '../utils/helper.dart';
import '../utils/urls.dart';

class InterestRepository {
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getInterests(String resumeId, Map<String, dynamic> params) async {
    try {
      final String accessToken = getAccessToken();
      String queryString = Uri(queryParameters: params).query;
      final String url = '${URLS.kInterestUrl}$resumeId/list/?$queryString';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }

  getInterestDetails(String resumeId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kInterestUrl}$resumeId/details/';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
    }
  }

  deleteInterest(String resumeId, String interestId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kInterestUrl}$resumeId/$interestId/destroy/';

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
