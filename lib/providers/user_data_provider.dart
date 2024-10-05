import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  // Singleton instance
  static final UserProvider _singleton = UserProvider._internal();

  // Private constructor
  UserProvider._internal();

  // Factory method to provide access to the singleton instance
  factory UserProvider() {
    return _singleton;
  }

  final Map<String, dynamic> _tokens = {
    'access': '',
    'refresh': '',
  };
  UserBase? _userData;

  // Getters for tokens and userData
  Map<String, dynamic> get tokens => _tokens;
  UserBase? get userData => _userData;

  // Methods to modify tokens and userData
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
