import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class SkillRepository {
  UserProvider userProvider = UserProvider();

  String getAccessToken() {
    return userProvider.tokens['access'];
  }
}
