import 'package:flutter/material.dart';
import 'package:gocv/models/user.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfile _userProfile = UserProfile();

  UserProfile get userProfile => _userProfile;

  void setUserProfile(UserProfile userProfile) {
    _userProfile = userProfile;
    notifyListeners();
  }
}
