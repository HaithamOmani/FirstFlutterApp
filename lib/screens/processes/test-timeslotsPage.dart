import 'dart:convert';
import 'dart:developer';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:learning_flutter/api-files/api-time-slots.dart';
import 'package:learning_flutter/models/employee.dart';
import 'package:learning_flutter/models/service.dart';
import 'package:learning_flutter/widgets/custom-toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dio/dio.dart' as Dio;
import '../../components/FullScreenImagePage.dart';
import '../../components/time-slot.dart';
import '../../dio.dart';
import '../../locale/locale_controller.dart';
import '../../providers/auth.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/nav-drawer.dart';
import '../subscreens/contract-page.dart';

SharedPreferences? sharedpref;

Future<SharedPreferences> initSharedPreferences() async {
  return await SharedPreferences.getInstance();
}

class EmployeeListPage extends StatefulWidget {
  final Service service;

  EmployeeListPage({required this.service});

  @override
  State<StatefulWidget> createState() {
    return _EmployeeListPageState();
  }
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<Employee>> getEmployees() async {
    try {
      Dio.Response response = await dio().get('/employees/${widget.service.id}',
          options: Dio.Options(headers: {'auth': true}));
      // log('employee: ' + response.toString());
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.data.toString())['data'];
        List<Employee> employees =
            data.map((employee) => Employee.fromJson(employee)).toList();
        // log('employee: ' + employees.toString());
        return employees;
      } else {
        CustomToast.showToast(context, 'Alert: no workers available');
        print('Request failed with status code ${response.statusCode}');
      }
    } catch (error) {
      // Handle Dio errors
      CustomToast.showToast(context, 'Alert: no workers available');
      print('Error: $error');
    }

    return []; // Return an empty list if there is an error
  }

  // Future<List<DateTime>> getTimeSlots(serviceId, employee_Id, timestamp) async {
  //   try {
  //     Dio.Response response = await dio().get(
  //         '/calendar/${serviceId}/${employee_Id}/${timestamp}',
  //         options: Dio.Options(headers: {'auth': true}));
  //     // log('days: ' + response.toString());
  //     if (response.statusCode == 200) {
  //       List<dynamic> data = json.decode(response.data.toString());
  //       List<DateTime> daysOfWeek =
  //           data.map((day) => DateTime.parse(day)).toList();
  //       return daysOfWeek;
  //     } else {
  //       CustomToast.showToast(context, 'Alert: Failed to load time slots');
  //       print('Request failed with status code ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     CustomToast.showToast(context, 'Alert: Failed to load time slots');
  //     // Handle Dio errors
  //     print('Error: $error');
  //   }

  //   return []; // Return an empty list as a fallback
  // }

  @override
  void initState() {
    super.initState();
    initSharedPreferences().then((value) {
      sharedpref = value;
      setState(() {});
      // CustomToast.showToast(context, 'Error: Failed to load time slots');
      // getTimeSlots(1, 1, '2023-05-18');
      // log('WOW: ' + getTimeSlots(serviceId, employee_Id, timestamp).toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    MyLocaleController controller = Get.find();
    DatePickerController _controller = DatePickerController();
    DateTime _selectedValue = DateTime.now();

    return Scaffold(
      key: _scaffoldKey,
      // drawer: NavDrawer(),
      appBar: MyAppBar(
        title: Text("welcome".tr),
        context: context,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<Auth>(builder: (context, auth, child) {
            String name = greeting(auth.user.name);
            return Column(children: [
              Padding(
                padding: EdgeInsets.all(17.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (auth.authenticated) ? name : '',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xff000000),
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(17.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 80, bottom: 20, right: 10.0, left: 10.0),
                  child: Container(
                    height: 2000,
                    child: FutureBuilder<List<Employee>>(
                      future: getEmployees(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              var item = snapshot.data![index];
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: Material(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: InkWell(
                                    onTap: () {
                                      int selectedEmployeeId = item.id;
                                      // showDialog(
                                      //   context: context,
                                      //   builder: (_) => Dialog(
                                      //     child: Container(
                                      //       width: double.infinity,
                                      //       child: Image.network(item.image,
                                      //           fit: BoxFit.cover),
                                      //     ),
                                      //   ),
                                      // );
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return FractionallySizedBox(
                                                heightFactor:
                                                    0.9, // Change this value to adjust the size of the bottom sheet
                                                child: Container(
                                                  padding: EdgeInsets.all(20.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        'Contact Employee',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text("You Selected:"),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                          ),
                                                          Text(_selectedValue
                                                              .toString()),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20),
                                                          ),
                                                          Container(
                                                            child: DatePicker(
                                                              DateTime.now(),
                                                              width: 60,
                                                              height: 80,
                                                              controller:
                                                                  _controller,
                                                              initialSelectedDate:
                                                                  DateTime
                                                                      .now(),
                                                              selectionColor:
                                                                  Colors.black,
                                                              selectedTextColor:
                                                                  Colors.white,
                                                              inactiveDates: [
                                                                DateTime.now()
                                                                    .add(Duration(
                                                                        days:
                                                                            3)),
                                                                DateTime.now()
                                                                    .add(Duration(
                                                                        days:
                                                                            4)),
                                                                DateTime.now()
                                                                    .add(Duration(
                                                                        days:
                                                                            7)),
                                                              ],
                                                              onDateChange:
                                                                  (date) {
                                                                // New date selected
                                                                setState(() {
                                                                  _selectedValue =
                                                                      DateTime(
                                                                    date.year,
                                                                    date.month,
                                                                    date.day,
                                                                  );
                                                                  _selectedValue =
                                                                      date;
                                                                  log(_selectedValue
                                                                      .toLocal()
                                                                      .toString()
                                                                      .split(
                                                                          ' ')[0]);
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              TextButton(
                                                                child: Text(
                                                                    'CANCEL'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 20),
                                                        ],
                                                      ),
                                                      SizedBox(height: 20),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            TimeSlots(
                                                              serviceId:
                                                                  '${widget.service.id}',
                                                              selectedEmployeeId:
                                                                  selectedEmployeeId
                                                                      .toString(),
                                                              selectedValue:
                                                                  _selectedValue
                                                                      .toLocal()
                                                                      .toString()
                                                                      .split(
                                                                          ' ')[0],
                                                              apiService:
                                                                  ApiTimeSlot(),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Expanded(
                                                      //   child: Column(
                                                      //     crossAxisAlignment:
                                                      //         CrossAxisAlignment
                                                      //             .start,
                                                      //     children: [
                                                      //       FutureBuilder<
                                                      //           List<DateTime>>(
                                                      //         future:
                                                      //             getTimeSlots(
                                                      //           '${widget.service.id}',
                                                      //           selectedEmployeeId,
                                                      //           _selectedValue
                                                      //                   .toLocal()
                                                      //                   .toString()
                                                      //                   .split(
                                                      //                       ' ')[
                                                      //               0], // Pass the selected date to getTimeSlots
                                                      //         ),
                                                      //         builder: (context,
                                                      //             snapshot) {
                                                      //           if (snapshot
                                                      //                   .connectionState ==
                                                      //               ConnectionState
                                                      //                   .waiting) {
                                                      //             return CircularProgressIndicator();
                                                      //           } else if (snapshot
                                                      //               .hasError) {
                                                      //             CustomToast
                                                      //                 .showToast(
                                                      //                     context,
                                                      //                     'Error: Failed to load time slots');
                                                      //             return Text(
                                                      //                 'Error: Failed to load time slots'); // return error text
                                                      //             // return Text(
                                                      //             //     'Failed to load time slots');
                                                      //           } else if (snapshot
                                                      //               .hasData) {
                                                      //             return Expanded(
                                                      //               child: ListView
                                                      //                   .builder(
                                                      //                 itemCount: snapshot
                                                      //                     .data
                                                      //                     ?.length,
                                                      //                 itemBuilder:
                                                      //                     (context,
                                                      //                         index) {
                                                      //                   var item =
                                                      //                       snapshot.data![index];
                                                      //                   return GestureDetector(
                                                      //                     onTap:
                                                      //                         () {
                                                      //                       Navigator.push(
                                                      //                         context,
                                                      //                         MaterialPageRoute(
                                                      //                           builder: (context) => ContractPage(
                                                      //                             selectedDay: DateFormat('h:mm a').format(item).toString(),
                                                      //                             actualDate: item.toString(),
                                                      //                             serviceId: '${widget.service.id}',
                                                      //                             employeeId: selectedEmployeeId.toString(),
                                                      //                           ),
                                                      //                         ),
                                                      //                       );
                                                      //                     },
                                                      //                     child:
                                                      //                         Container(
                                                      //                       padding:
                                                      //                           EdgeInsets.all(12),
                                                      //                       child:
                                                      //                           Text(
                                                      //                         DateFormat('h:mm a').format(item),
                                                      //                         style: TextStyle(
                                                      //                           fontSize: 16,
                                                      //                           fontWeight: FontWeight.bold,
                                                      //                         ),
                                                      //                       ),
                                                      //                     ),
                                                      //                   );
                                                      //                 },
                                                      //               ),
                                                      //             );
                                                      //           } else {
                                                      //             return Text(
                                                      //                 'No time slots available');
                                                      //           }
                                                      //         },
                                                      //       ),
                                                      //     ],
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            item.image,
                                            height: 200,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.name,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Religion: ${item.religion}\nLanguage: ${item.language}',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Experience: ${item.experience_in_months} months\nNationality: ${item.nationality}\nCountry: ${item.country}',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                SizedBox(height: 10),
                                                ButtonBar(
                                                  alignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      child: Text(
                                                        'Select',
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        int selectedEmployeeId =
                                                            item.id;
                                                        // log('Select employee id: ' +
                                                        // selectedEmployeeId
                                                        //     .toString());
                                                        showModalBottomSheet(
                                                          context: context,
                                                          isScrollControlled:
                                                              true,
                                                          builder: (BuildContext
                                                              context) {
                                                            return StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                                return FractionallySizedBox(
                                                                  heightFactor:
                                                                      0.9, // Change this value to adjust the size of the bottom sheet
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            20.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          'Select date: ',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                20),
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            Text("You Selected:"),
                                                                            Padding(
                                                                              padding: EdgeInsets.all(10),
                                                                            ),
                                                                            Text(_selectedValue.toString()),
                                                                            Padding(
                                                                              padding: EdgeInsets.all(20),
                                                                            ),
                                                                            Container(
                                                                              child: DatePicker(
                                                                                DateTime.now(),
                                                                                width: 60,
                                                                                height: 80,
                                                                                controller: _controller,
                                                                                initialSelectedDate: DateTime.now(),
                                                                                selectionColor: Colors.blue,
                                                                                selectedTextColor: Colors.white,
                                                                                // inactiveDates: [
                                                                                //   DateTime.now().add(Duration(days: 3)),
                                                                                //   DateTime.now().add(Duration(days: 4)),
                                                                                //   DateTime.now().add(Duration(days: 7)),
                                                                                // ],
                                                                                onDateChange: (date) {
                                                                                  // New date selected
                                                                                  setState(() {
                                                                                    _selectedValue = DateTime(
                                                                                      date.year,
                                                                                      date.month,
                                                                                      date.day,
                                                                                    );
                                                                                    _selectedValue = date;
                                                                                    log(_selectedValue.toLocal().toString().split(' ')[0]);
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 20),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                TextButton(
                                                                                  child: Text('CANCEL'),
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 20),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                20),
                                                                        Expanded(
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              TimeSlots(
                                                                                serviceId: '${widget.service.id}',
                                                                                selectedEmployeeId: selectedEmployeeId.toString(),
                                                                                selectedValue: _selectedValue.toLocal().toString().split(' ')[0],
                                                                                apiService: ApiTimeSlot(),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),

                                                                        // Expanded(
                                                                        //   child:
                                                                        //       Column(
                                                                        //     crossAxisAlignment:
                                                                        //         CrossAxisAlignment.start,
                                                                        //     children: [
                                                                        //       FutureBuilder<List<DateTime>>(
                                                                        //         future: getTimeSlots(
                                                                        //           '${widget.service.id}',
                                                                        //           selectedEmployeeId,
                                                                        //           _selectedValue.toLocal().toString().split(' ')[0], // Pass the selected date to getTimeSlots
                                                                        //         ),
                                                                        //         builder: (context, snapshot) {
                                                                        //           if (snapshot.connectionState == ConnectionState.waiting) {
                                                                        //             return CircularProgressIndicator();
                                                                        //           } else if (snapshot.hasError) {
                                                                        //             return Text('Failed to load time slots');
                                                                        //           } else if (snapshot.hasData) {
                                                                        //             return Expanded(
                                                                        //               child: ListView.builder(
                                                                        //                 itemCount: snapshot.data?.length,
                                                                        //                 itemBuilder: (context, index) {
                                                                        //                   var item = snapshot.data![index];
                                                                        //                   return GestureDetector(
                                                                        //                     onTap: () {
                                                                        //                       Navigator.push(
                                                                        //                         context,
                                                                        //                         MaterialPageRoute(
                                                                        //                           builder: (context) => ContractPage(
                                                                        //                             selectedDay: DateFormat('h:mm a').format(item).toString(),
                                                                        //                             actualDate: item.toString(),
                                                                        //                             serviceId: '${widget.service.id}',
                                                                        //                             employeeId: selectedEmployeeId.toString(),
                                                                        //                           ),
                                                                        //                         ),
                                                                        //                       );
                                                                        //                     },
                                                                        //                     child: Container(
                                                                        //                       padding: EdgeInsets.all(12),
                                                                        //                       child: Text(
                                                                        //                         DateFormat('h:mm a').format(item),
                                                                        //                         style: TextStyle(
                                                                        //                           fontSize: 16,
                                                                        //                           fontWeight: FontWeight.bold,
                                                                        //                         ),
                                                                        //                       ),
                                                                        //                     ),
                                                                        //                   );
                                                                        //                 },
                                                                        //               ),
                                                                        //             );
                                                                        //           } else {
                                                                        //             return Text('No time slots available');
                                                                        //           }
                                                                        //         },
                                                                        //       ),
                                                                        //     ],
                                                                        //   ),
                                                                        // ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text('Failed to load services');
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ]);
          }),
        ),
      ),
    );
  }
}

String greeting(String name) {
  name = name.split(" ")[0];

  Consumer<Auth>(builder: (context, auth, child) {
    child:
    if (auth.authenticated) {
      // return const Text('You are logged in');
      name = name;
      // return const Text('You are logged in');
    } else {
      name = ' ';
      // return const Text('You are not logged in');
      // Navigator.pushReplacementNamed(context, '/login');
      // return Container();
    }
    return const Text('You are logged in');
  });

  var hour = DateTime.now().hour;
  if (hour < 12) {
    var auth;
    return 'Good Morning ${name}';
  }
  if (hour < 17) {
    return 'Good Afternoon $name';
  }
  return 'Good Evening $name';
}
