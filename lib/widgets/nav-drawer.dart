import 'package:flutter/material.dart';
import 'package:learning_flutter/screens/login-screen.dart';
import 'package:learning_flutter/screens/posts-screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/settings-screen.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<Auth>(
        builder: (context, auth, child) {
          if (auth.authenticated) {
            return ListView(
              children: [
                ListTile(title: Text(auth.user.name)),
                ListTile(
                  title: const Text('Posts'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PostsScreen()));
                  },
                ),
                ListTile(
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()));
                  },
                ),
                ListTile(
                  title: const Text('Logout'),
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                )
              ],
            );
          } else {
            return ListView(
              children: [
                ListTile(
                  title: const Text('Register'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PostsScreen()));
                  },
                ),
                ListTile(
                  title: const Text('Login'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
