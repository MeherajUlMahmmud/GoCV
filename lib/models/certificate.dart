class Certificate {
  final int personId;
  final int id;
  final String name;
  final String issuedBy;
  final String date;

  Certificate({
    required this.personId,
    required this.id,
    required this.name,
    required this.issuedBy,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      "personId": personId,
      "id": id,
      "name": name,
      "issuedBy": issuedBy,
      "date": date,
    };
  }
}
