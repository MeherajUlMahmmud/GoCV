import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class UserRepository {
  // Method to get the access token from UserProvider
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
      print('Error getting user profile: $error');
      return {
        'status': 500,
        'message': 'Error getting user profile: $error',
      };
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
      print('Error updating user profile: $error');
      return {
        'status': 500,
        'message': 'Error updating user profile: $error',
      };
    }
  }
}
