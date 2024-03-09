class Award {
  int? resume;
  String? title;
  String? description;
  String? link;
  int? id;
  bool? isActive;
  bool? isDeleted;
  int? createdBy;
  String? createdAt;
  int? updatedBy;
  String? updatedAt;

  Award(
      {this.resume,
      this.title,
      this.description,
      this.link,
      this.id,
      this.createdBy,
      this.createdAt,
      this.updatedBy,
      this.updatedAt});

  Award.fromJson(Map<String, dynamic> json) {
    resume = json['resume'];
    title = json['title'];
    description = json['description'];
    link = json['link'];
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
    data['title'] = title;
    data['description'] = description;
    data['link'] = link;
    data['id'] = id;
    return data;
  }
}
