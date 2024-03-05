import 'package:flutter/material.dart';
import 'package:gocv/models/user.dart';

class UserProvider with ChangeNotifier {
  final Map<String, dynamic> _tokens = {
    'access': '',
    'refresh': '',
  };
  UserBase? _userData;

  Map<String, dynamic> get tokens => _tokens;
  UserBase? get userData => _userData;

  void setTokens(Map<String, dynamic> tokens) {
    _tokens['access'] = tokens['access'];
    _tokens['refresh'] = tokens['refresh'];
    notifyListeners();
  }

  void setUserData(UserBase userData) {
    _userData = userData;
    notifyListeners();
  }

  void clearData() {
    _tokens['access'] = '';
    _tokens['refresh'] = '';
    _userData = null;
    notifyListeners();
  }
}
