import 'package:flutter/material.dart';
import 'package:test/pages/pill_page.dart';
import 'package:test/pages/sachet_page.dart';
import 'pages/syringe_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PillPage(),
      // home: SachetPage(),
      // home: SyringePage(),
    );
  }
}
