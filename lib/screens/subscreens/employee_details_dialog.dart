import 'package:flutter/material.dart';

class EmployeeDetailsDialog extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String religion;
  final String language;
  final int experienceInMonths;
  final String nationality;
  final String country;

  const EmployeeDetailsDialog({
    required this.imageUrl,
    required this.name,
    required this.religion,
    required this.language,
    required this.experienceInMonths,
    required this.nationality,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.infinity,
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}
