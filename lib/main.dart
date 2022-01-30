import 'package:cards/utils/secure_storage.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'constants.dart';

void main() {
  createSecureKey();
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
