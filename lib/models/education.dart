class Education {
  final int id;
  final int personId;
  final String years;
  final String school;
  final String faculty;
  final String department;
  final String grade;
  final String notes;

  Education({
    required this.id,
    required this.personId,
    required this.years,
    required this.school,
    required this.faculty,
    required this.department,
    required this.grade,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "personId": personId,
      "years": years,
      "school": school,
      "faculty": faculty,
      "department": department,
      "grade": grade,
      "notes": notes,
    };
  }
}
