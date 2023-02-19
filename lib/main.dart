import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:learning_flutter/components/appLocale.dart';
import 'package:learning_flutter/providers/auth.dart';
import 'package:learning_flutter/widgets/nav-drawer.dart';
import 'package:provider/provider.dart';

void main() {
  // const MyApp()
  runApp(ChangeNotifierProvider(create: (_) => Auth(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const MyHomePage(title: 'Al Waseet'),
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
        // ignore: prefer_const_literals_to_create_immutables
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
  final storage = new FlutterSecureStorage();
  void _attemptAuthentication() async {
    final key = await storage.read(key: 'auth');
    Provider.of<Auth>(context, listen: false).attempt(key!);
  }

  @override
  void initState() {
    _attemptAuthentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: NavDrawer(),
      body: Center(
        child: Consumer<Auth>(builder: (context, auth, child) {
          if (auth.authenticated) {
            // return const Text('You are logged in');
            return const Text('You are logged in');
          } else {
            return const Text('You are not logged in');
          }
        }),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue, // set the background color here
        child: Center(
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
