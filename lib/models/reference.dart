class Reference {
  final int personId;
  final int id;
  final String fullName;
  final String workPlace;
  final String designation;
  final String email;
  final String phone;

  Reference({
    this.personId,
    this.id,
    this.fullName,
    this.workPlace,
    this.designation,
    this.email,
    this.phone,
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
