import 'package:flutter/material.dart';

import 'contracts-screen/active-tab.dart';
import 'contracts-screen/expire-tab.dart';

class ContractsTab extends StatefulWidget {
  @override
  _ContractsPageState createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.settings,
                color: Colors.black), // Set the color property
            onPressed: () {},
          ),
        ],
        title: Text(
          'My Contracts',
          style: TextStyle(
            color: Colors.blue, // replace with your desired color
            fontSize: 16, // replace with your desired font size
            fontWeight:
                FontWeight.bold, // replace with your desired font weight
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'Active',
                style: TextStyle(
                  color: Colors.black45, // Replace with your desired color
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Expire',
                style: TextStyle(
                  color: Colors.black45, // Replace with your desired color
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ActiveContractsTab(),
          ExpireContractsTab(),
        ],
      ),
    );
  }
}
