class UserBase {
  int? id;
  String? email;
  bool? isApplicant;
  bool? isorganization;
  bool? isVerified;
  bool? isStaff;
  bool? isSuperuser;

  UserBase({
    this.id,
    this.email,
    this.isApplicant,
    this.isorganization,
    this.isVerified,
    this.isStaff,
    this.isSuperuser,
  });

  UserBase.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    isApplicant = json['is_applicant'];
    isorganization = json['is_organization'];
    isVerified = json['is_verified'];
    isStaff = json['is_staff'];
    isSuperuser = json['is_superuser'];
  }
}
