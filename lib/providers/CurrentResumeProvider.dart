import 'package:flutter/material.dart';
import 'package:gocv/models/resume.dart';

class CurrentResumeProvider with ChangeNotifier {
  late Resume _currentResume;
  late String _personalId;
  late String _contactId;

  Resume get currentResume => _currentResume;
  String get personalId => _personalId;
  String get contactId => _contactId;

  void setCurrentResume(Resume resume) {
    _currentResume = resume;
    notifyListeners();
  }

  void updateCurrentResume(Resume resume) {
    _currentResume = resume;
    notifyListeners();
  }

  void setPersonalId(String id) {
    _personalId = id;
    notifyListeners();
  }

  void setContactId(String id) {
    _contactId = id;
    notifyListeners();
  }
}
