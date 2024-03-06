import 'dart:ffi';

import 'package:gocv/models/user.dart';

class Experience {
  int id = 0;
  int resume = 0;
  String companyName = '';
  String position = '';
  String type = '';
  String startDate = '';
  bool? isCurrent;
  String? endDate;
  String? description;
  Double? salary;
  String? companyWebsite;
  UserBase? createdBy;
  String? createdAt;
  UserBase? updatedBy;
  String? updatedAt;

  Experience({
    required this.id,
    required this.resume,
    required this.companyName,
    required this.position,
    required this.type,
    required this.startDate,
    this.isCurrent,
    this.endDate,
    this.description,
    this.salary,
    this.companyWebsite,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  Experience.fromJson(Map<String, dynamic> json) {
    resume = json['resume'];
    companyName = json['company_name'];
    position = json['position'];
    type = json['type'];
    startDate = json['start_date'];
    isCurrent = json['is_current'];
    endDate = json['end_date'];
    description = json['description'];
    salary = json['salary'];
    companyWebsite = json['company_website'];
    id = json['id'];
    createdBy = json['created_by'] != null
        ? UserBase.fromJson(json['created_by'])
        : null;
    createdAt = json['created_at'];
    updatedBy = json['updated_by'] != null
        ? UserBase.fromJson(json['updated_by'])
        : null;
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resume'] = resume;
    data['company_name'] = companyName;
    data['position'] = position;
    data['type'] = type;
    data['start_date'] = startDate;
    data['is_current'] = isCurrent;
    data['end_date'] = endDate;
    data['description'] = description;
    data['salary'] = salary;
    data['company_website'] = companyWebsite;
    return data;
  }
}
