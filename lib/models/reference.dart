class Reference {
  int id = 0;
  int resume = 0;
  String name = '';
  String email = '';
  String? phone;
  String? companyName;
  String? position;
  String? description;
  String? portfolio;
  int? createdBy;
  String? createdAt;
  int? updatedBy;
  String? updatedAt;

  Reference({
    required this.id,
    required this.resume,
    required this.name,
    required this.email,
    this.phone,
    this.companyName,
    this.position,
    this.description,
    this.portfolio,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  Reference.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resume = json['resume'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    companyName = json['company_name'];
    position = json['position'];
    description = json['description'];
    portfolio = json['portfolio'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }
}
