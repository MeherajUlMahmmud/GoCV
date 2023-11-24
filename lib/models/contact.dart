import 'package:gocv/models/user.dart';

class Contact {
  int? id;
  String? phoneNumber;
  String? email;
  String? address;
  String? zipCode;
  String? facebook;
  String? linkedin;
  String? github;
  String? website;
  int? resume;
  UserBase? createdBy;
  String? createdAt;
  UserBase? updatedBy;
  String? updatedAt;

  Contact({
    this.id,
    this.phoneNumber,
    this.email,
    this.address,
    this.zipCode,
    this.facebook,
    this.linkedin,
    this.github,
    this.website,
    this.resume,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  Contact.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phone_number'];
    email = json['email'];
    address = json['address'];
    zipCode = json['zip_code'];
    facebook = json['facebook'];
    linkedin = json['linkedin'];
    github = json['github'];
    website = json['website'];
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
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['address'] = address;
    data['zip_code'] = zipCode;
    data['facebook'] = facebook;
    data['linkedin'] = linkedin;
    data['github'] = github;
    data['website'] = website;
    data['resume'] = resume;
    return data;
  }
}
