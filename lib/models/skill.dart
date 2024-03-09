class Skill {
  int id = 0;
  int resume = 0;
  String name = '';
  String? proficiency;
  String? description;
  int? createdBy;
  String? createdAt;
  int? updatedBy;
  String? updatedAt;

  Skill({
    required this.id,
    required this.resume,
    required this.name,
    this.proficiency,
    this.description,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  Skill.fromJson(Map<String, dynamic> json) {
    resume = json['resume'];
    name = json['name'];
    proficiency = json['proficiency'];
    description = json['description'];
    id = json['id'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resume'] = resume;
    data['name'] = name;
    data['proficiency'] = proficiency;
    data['description'] = description;
    data['id'] = id;

    return data;
  }
}
