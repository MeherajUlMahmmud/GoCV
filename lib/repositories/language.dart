import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class LanguageRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getLanguages(String resumeId) {
    final String accessToken = getAccessToken();
    final String url = '${URLS.kLanguageUrl}$resumeId/list/';

    APIService().sendGetRequest(accessToken, url).then((data) async {});
  }
}
