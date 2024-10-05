import 'applicant.dart';

class UserBase {
  int? id;
  String? email;
  bool? isApplicant;
  bool? isOrganization;
  bool? isVerified;
  bool? isStaff;
  bool? isSuperuser;

  UserBase({
    this.id,
    this.email,
    this.isApplicant,
    this.isOrganization,
    this.isVerified,
    this.isStaff,
    this.isSuperuser,
  });

  UserBase.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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

class UserProfile {
  UserBase? userData;
  Applicant? applicantData;

  UserProfile({this.userData, this.applicantData});

  UserProfile.fromJson(Map<String, dynamic> json) {
    userData =
        json['user_data'] != null ? UserBase.fromJson(json['user_data']) : null;
    applicantData = json['applicant_data'] != null
        ? Applicant.fromJson(json['applicant_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userData != null) {
      data['user_data'] = userData!.toJson();
    }
    if (applicantData != null) {
      data['applicant_data'] = applicantData!.toJson();
    }
    return data;
  }
}
