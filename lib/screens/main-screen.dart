import 'package:flutter/material.dart';
import 'package:learning_flutter/screens/tabs/main-tab.dart';

import '../widgets/nav-drawer.dart';
import 'tabs/contracts-tab.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenuScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  final List<Widget> _children = [
    MainTab(),
    ContractsTab(),
    TabThree(),
    TabFour(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue, // add this line
        unselectedItemColor: Colors.grey, // set the unselected tabs color
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'My Contracts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tab Three',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Tab Four',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class TabTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tab Two',
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}

class TabThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tab Three',
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}

class TabFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tab Four',
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
