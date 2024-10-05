import 'package:gocv/providers/user_data_provider.dart';

class ApplicantRepository {
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }
}
