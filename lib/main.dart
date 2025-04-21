import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test/components/bottom_nav_bar.dart';
import 'package:test/data/models/medication.dart';
import 'package:test/data/models/ord.dart';
import 'package:test/data/repositories/medication_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(MedicationAdapter());
  Hive.registerAdapter(OrdAdapter());

  runApp(
    FutureProvider<MedicationRepository>(
      create: (context) async {
        final repo = MedicationRepository();
        await repo.init(); // Ensure initialization completes before usage
        return repo;
      },
      initialData:
          MedicationRepository(), // Provide a default instance as fallback
      child: MyApp(),
    ),
  );
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
      home: BottomNavBar(),
    );
  }
}
