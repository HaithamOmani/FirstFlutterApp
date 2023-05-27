import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:learning_flutter/components/appLocale.dart';
import 'package:learning_flutter/locale/locale_controller.dart';
import 'package:learning_flutter/models/service.dart';
import 'package:learning_flutter/providers/auth.dart';
import 'package:learning_flutter/screens/login-screen.dart';
import 'package:learning_flutter/screens/main-screen.dart';
import 'package:learning_flutter/widgets/nav-drawer.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:learning_flutter/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locale/locale.dart';

late SharedPreferences shaedpref;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  shaedpref = await SharedPreferences.getInstance();
  runApp(ChangeNotifierProvider(create: (_) => Auth(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(MyLocaleController());
    MyLocaleController controller = Get.put(MyLocaleController());

    return ScreenUtilInit(
      designSize: const Size(360, 740),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Al Waseet App',
        locale: shaedpref.getString("curruntLang") == null
            ? Get.deviceLocale
            : Locale(shaedpref.getString("curruntLang")!),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: Future.delayed(Duration(seconds: 3)),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            } else {
              // return new MainMenuScreen();
              // return const MyHomePage(title: 'Al Waseet');

              // var isLoggedIn = shaedpref.getString('authenticated').toString();
              // log('Is Logged: ' + isLoggedIn.toString());
              return Consumer<Auth>(
                builder: (context, auth, child) {
                  log('Auth: ' + auth.authenticated.toString());
                  if (auth.authenticated == 'true') {
                    return MainMenuScreen();
                  } else {
                    return LoginScreen();
                  }
                },
              );
            }
          },
        ),
        // ignore: prefer_const_literals_to_create_immutables
        localizationsDelegates: [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        translations: MyLocale(),
      ),
    );
  }
}

// the rest of your code...

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

  Future<List<Service>> getServices() async {
    Dio.Response response = await dio()
        .get('services', options: Dio.Options(headers: {'auth': true}));
    List<Map<String, dynamic>> data = response.data;
    return data.map((post) => Service.fromJson(post)).toList();
  }

  @override
  void initState() {
    _attemptAuthentication();
    getServices();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    // Consumer<Auth>(builder: (context, auth, child) {
    //   child:
    //   if (auth.authenticated) {
    //     // return const Text('You are logged in');
    //     // return const Text('You are logged in');
    //   } else {
    //     // return const Text('You are not logged in');
    //     Navigator.pushReplacementNamed(context, '/login');
    //     return Container();
    //   }
    //   return const Text('You are logged in');
    // });
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      drawer: NavDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          // padding: EdgeInsets.all(30),
          // padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Consumer<Auth>(builder: (context, auth, child) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (auth.authenticated)
                            ? greeting(auth.user.name)
                            : '', //greeting(auth.user.name)
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xff000000),
                          fontSize: 15.0,
                        ),
                      ),
                      // Spacer(),
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
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 20),
                    child: Text(
                      '',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FutureBuilder<List<Service>>(
                  future: getServices(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          var item = snapshot.data![index];
                          return InkWell(
                            onTap: () {},
                            child: Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.name,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Failed to load posts');
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
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
