import 'package:gocv/models/user.dart';

class Resume {
  String name = '';
  int? id;
  UserBase? user;
  bool? isEducationVisible;
  bool? isExperienceVisible;
  bool? isSkillVisible;
  bool? isLanguageVisible;
  bool? isInterestVisible;
  bool? isReferenceVisible;
  bool? isAwardVisible;
  bool? isCertificationVisible;
  bool? isActive;
  bool? isDeleted;
  int? createdBy;
  String? createdAt;
  int? updatedBy;
  String? updatedAt;

  Resume({
    required this.name,
    this.id,
    this.user,
    this.isEducationVisible,
    this.isExperienceVisible,
    this.isSkillVisible,
    this.isLanguageVisible,
    this.isInterestVisible,
    this.isReferenceVisible,
    this.isAwardVisible,
    this.isCertificationVisible,
    this.isActive,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  Resume.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    user = json['user'] != null ? UserBase.fromJson(json['user']) : null;
    isEducationVisible = json['is_education_visible'];
    isExperienceVisible = json['is_experience_visible'];
    isSkillVisible = json['is_skill_visible'];
    isLanguageVisible = json['is_language_visible'];
    isInterestVisible = json['is_interest_visible'];
    isReferenceVisible = json['is_reference_visible'];
    isAwardVisible = json['is_award_visible'];
    isCertificationVisible = json['is_certification_visible'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
