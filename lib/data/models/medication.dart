import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'ord.dart';

part 'medication.g.dart';

@HiveType(typeId: 0)
class Medication extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<Ord> ords; // Treatment periods

  @HiveField(3)
  String type; // 'pill', 'sachet', or 'syringe'

  @HiveField(4)
  int colorValue; // Store color as int for Hive compatibility

  Medication({
    required this.id,
    required this.name,
    required this.ords,
    required this.type,
    required this.colorValue,
  });

  factory Medication.empty() => Medication(
    id: '',
    name: '',
    ords: [],
    type: 'pill',
    colorValue: Colors.red.value,
  );

  // Helper getter for color
  Color get color => Color(colorValue);
}
