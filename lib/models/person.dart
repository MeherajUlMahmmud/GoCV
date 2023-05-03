class Person {
  final int id;
  final String title;
  final String firstName;
  final String surname;
  final String aboutMe;
  final String dob;
  final String nationality;
  final String country;
  final String city;
  final String creationDateTime;
  final String phone;
  final String email;
  final String address;
  final String linkedin;
  final String facebook;
  final String github;

  Person({
    required this.id,
    required this.title,
    required this.firstName,
    required this.surname,
    required this.aboutMe,
    required this.dob,
    required this.nationality,
    required this.country,
    required this.city,
    required this.creationDateTime,
    required this.phone,
    required this.email,
    required this.address,
    required this.linkedin,
    required this.facebook,
    required this.github,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "firstName": firstName,
      "surname": surname,
      "aboutMe": aboutMe,
      "dob": dob,
      "nationality": nationality,
      "country": country,
      "city": city,
      "creationDateTime": creationDateTime,
      "phone": phone,
      "email": email,
      "address": address,
      "linkedin": linkedin,
      "facebook": facebook,
      "github": github,
    };
  }
}
