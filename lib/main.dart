import 'package:flutter/material.dart';
import 'screens/syringe.dart'; // Import the new page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medication Reminder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SyringePage(), // Set the home page
      routes: {
        // Define routes for other pages here
        // '/otherPage': (context) => OtherPage(),
      },
    );
  }
}
