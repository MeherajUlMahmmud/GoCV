class Education {
  int id = 0;
  int resume = 0;
  String schoolName = '';
  String? degree;
  String? department;
  String? gradeScale;
  String? grade;
  String startDate = '';
  bool? isCurrent;
  String? endDate;
  String? description;
  bool? isActive;
  bool? isDeleted;
  int? createdBy;
  String? createdAt;
  int? updatedBy;
  String? updatedAt;

  Education({
    required this.id,
    required this.resume,
    required this.schoolName,
    this.degree,
    this.department,
    this.gradeScale,
    this.grade,
    required this.startDate,
    this.isCurrent,
    this.endDate,
    this.description,
    this.isActive,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  Education.fromJson(Map<String, dynamic> json) {
    resume = json['resume'];
    schoolName = json['school_name'];
    degree = json['degree'];
    department = json['department'];
    gradeScale = json['grade_scale'];
    grade = json['grade'];
    startDate = json['start_date'];
    isCurrent = json['is_current'];
    endDate = json['end_date'];
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
    data['school_name'] = schoolName;
    data['degree'] = degree;
    data['department'] = department;
    data['grade_scale'] = gradeScale;
    data['grade'] = grade;
    data['start_date'] = startDate;
    data['is_current'] = isCurrent;
    data['end_date'] = endDate;
    data['description'] = description;
    data['id'] = id;

    return data;
  }
}
