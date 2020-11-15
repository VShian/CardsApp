import 'package:flutter/material.dart';

import 'home.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cards',
      theme: ThemeData(
        primaryColor: THEME_COLOR,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
