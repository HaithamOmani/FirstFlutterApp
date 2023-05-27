import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api-files/api-time-slots.dart';
import '../screens/subscreens/contract-page.dart';
import '../widgets/custom-toast.dart';

class TimeSlots extends StatelessWidget {
  final String serviceId;
  final String selectedEmployeeId;
  final String selectedValue;
  final ApiTimeSlot apiService;

  TimeSlots({
    required this.serviceId,
    required this.selectedEmployeeId,
    required this.selectedValue,
    required this.apiService,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DateTime>>(
      future:
          apiService.getTimeSlots(serviceId, selectedEmployeeId, selectedValue),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          CustomToast.showToast(context, 'Error: Failed to load time slots');
          return Text('Error: Failed to load time slots');
        } else if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContractPage(
                          selectedDay:
                              DateFormat('h:mm a').format(item).toString(),
                          actualDate: item.toString(),
                          serviceId: serviceId,
                          employeeId: selectedEmployeeId.toString(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      DateFormat('h:mm a').format(item),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Text('No time slots available');
        }
      },
    );
  }
}
