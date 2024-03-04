class Work {
  final int personId;
  final int id;
  final String jobTitle;
  final String company;
  final String department;
  final String years;
  final String notes;

  Work({
    required this.personId,
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.department,
    required this.years,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'personId': personId,
      'id': id,
      'jobTitle': jobTitle,
      'company': company,
      'department': department,
      'years': years,
      'notes': notes,
    };
  }
}
