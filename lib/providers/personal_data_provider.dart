import 'package:flutter/material.dart';
import 'package:gocv/models/personal.dart';

class PersonalDataProvider extends ChangeNotifier {
  final Personal _personalData = Personal();

  Personal get personalData => _personalData;

  void setPersonalData(Personal personalData) {
    _personalData.id = personalData.id;
    _personalData.firstName = personalData.firstName;
    _personalData.lastName = personalData.lastName;
    _personalData.aboutMe = personalData.aboutMe;
    _personalData.dateOfBirth = personalData.dateOfBirth;
    _personalData.city = personalData.city;
    _personalData.state = personalData.state;
    _personalData.country = personalData.country;
    _personalData.nationality = personalData.nationality;
    _personalData.resumePicture = personalData.resumePicture;
    notifyListeners();
  }
}
