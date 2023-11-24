import 'package:gocv/models/user.dart';

class Personal {
  int? id;
  String? firstName;
  String? lastName;
  String? aboutMe;
  String? dateOfBirth;
  String? nationality;
  String? city;
  String? state;
  String? country;
  int? resume;
  UserBase? createdBy;
  String? createdAt;
  UserBase? updatedBy;
  String? updatedAt;

  Personal({
    this.id,
    this.firstName,
    this.lastName,
    this.aboutMe,
    this.dateOfBirth,
    this.nationality,
    this.city,
    this.state,
    this.country,
    this.resume,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  Personal.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    aboutMe = json['about_me'];
    dateOfBirth = json['date_of_birth'];
    nationality = json['nationality'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    id = json['id'];
    resume = json['resume'];
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
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['about_me'] = aboutMe;
    data['date_of_birth'] = dateOfBirth;
    data['nationality'] = nationality;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['resume'] = resume;
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
