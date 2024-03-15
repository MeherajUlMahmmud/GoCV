import 'package:gocv/models/award.dart';
import 'package:gocv/models/certificate.dart';
import 'package:gocv/models/contact.dart';
import 'package:gocv/models/education.dart';
import 'package:gocv/models/experience.dart';
import 'package:gocv/models/interest.dart';
import 'package:gocv/models/language.dart';
import 'package:gocv/models/personal.dart';
import 'package:gocv/models/reference.dart';
import 'package:gocv/models/skill.dart';
import 'package:gocv/models/user.dart';

class ResumePreview {
  String name = '';
  int id = 0;
  UserBase user = UserBase();
  Personal personal = Personal();
  Contact contact = Contact(id: 0, resume: 0, email: '');
  List<Education> education = [];
  List<Experience> experience = [];
  List<Skill> skill = [];
  List<Language> language = [];
  List<Interest> interest = [];
  List<Reference> reference = [];
  List<Award> award = [];
  List<Certificate> certification = [];
  bool? isEducationVisible;
  bool? isExperienceVisible;
  bool? isSkillVisible;
  bool? isLanguageVisible;
  bool? isInterestVisible;
  bool? isReferenceVisible;
  bool? isAwardVisible;
  bool? isCertificationVisible;
  bool? isActive;
  bool? isDeleted;
  int? createdBy;
  String? createdAt;
  int? updatedBy;
  String? updatedAt;

  ResumePreview({
    required this.name,
    required this.id,
    required this.user,
    required this.personal,
    required this.contact,
    required this.education,
    required this.experience,
    required this.skill,
    required this.language,
    required this.interest,
    required this.reference,
    required this.award,
    required this.certification,
    this.isEducationVisible,
    this.isExperienceVisible,
    this.isSkillVisible,
    this.isLanguageVisible,
    this.isInterestVisible,
    this.isReferenceVisible,
    this.isAwardVisible,
    this.isCertificationVisible,
    this.isActive,
    this.isDeleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  ResumePreview.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    user = (json['user'] != null ? UserBase.fromJson(json['user']) : null)!;
    personal = (json['personal'] != null
        ? Personal.fromJson(json['personal'])
        : null)!;
    contact =
        (json['contact'] != null ? Contact.fromJson(json['contact']) : null)!;
    if (json['education'] != null) {
      education = <Education>[];
      json['education'].forEach((v) {
        education.add(Education.fromJson(v));
      });
    }
    if (json['experience'] != null) {
      experience = <Experience>[];
      json['experience'].forEach((v) {
        experience.add(Experience.fromJson(v));
      });
    }
    if (json['skill'] != null) {
      skill = <Skill>[];
      json['skill'].forEach((v) {
        skill.add(Skill.fromJson(v));
      });
    }
    if (json['language'] != null) {
      language = <Language>[];
      json['language'].forEach((v) {
        language.add(Language.fromJson(v));
      });
    }
    if (json['interest'] != null) {
      interest = <Interest>[];
      json['interest'].forEach((v) {
        interest.add(Interest.fromJson(v));
      });
    }
    if (json['reference'] != null) {
      reference = <Reference>[];
      json['reference'].forEach((v) {
        reference.add(Reference.fromJson(v));
      });
    }
    if (json['award'] != null) {
      award = <Award>[];
      json['award'].forEach((v) {
        award.add(Award.fromJson(v));
      });
    }
    if (json['certification'] != null) {
      certification = <Certificate>[];
      json['certification'].forEach((v) {
        certification.add(Certificate.fromJson(v));
      });
    }
    isEducationVisible = json['is_education_visible'];
    isExperienceVisible = json['is_experience_visible'];
    isSkillVisible = json['is_skill_visible'];
    isLanguageVisible = json['is_language_visible'];
    isInterestVisible = json['is_interest_visible'];
    isReferenceVisible = json['is_reference_visible'];
    isAwardVisible = json['is_award_visible'];
    isCertificationVisible = json['is_certification_visible'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }
}
