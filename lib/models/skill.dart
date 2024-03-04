class Skill {
  final int personId;
  final int id;
  final String name;
  final int proficiency;

  Skill({
    required this.personId,
    required this.id,
    required this.name,
    required this.proficiency,
  });

  Map<String, dynamic> toMap() {
    return {
      'personId': personId,
      'id': id,
      'name': name,
      'proficiency': proficiency,
    };
  }
}
