import 'dart:collection';

import 'package:hive/hive.dart';

part 'ord.g.dart';

@HiveType(typeId: 1)
class Ord extends HiveObject {
  @HiveField(0)
  String idOrd;

  @HiveField(1)
  DateTime startDate;

  @HiveField(2)
  DateTime endDate;

  @HiveField(3)
  List<String> times; // Times of the day for the medication

  @HiveField(4)
  List<Map<String, dynamic>> history;

  @HiveField(5)
  Map<DateTime, Map<String, int>> dailyStatus;
  // Instead of storing a single status per day, we store a map of statuses per time slot.

  @HiveField(6)
  String notes;

  Ord({
    required this.idOrd,
    required this.startDate,
    required this.endDate,
    required this.times,
    this.history = const [],
    this.dailyStatus = const {},
    this.notes = '',
  });

  /// Update status for a specific time slot on a given day
  void updateStatus(DateTime day, String time, int status) {
    final normalizedDay = DateTime(day.year, day.month, day.day);

    // Ensure the outer map is mutable
    if (dailyStatus is UnmodifiableMapView) {
      dailyStatus = Map.from(dailyStatus);
    }

    // Ensure the inner map exists and is mutable
    if (dailyStatus[normalizedDay] == null ||
        dailyStatus[normalizedDay] is! Map) {
      dailyStatus[normalizedDay] = {};
    } else if (dailyStatus[normalizedDay] is UnmodifiableMapView) {
      dailyStatus[normalizedDay] = Map.from(dailyStatus[normalizedDay]!);
    }

    // Now safely modify
    dailyStatus[normalizedDay]![time] = status;
  }

  /// Get status for a specific time slot on a given day
  int? getStatus(DateTime day, String time) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return dailyStatus[normalizedDay]?[time];
  }

  String? getStatusFromHistory(DateTime day, String time) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);

    // Filter the history list for the selected day and time
    List<Map<String, dynamic>> filteredHistory =
        history.where((entry) {
          DateTime entryDate = DateTime.parse(entry['date']);
          DateTime normalizedEntryDate = DateTime(
            entryDate.year,
            entryDate.month,
            entryDate.day,
          );

          return normalizedEntryDate.isAtSameMomentAs(normalizedDay) &&
              entry['time'] == time;
        }).toList();

    if (filteredHistory.isEmpty) {
      return null; // Return null if no matching history entry is found
    }

    // Sort the filtered history by date and time in descending order to get the most recent status
    filteredHistory.sort((a, b) {
      DateTime dateA = DateTime.parse(a['date']);
      DateTime dateB = DateTime.parse(b['date']);

      // First compare by date (latest first)
      if (dateA.isAfter(dateB)) return -1;
      if (dateA.isBefore(dateB)) return 1;

      // If dates are the same, compare by time (latest first)
      return a['time'].compareTo(b['time']);
    });

    // Return the status of the most recent entry
    return filteredHistory.first['status'];
  }
}
