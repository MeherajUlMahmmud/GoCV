class Person {
  final int id;
  final String title;
  final String firstName;
  final String surname;
  final String jobTitle;
  final String aboutMe;
  final String gender;
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

//  List<Education> educations;
//  List<Work> works;
//  List<Language> languages = new List<Language>();
//  List<Skill> skills = new List<Skill>();
//  List<Certificate> certificates = new List<Certificate>();
//  List<Reference> references = new List<Reference>();

  Person(
      {this.id,
      this.title,
      this.firstName,
      this.surname,
      this.jobTitle,
      this.aboutMe,
      this.gender,
      this.dob,
      this.nationality,
      this.country,
      this.city,
      this.creationDateTime,
      this.phone,
      this.email,
      this.address,
      this.linkedin,
      this.facebook,
      this.github});

//  static final Person origin = Person(
//    "",
//    "",
//    "",
//    "",
//    "",
//    "",
//    "",
//    "",
//    "",
//    "",
//    "",
//    "",
//    "",
//    "",
//    "",
//    "",
//    "",
//    new List<Education>(),
//    new List<Work>(),
//    new List<Language>(),
//    new List<Skill>(),
//    new List<Certificate>(),
//    new List<Reference>(),
//  );
//
//  // factory constructor
//  factory Person.create() {
//    return origin;
//  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "firstName": firstName,
      "surname": surname,
      "jobTitle": jobTitle,
      "aboutMe": aboutMe,
      "gender": gender,
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
