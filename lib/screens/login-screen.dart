import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:learning_flutter/providers/auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  void submit() {
    Provider.of<Auth>(context, listen: false).login(credentials: {
      'email': _email,
      'password': _password,
    });
    Navigator.pop(context);
    // log(_email);
    // log(_password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  initialValue: 'haithm-1@hotmail.com',
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'youe@somewhere.com',
                  ),
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                TextFormField(
                  initialValue: 'password',
                  decoration: const InputDecoration(labelText: 'Password'),
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      _formKey.currentState?.save();
                      this.submit();
                    },
                    child: Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
