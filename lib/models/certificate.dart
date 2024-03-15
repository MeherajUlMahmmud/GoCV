class Certificate {
  int? resume;
  String? title;
  String? description;
  String? link;
  String? startDate;
  String? endDate;
  int? id;
  bool? isActive;
  bool? isDeleted;
  int? createdBy;
  String? createdAt;
  int? updatedBy;
  String? updatedAt;

  Certificate({
    this.resume,
    this.title,
    this.description,
    this.link,
    this.startDate,
    this.endDate,
    this.id,
    this.isActive,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  Certificate.fromJson(Map<String, dynamic> json) {
    resume = json['resume'];
    title = json['title'];
    description = json['description'];
    link = json['link'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    id = json['id'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }
}
