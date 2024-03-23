import 'package:gocv/providers/user_data_provider.dart';

class ApplicantRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }
}
