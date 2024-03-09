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
  String? resumePicture;
  bool? isActive;
  bool? isDeleted;
  int? createdBy;
  String? createdAt;
  int? updatedBy;
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
    this.resumePicture,
    this.isActive,
    this.isDeleted,
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
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    resume = json['resume'];
    resumePicture = json['resume_picture'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
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
    data['resume_picture'] = resumePicture;
    return data;
  }
}
