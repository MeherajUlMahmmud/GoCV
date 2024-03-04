import 'package:flutter/material.dart';
import 'package:gocv/models/resume.dart';

class ResumeListProvider with ChangeNotifier {
  final List<Resume> _resumeList = [];

  List<Resume> get resumeList => _resumeList;

  void addResume(Resume resume) {
    _resumeList.add(resume);
    notifyListeners();
  }

  void setResumeList(List<Resume> resumeList) {
    _resumeList.clear();
    _resumeList.addAll(resumeList);
    notifyListeners();
  }

  void removeResume(int index) {
    _resumeList.removeAt(index);
    notifyListeners();
  }
}
