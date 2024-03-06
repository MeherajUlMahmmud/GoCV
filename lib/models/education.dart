import 'package:gocv/models/user.dart';

class Education {
  int id = 0;
  int resume = 0;
  String schoolName = '';
  String? degree;
  String? department;
  String? gradeScale;
  String? grade;
  String startDate = '';
  bool? isCurrent;
  String? endDate;
  String? description;
  UserBase? createdBy;
  String? createdAt;
  UserBase? updatedBy;
  String? updatedAt;

  Education({
    required this.id,
    required this.resume,
    required this.schoolName,
    this.degree,
    this.department,
    this.gradeScale,
    this.grade,
    required this.startDate,
    this.isCurrent,
    this.endDate,
    this.description,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  Education.fromJson(Map<String, dynamic> json) {
    resume = json['resume'];
    schoolName = json['school_name'];
    degree = json['degree'];
    department = json['department'];
    gradeScale = json['grade_scale'];
    grade = json['grade'];
    startDate = json['start_date'];
    isCurrent = json['is_current'];
    endDate = json['end_date'];
    description = json['description'];
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
    data['school_name'] = schoolName;
    data['degree'] = degree;
    data['department'] = department;
    data['grade_scale'] = gradeScale;
    data['grade'] = grade;
    data['start_date'] = startDate;
    data['is_current'] = isCurrent;
    data['end_date'] = endDate;
    data['description'] = description;
    data['id'] = id;
    if (createdBy != null) {
      data['created_by'] = createdBy!.toJson();
    }
    data['created_at'] = createdAt;
    if (updatedBy != null) {
      data['updated_by'] = updatedBy!.toJson();
    }
    data['updated_at'] = updatedAt;
    return data;
  }
}

class CreatedBy {
  String? email;
  bool? isApplicant;
  bool? isOrganization;
  bool? isVerified;
  bool? isStaff;
  bool? isSuperuser;

  CreatedBy(
      {this.email,
      this.isApplicant,
      this.isOrganization,
      this.isVerified,
      this.isStaff,
      this.isSuperuser});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    isApplicant = json['is_applicant'];
    isOrganization = json['is_organization'];
    isVerified = json['is_verified'];
    isStaff = json['is_staff'];
    isSuperuser = json['is_superuser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['is_applicant'] = isApplicant;
    data['is_organization'] = isOrganization;
    data['is_verified'] = isVerified;
    data['is_staff'] = isStaff;
    data['is_superuser'] = isSuperuser;
    return data;
  }
}
