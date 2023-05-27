import 'package:flutter/material.dart';
import 'package:learning_flutter/widgets/my_app_bar.dart';

class ContractPage extends StatelessWidget {
  final String selectedDay;
  final String actualDate;
  final String serviceId;
  final String employeeId;

  ContractPage({
    required this.selectedDay,
    required this.actualDate,
    required this.serviceId,
    required this.employeeId,
  });

  @override
  Widget build(BuildContext context) {
    // Implement your contract page UI and logic here
    // You can access the employeeId, serviceId, and selectedDay in this page
    return Scaffold(
      appBar: MyAppBar(
        title: Text('Contract Page'),
        context: context,
      ),
      body: SafeArea(
        child: Text('Employee Id: ' +
            employeeId +
            ' Service ID: ' +
            serviceId +
            ' Day: ' +
            selectedDay +
            ' Actual Date: ' +
            actualDate),
      ),
    );
  }
}
