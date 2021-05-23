import 'package:flutter/material.dart';

import 'main.dart';
import 'login.dart';
import 'addTimeTable.dart';
import 'editTimeTable.dart';


class TnT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TnT',
      home: MyHomePage(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => SplashScreen(),
        '/home': (context) => MyHomePage(),
        '/addTimeTable': (context) => addTimeTable(),
        '/editTimeTable': (context) => editTimeTable(),
      }
    );
  }
}