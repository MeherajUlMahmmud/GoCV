import 'package:gocv/models/user.dart';

class Award {
  int? resume;
  String? title;
  String? description;
  String? link;
  int? id;
  UserBase? createdBy;
  String? createdAt;
  UserBase? updatedBy;
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
    createdBy = json['created_by'] != null
        ? UserBase.fromJson(json['created_by'])
        : null;
    createdAt = json['created_at'];
    updatedBy = json['updated_by'] != null
        ? UserBase.fromJson(json['updated_by'])
        : null;
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resume'] = resume;
    data['title'] = title;
    data['description'] = description;
    data['link'] = link;
    data['id'] = id;
    if (createdBy != null) {
      data['created_by'] = createdBy!.toJson();
    }
    data['created_at'] = createdAt;
    if (updatedBy != null) {
      data['updated_by'] = updatedBy!.toJson();
    }
    data['updated_at'] = updatedAt;
    return data;
  }
}
