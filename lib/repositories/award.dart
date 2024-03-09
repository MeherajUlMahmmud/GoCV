import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class AwardRepository {
  UserProvider userProvider = UserProvider();

  String getAccessToken() {
    return userProvider.tokens['access'];
  }

  getAwards(String resumeId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kAwardUrl}$resumeId/list/';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      print('Error getting award list: $error');
      return {
        'status': 500,
        'message': 'Error getting award list: $error',
      };
    }
  }
}
