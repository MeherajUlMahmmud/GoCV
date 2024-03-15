class Interest {
  int resume = 0;
  String name = '';
  String? description;
  int id = 0;
  bool? isActive;
  bool? isDeleted;
  int? createdBy;
  String? createdAt;
  int? updatedBy;
  String? updatedAt;

  Interest({
    required this.resume,
    required this.name,
    this.description,
    required this.id,
    this.isActive,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  Interest.fromJson(Map<String, dynamic> json) {
    resume = json['resume'];
    name = json['name'];
    description = json['description'];
    id = json['id'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resume'] = resume;
    data['name'] = name;
    data['description'] = description;
    data['id'] = id;
    data['is_active'] = isActive;
    data['is_deleted'] = isDeleted;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_by'] = updatedBy;
    data['updated_at'] = updatedAt;
    return data;
  }
}
