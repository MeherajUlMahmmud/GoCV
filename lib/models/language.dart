class Language {
  final int personId;
  final int id;
  final String name;
  final int proficiency;

  Language({
    this.personId,
    this.id,
    this.name,
    this.proficiency,
  });

  Map<String, dynamic> toMap() {
    return {
      "personId": personId,
      "id": id,
      "name": name,
      "proficiency": proficiency,
    };
  }
}
