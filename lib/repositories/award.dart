import '../apis/api.dart';
import '../providers/user_data_provider.dart';
import '../utils/helper.dart';
import '../utils/urls.dart';

class AwardRepository {
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getAwards(String resumeId, Map<String, dynamic> params) async {
    try {
      final String accessToken = getAccessToken();
      String queryString = Uri(queryParameters: params).query;
      final String url = '${URLS.kAwardUrl}$resumeId/list/?$queryString';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }

  getAwardDetails(String awardId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kAwardUrl}$awardId/details/';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
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
      return Helper().handleApiError(error);
    }
  }

  deleteAward(String awardId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kAwardUrl}$awardId/destroy/';

      final response = await APIService().sendDeleteRequest(
        accessToken,
        url,
      );
      return response;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }
}
