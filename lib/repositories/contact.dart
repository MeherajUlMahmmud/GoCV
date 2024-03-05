import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class ContactRepository {
  UserProvider userProvider = UserProvider();

  String getAccessToken() {
    return userProvider.tokens['access'];
  }
}
