import 'package:flutter/material.dart';

class Medicine {
  final String name;
  final List<TimeOfDay> doseTimes;
  final Color color;
  final DateTime startDate;
  final DateTime endDate;

  Medicine({
    required this.name,
    required this.doseTimes,
    required this.color,
    required this.startDate,
    required this.endDate,
  });

  Duration get duration => endDate.difference(startDate);
}
