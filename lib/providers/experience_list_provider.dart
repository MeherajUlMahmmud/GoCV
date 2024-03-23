import 'package:flutter/material.dart';
import 'package:gocv/models/experience.dart';

class ExperienceListProvider extends ChangeNotifier {
  final List<Experience> _experienceList = [];

  List<Experience> get experienceList => _experienceList;

  void setExperienceList(List<Experience> experienceList) {
    _experienceList.clear();
    _experienceList.addAll(experienceList);
    notifyListeners();
  }

  void addExperience(Experience experience) {
    _experienceList.add(experience);
    notifyListeners();
  }

  void updateExperience(String experienceId, Experience experience) {
    final int index = _experienceList
        .indexWhere((element) => element.id.toString() == experienceId);
    // print('index: $index');
    if (index != -1) {
      _experienceList[index] = experience;
      notifyListeners();
    }
  }

  void removeExperience(Experience experience) {
    _experienceList.remove(experience);
    notifyListeners();
  }
}
