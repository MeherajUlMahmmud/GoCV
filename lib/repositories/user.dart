import '../apis/api.dart';
import '../providers/user_data_provider.dart';
import '../utils/helper.dart';
import '../utils/urls.dart';

class UserRepository {
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getUserProfile() async {
    try {
      final String accessToken = getAccessToken();
      const String url = '${URLS.kUserUrl}profile/';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }

  updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kUserUrl}$userId/update/';

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
