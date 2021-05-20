import 'package:flutter/material.dart';

import 'main.dart';
import 'login.dart';


class TnT extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TnT',
      home: MyApp(),
      initialRoute: '/login',
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name == '/login') {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => LoginPage(),
        fullscreenDialog: true,
      );
    }
    else if (settings.name == '/home'){
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => MyApp(),
        fullscreenDialog: true,
      );
    }
  }
}