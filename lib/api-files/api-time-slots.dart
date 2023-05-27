import 'dart:convert';
import 'package:dio/dio.dart' as Dio;
import 'package:learning_flutter/providers/auth.dart';

import '../dio.dart';
import '../widgets/custom-toast.dart';

class ApiTimeSlot {
  Future<List<DateTime>> getTimeSlots(serviceId, employee_Id, timestamp) async {
    try {
      Dio.Response response = await dio().get(
          '/calendar/${serviceId}/${employee_Id}/${timestamp}',
          options: Dio.Options(headers: {'auth': true}));
      // log('days: ' + response.toString());
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.data.toString());
        List<DateTime> daysOfWeek =
            data.map((day) => DateTime.parse(day)).toList();
        return daysOfWeek;
      } else {
        print('Request failed with status code ${response.statusCode}');
      }
    } catch (error) {
      // Handle Dio errors
      print('Error: $error');
    }

    return []; // Return an empty list as a fallback
  }
}
