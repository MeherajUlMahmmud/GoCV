import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class SkillRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getSkills(String resumeId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kSkillUrl}$resumeId/list/';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      print('Error getting skill list: $error');
      return {
        'status': 500,
        'message': 'Error getting skill list: $error',
      };
    }
  }
}
