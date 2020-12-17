class Education {
  final int personId;
  final int id;
  final String years;
  final String school;
  final String faculty;
  final String department;
  final String grade;
  final String notes;

  Education(
      {this.personId,
      this.id,
      this.years,
      this.school,
      this.faculty,
      this.department,
      this.grade,
      this.notes});

  Map<String, dynamic> toMap() {
    return {
      "personId": personId,
      "id": id,
      "years": years,
      "school": school,
      "faculty": faculty,
      "department": department,
      "grade": grade,
      "notes": notes,
    };
  }
}
