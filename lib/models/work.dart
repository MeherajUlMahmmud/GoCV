class Work {
  final int personId;
  final int id;
  final String jobTitle;
  final String company;
  final String department;
  final String years;
  final String notes;

  Work({
    this.personId,
    this.id,
    this.jobTitle,
    this.company,
    this.department,
    this.years,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      "personId": personId,
      "id": id,
      "jobTitle": jobTitle,
      "company": company,
      "department": department,
      "years": years,
      "notes": notes,
    };
  }
}
