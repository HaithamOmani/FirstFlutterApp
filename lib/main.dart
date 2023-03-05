import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:learning_flutter/app_style.dart';
import 'package:learning_flutter/components/appLocale.dart';
import 'package:learning_flutter/models/user.dart';
import 'package:learning_flutter/models/profit.dart';
import 'package:learning_flutter/providers/auth.dart';
import 'package:learning_flutter/size_config.dart';
import 'package:learning_flutter/widgets/nav-drawer.dart';
import 'package:provider/provider.dart';

import 'models/announcement.dart';

void main() {
  // const MyApp()
  runApp(ChangeNotifierProvider(create: (_) => Auth(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: Future.delayed(Duration(seconds: 3)),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            } else {
              return const MyHomePage(title: 'Al Waseet');
            }
          },
        ),
        localizationsDelegates: [
          AppLocale.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: const [Locale("en", ""), Locale("ar", "")],
        locale: const Locale("en", ""),
        localeResolutionCallback: (currentLang, supportLang) {
          for (Locale locale in supportLang) {
            if (locale.languageCode == currentLang!.languageCode) {
              return currentLang;
            }
          }
          return supportLang.first;
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final storage = new FlutterSecureStorage();
  void _attemptAuthentication() async {
    final key = await storage.read(key: 'auth');
    Provider.of<Auth>(context, listen: false).attempt(key!);
  }

  late Future<List<dynamic>> _futureProfits;
  List<PieChartSectionData> _chartData = [];
  @override
  void initState() {
    _attemptAuthentication();
    super.initState();
  }

  String greeting(String name) {
    name = name.split(" ")[0];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      drawer: NavDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          // padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Consumer<Auth>(builder: (context, auth, child) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      greeting(auth.user.name),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xff000000),
                        fontSize: 15.0,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Image.asset(
                        'assets/images/menu.png',
                        width: 40.0,
                      ),
                    )
                  ],
                ),
                Positioned(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.only(top: 30, bottom: 20),
                      child: Text(
                        '',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                FutureBuilder(
                  future: fetchAnnouncements(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Announcement>> snapshot) {
                    if (snapshot.hasError) {
                      // Display an error message if the future throws an error
                      return Center(
                          child: Text(
                              'An error occurred while fetching announcements'));
                    } else if (snapshot.hasData) {
                      return CarouselSlider.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                          final announcement = snapshot.data![index];
                          return Container(
                            width: 200,
                            height: 10,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // decoration: BoxDecoration(
                            //   border: Border.all(width: 1, color: Colors.grey),
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  announcement.content,
                                  style: TextStyle(
                                      letterSpacing: 0.5,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    announcement.date,
                                    style: TextStyle(fontSize: 9),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Text('abc')
              ],
            );
          }),
        ),
      ),
    );
  }
}

// Center(
//             child: Consumer<Auth>(builder: (context, auth, child) {
//               if (auth.authenticated) {
//                 // return const Text('You are logged in');
//                 return const Text('You are logged in');
//               } else {
//                 return const Text('You are not logged in');
//               }
//             }),
//           ),
//         ),

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // set the background color here
        child: Center(
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}

Future<List<Announcement>> fetchAnnouncements() async {
  try {
    var response =
        await Dio().get('https://more-sides.com/api/User/GetAnnouncements');
    Map<String, dynamic> data = response.data;
    List<dynamic> announcementData = data['announcements'];
    List<Announcement> announcements = [];
    for (var item in announcementData) {
      announcements.add(Announcement(
          id: item['id'], date: item['date'], content: item['content']));
    }
    return announcements;
  } catch (error) {
    print(error);
    return [];
  }
}

List<Profit> parseProfits(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Profit>((json) => Profit.fromJson(json)).toList();
}

Future<List<Profit>> fetchProfits() async {
  final response = await Dio().get('https://more-sides.com/api/User/Profits/6');
  if (response.statusCode == 200) {
    return parseProfits(response.data);
  } else {
    throw Exception('Failed to load profits');
  }
}
