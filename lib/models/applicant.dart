class Applicant {
  int? id;
  String firstName = '';
  String lastName = '';
  String? profilePicture;
  String? phoneNumber;
  int? resume;

  Applicant({
    this.id,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
    this.phoneNumber,
    this.resume,
  });

  Applicant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePicture = json['profile_picture'];
    phoneNumber = json['phone_number'];
    resume = json['resume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_picture'] = profilePicture;
    data['phone_number'] = phoneNumber;
    data['resume'] = resume;
    data['id'] = id;
    return data;
  }
}
