class Employee {
  final int id;
  final String name;
  final String image;
  final String date_of_birth;
  final String religion;
  final String language;
  final int experience_in_months;
  final String nationality;
  final String country;

  Employee({
    required this.id,
    required this.name,
    required this.image,
    required this.date_of_birth,
    required this.religion,
    required this.language,
    required this.experience_in_months,
    required this.nationality,
    required this.country,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      date_of_birth: json['date_of_birth'] ?? '',
      religion: json['religion'] ?? '',
      language: json['language'] ?? '',
      experience_in_months: json['experience_in_months'] ?? 0,
      nationality: json['nationality'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
