import 'package:hive/hive.dart';

part 'ord.g.dart';

@HiveType(typeId: 1) // Note: typeId must be unique across all models
class Ord extends HiveObject {
  @HiveField(0)
  final String idOrd; // Made final since IDs shouldn't change

  @HiveField(1)
  String frequency;

  @HiveField(2)
  List<String> times;

  @HiveField(3)
  String notes;

  @HiveField(4)
  List<Map<String, dynamic>> history;

  Ord({
    required this.idOrd,
    this.frequency = 'daily', // Default value
    List<String>? times, // Made optional with default
    this.notes = '', // Default value
    List<Map<String, dynamic>>? history, // Optional with default
  }) : times = times ?? [],
       history = history ?? [];

  // Add a factory constructor for convenience
  factory Ord.create({
    required String idOrd,
    String frequency = 'daily',
    List<String> times = const [],
    String notes = '',
    List<Map<String, dynamic>> history = const [],
  }) {
    return Ord(
      idOrd: idOrd,
      frequency: frequency,
      times: times,
      notes: notes,
      history: history,
    );
  }

  // Helper method to add a time
  void addTime(String time) {
    times.add(time);
  }

  // Helper method to add history entry
  void addHistoryEntry(Map<String, dynamic> entry) {
    history.add(entry);
  }
}
