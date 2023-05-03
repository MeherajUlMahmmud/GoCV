class Reference {
  final int personId;
  final int id;
  final String fullName;
  final String workPlace;
  final String designation;
  final String email;
  final String phone;

  Reference({
    required this.personId,
    required this.id,
    required this.fullName,
    required this.workPlace,
    required this.designation,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      "personId": personId,
      "id": id,
      "fullName": fullName,
      "workPlace": workPlace,
      "designation": designation,
      "email": email,
      "phone": phone,
    };
  }
}
