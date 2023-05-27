import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_flutter/models/service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../locale/locale_controller.dart';
import '../../providers/auth.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/nav-drawer.dart';
import 'package:learning_flutter/dio.dart';
import '../processes/employee-list-page.dart';

SharedPreferences? sharedpref;

Future<SharedPreferences> initSharedPreferences() async {
  return await SharedPreferences.getInstance();
}

class MainTab extends StatefulWidget {
  MyLocaleController controller = Get.find();
  @override
  State<StatefulWidget> createState() {
    return _MainTab();
  }
}

class _MainTab extends State<MainTab> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<Service>> getServices() async {
    try {
      Dio.Response response = await dio()
          .get('/services', options: Dio.Options(headers: {'auth': true}));
      if (response.statusCode == 200) {
        List<dynamic> servicesData =
            json.decode(response.data.toString())['data'];
        List<Service> services =
            servicesData.map((service) => Service.fromJson(service)).toList();
        return services;
      } else {
        // Handle error response
        print('Request failed with status code ${response.statusCode}');
      }
    } catch (error) {
      // Handle Dio errors
      print('Error: $error');
    }

    return []; // Return an empty list if there is an error
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences().then((value) {
      sharedpref = value;
      setState(() {});
    });
    getServices();
    // log(getServices().toString());
  }

  @override
  Widget build(BuildContext context) {
    MyLocaleController controller = Get.find();

    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      appBar: MyAppBar(
        title: Text("welcome".tr),
        context: context,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<Auth>(builder: (context, auth, child) {
            String name = greeting(auth.user.name);
            return Column(
              children: [
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
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 80, bottom: 20, right: 10.0, left: 10.0),
                    child: Container(
                      height: 2000,
                      child: FutureBuilder<List<Service>>(
                        future: getServices(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                var item = snapshot.data![index];
                                return Card(
                                  elevation: 2,
                                  child: ListTile(
                                    title: Text(item.name),
                                    subtitle: Text(
                                        (item.duration ~/ 60).toString() +
                                            ' hours'),
                                    // minutes / 60
                                    leading: CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                                    trailing: Icon(Icons.arrow_forward),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EmployeeListPage(service: item),
                                        ),
                                      );
                                      // Handle item click here
                                      // Navigate to the employee list page or perform any desired action
                                    },
                                  ),
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return const Text('Failed to load services');
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ListTile(
                    title: Text(
                      textAlign: TextAlign.center,
                      sharedpref?.getString("curruntLang") == 'ar'
                          ? 'English'
                          : 'عربي',
                    ),
                    onTap: () {
                      controller.changeLang(
                          sharedpref?.getString("curruntLang") == 'ar'
                              ? 'en'
                              : 'ar');
                    },
                  ),
                ),
              ],
            );
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
