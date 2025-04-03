import 'package:hive/hive.dart';

part 'history.g.dart'; // Make sure to generate the adapter

@HiveType(typeId: 2) // Assign a unique typeId for this class
class History extends HiveObject {
  @HiveField(0)
  final String medicationId;

  @HiveField(1)
  final String ordId;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String time;

  @HiveField(4)
  final String status;

  History({
    required this.medicationId,
    required this.ordId,
    required this.date,
    required this.time,
    required this.status,
  });

  // You no longer need to manually write `toMap` and `fromMap` methods because Hive will generate those for you.
}
