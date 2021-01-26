class Certificate {
  final int personId;
  final int id;
  final String name;
  final String issuedBy;
  final String date;

  Certificate({
    this.personId,
    this.id,
    this.name,
    this.issuedBy,
    this.date,
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
