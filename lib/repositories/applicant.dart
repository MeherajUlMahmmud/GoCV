import 'package:gocv/providers/UserDataProvider.dart';

class ApplicantRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }
}
