import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  MyAppBar({Key? key, required Widget title, required BuildContext context})
      : super(
          key: key,
          title: title,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black), // add a TextStyle for the title text
        );
}
