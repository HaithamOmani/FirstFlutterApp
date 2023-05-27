import 'package:flutter/material.dart';

class EmployeeTimeSlotsBottomSheet extends StatelessWidget {
  final int serviceId;
  final int employeeId;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const EmployeeTimeSlotsBottomSheet({
    required this.serviceId,
    required this.employeeId,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor:
          0.9, // Change this value to adjust the size of the bottom sheet
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Contact Employee',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("You Selected:"),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text(selectedDate.toString()),
                Padding(
                  padding: EdgeInsets.all(20),
                ),
                // Add date picker widget here
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add future builder for time slots here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
