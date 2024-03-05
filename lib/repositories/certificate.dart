import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class CertificateRepository {
  UserProvider userProvider = UserProvider();

  String getAccessToken() {
    return userProvider.tokens['access'];
  }

  Map<String, dynamic> getCertificates(String resumeId) {
    String accessToken = getAccessToken();
    String url = '${URLS.kCertificationUrl}$resumeId/list/';

    APIService().sendGetRequest(accessToken, url).then((data) async {
      print(data);
      return {
        'status': data['status'] ?? 500,
        'message': data['message'] ?? '',
        'data': data['data']['data'] ?? [],
      };
    }).catchError((error) {
      return {
        'status': 500,
        'message': 'Internal Server Error',
        'data': [],
      };
    });

    return {
      'status': 500,
      'message': 'Internal Server Error',
      'data': [],
    };
  }
}
