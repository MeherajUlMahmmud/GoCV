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
    this.id,
    this.personId,
    this.years,
    this.school,
    this.faculty,
    this.department,
    this.grade,
    this.notes,
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
