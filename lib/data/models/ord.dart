import 'package:hive/hive.dart';

part 'ord.g.dart'; // For Hive code generation

@HiveType(typeId: 2) // Make sure this typeId is unique
class Ord {
  @HiveField(0)
  final String idOrd;
  @HiveField(1)
  final List<String> times;
  @HiveField(2)
  final String notes;
  @HiveField(3)
  final List<dynamic> history;
  @HiveField(4)
  final DateTime startDate; // New field
  @HiveField(5)
  final DateTime endDate; // New field

  Ord({
    required this.idOrd,
    required this.times,
    required this.notes,
    required this.history,
    required this.startDate,
    required this.endDate,
  });
}
