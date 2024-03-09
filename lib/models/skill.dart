class Skill {
  int id = 0;
  int resume = 0;
  String name = '';
  String? proficiency;
  String? description;
  bool? isActive;
  bool? isDeleted;
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
    this.isActive,
    this.isDeleted,
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
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }
}
