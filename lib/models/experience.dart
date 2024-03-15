class Experience {
  int id = 0;
  int resume = 0;
  String companyName = '';
  String position = '';
  String type = '';
  String startDate = '';
  bool? isCurrent;
  String? endDate;
  String? description;
  double? salary;
  String? companyWebsite;
  bool? isActive;
  bool? isDeleted;
  int? createdBy;
  String? createdAt;
  int? updatedBy;
  String? updatedAt;

  Experience({
    required this.id,
    required this.resume,
    required this.companyName,
    required this.position,
    required this.type,
    required this.startDate,
    this.isCurrent,
    this.endDate,
    this.description,
    this.salary,
    this.companyWebsite,
    this.isActive,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  Experience.fromJson(Map<String, dynamic> json) {
    resume = json['resume'];
    companyName = json['company_name'];
    position = json['position'];
    type = json['type'];
    startDate = json['start_date'];
    isCurrent = json['is_current'];
    endDate = json['end_date'];
    description = json['description'];
    salary = json['salary'];
    companyWebsite = json['company_website'];
    id = json['id'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }
}
