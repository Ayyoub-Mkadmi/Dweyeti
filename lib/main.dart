import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test/components/bottom_nav_bar.dart';
import 'package:test/data/models/history.dart';
import 'package:test/data/models/medication.dart';
import 'package:test/data/models/ord.dart';
import 'package:test/data/repositories/history_repository.dart';
import 'package:test/data/repositories/medication_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(MedicationAdapter());
  Hive.registerAdapter(OrdAdapter());
  Hive.registerAdapter(HistoryAdapter());

  // ✅ Ensure repository is initialized before usage
  final repo = MedicationRepository();
  final historyRepo = HistoryRepository();
  await repo.init(); // This ensures it's fully initialized

  runApp(
    Provider<MedicationRepository>.value(
      value: repo, // Use Provider.value instead of FutureProvider
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
